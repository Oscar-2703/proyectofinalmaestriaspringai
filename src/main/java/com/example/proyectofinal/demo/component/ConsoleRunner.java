package com.example.proyectofinal.demo.component;

import java.util.Scanner;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import com.example.proyectofinal.demo.service.HsCodeService;

@Profile("index")
@Component
class IndexRunner implements CommandLineRunner { 
    private final HsCodeService queryService;

    public IndexRunner(
                         HsCodeService queryService) {
        this.queryService = queryService;
    }

    @Override
    public void run(String... args) throws Exception {
        queryService.index("data/hts_codes_WebScrapped.csv");
        System.out.println("Indexing completed.");
    }
 }

@Profile("query")
@Component
class QueryRunner implements CommandLineRunner { 
    private final HsCodeService queryService;

    public QueryRunner(
                         HsCodeService queryService) {
        this.queryService = queryService;
    }

    @Override
    public void run(String... args) {
        // default = query mode
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.print("Enter query: ");
            String query = scanner.nextLine();

            if ("exit".equalsIgnoreCase(query)) break;

            String result = queryService.processQuery(query);
            System.out.println("Result: " + result);
        }
    }
 }
