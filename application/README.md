# README for the application part of the project

# Application - Cloud Native Calculator

This directory contains the source code for the microservices constituting the calculator application.

## Microservices Architecture

The application is decoupled into three distinct components to ensure scalability and resilience.

```mermaid
graph LR
    user([User]) -->|HTTP| F[Frontend]
    F -->|POST /api/calculate| B[Backend]
    B -->|Publish Task| Q[RabbitMQ]
    C[Consumer] -->|Consume Task| Q
    C -->|Set Result| R[(Redis)]
    B -->|GET Result| R
``