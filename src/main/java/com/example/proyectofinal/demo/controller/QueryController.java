package com.example.proyectofinal.demo.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.proyectofinal.demo.service.HsCodeService;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/query")
public class QueryController {

    private final HsCodeService queryService;

    public QueryController(HsCodeService queryService) {
        this.queryService = queryService;
    }

    @PostMapping
    public Flux<String> processQuery(@RequestBody String query) {
        if (query == null || query.isBlank()) {
            return Flux.just("Query cannot be empty");
        }

        if ("exit".equalsIgnoreCase(query.trim())) {
            return Flux.just("Use client-side to stop sending requests.");
        }

        return queryService.processQuery(query);
    }
}
