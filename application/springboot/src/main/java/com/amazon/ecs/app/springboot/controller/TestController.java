package main.java.com.amazon.ecs.app.springboot.controller;

@GetController
public class TestController {

    @GetMapping(path = "/test")
    public ResponseEntity<String> testMethod() {
        return ResponseEntity.ok("Hello from Spring Boot App running on AWS ECS");
    }
}
