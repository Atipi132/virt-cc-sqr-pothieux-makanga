# README for the Kubernetes part of the project*

# Kubernetes Deployment

This directory contains the manifests required to deploy the Calculator application on the Kubernetes cluster.

## Deployment Overview

The application is deployed in a specific namespace (implied `default` or student specific). It utilizes standard Kubernetes objects:

* **ReplicaSets:** To ensure the desired number of pods are running.
* **Services:** To expose pods internally (ClusterIP) or externally.
* **Ingress:** To route HTTP traffic from the outside world to our services.

## Manifests Description

### Infrastructure Components
* `redis-replicaset.yaml`: Deploys a **Redis** (v8.0.2) instance for state management.
* `rabbitmq-replicaset.yaml`: Deploys a **RabbitMQ** (v3.12) broker for message queuing.

### Application Components
* `backend-replicaset.yaml`: Deploys the Flask API.
    * *Env Vars:* Connects to `redis-replicaset` and `rabbitmq-replicaset`.
* `frontend-replicaset.yaml`: Deploys the Nginx frontend.
* `consumer-replicaset.yaml`: Deploys the Python worker.
    * *Env Vars:* Connects to `redis-replicaset` and `rabbitmq-replicaset`.

### Networking
* **Ingress Object (`ingress-object.yaml`)**:
    * Uses `ingressClassName: nginx`.
    * **Host:** `calculatrice-makanga-pothieux.polytech-dijon.kiowy.net`
    * **Routing Rules:**
        * `/` -> Forwards to `makanga-pothieux-frontend-rs` (Port 80).
        * `/api` -> Forwards to `makanga-pothieux-backend-rs` (Port 5000).