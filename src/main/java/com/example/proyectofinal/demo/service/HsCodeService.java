package com.example.proyectofinal.demo.service;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.document.Document;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Service;

import com.opencsv.CSVReader;

import reactor.core.publisher.Flux;

@Service
public class HsCodeService {

    private final ChatClient chatClient;
    private final VectorStore vectorStore;

    public HsCodeService(ChatClient.Builder builder,
                         VectorStore vectorStore) {
        this.chatClient = builder.build();
        this.vectorStore = vectorStore;
    }

    public void index(String filePath) throws Exception {

    List<Document> documents = new ArrayList<>();

    var resource = new ClassPathResource(filePath);

    try (CSVReader reader = new CSVReader(
            new InputStreamReader(resource.getInputStream())
    )) {
        String[] line;
        reader.readNext(); // skip header

        while ((line = reader.readNext()) != null) {
            String htsCode = line[0];
            String description = line[1];

            documents.add(new Document(
                description,
                Map.of("source", htsCode)
            ));
        }
    }

    int batchSize = 50;

    for (int i = 0; i < documents.size(); i += batchSize) {
        int end = Math.min(i + batchSize, documents.size());
        List<Document> batch = documents.subList(i, end);

        vectorStore.write(batch);

        System.out.println("Inserted batch: " + i + " - " + end);
    }

    System.out.println("Indexed documents: " + documents.size());
}

    public Flux<String> processQuery(String query) {

        // same logic as before
        String processed = chatClient.prompt()
                .user(u -> u
                    .text("Extract keywords and translate to English: {q}")
                    .param("q", query)
                )
                .call()
                .content();

        // retrieval now uses Ollama embeddings automatically
        List<Document> docs = vectorStore.similaritySearch(processed);

        String context = docs.stream()
        .map(doc -> {
            String content = doc.getFormattedContent();
            Object hsCode = doc.getMetadata().get("hs_code"); // or "source"

            return "HS_CODE: " + hsCode + "\nDESCRIPTION: " + content;
        })
        .reduce("", (a, b) -> a + "\n\n" + b);

        return chatClient.prompt()
                .user(u -> u
                    .text("""
                    You must return ONLY the HS code from metadata.

                    context:
                    {context}

                    question:
                    {q}
                """)
                    .param("context", context)
                    .param("q", processed)
                )
                .stream()
                .content();
    }
}
