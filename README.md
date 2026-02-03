# virt-cc-sqr-pothieux-makanga
Repository for the lab work of [@JeromeMSD](https://github.com/JeromeMSD)'s [2025 Polytech Dijon Cloud Computing course](https://github.com/JeromeMSD/module_virtualisation-et-cloud-computing).
 
Students working on this project : 
* Christ-Roi Makanga ([Christ-droid](https://github.com/Christ-droid))
* Hugo Pothieux ([atipi132](https://github.com/Atipi132))

## Repository Structure

* [`foundation/`](./foundation): Contains Terraform configuration files to provision the infrastructure on Scaleway.
* [`application/`](./application): Contains the source code for the Backend, Frontend, and Consumer microservices, along with their Dockerfiles.
* [`kubernetes/`](./kubernetes): Contains Kubernetes manifests (ReplicaSets, Services, Ingress) to deploy the application.
* [`TD/`](./TD/): Previous lab work (archived).

## Technologies Used

* **Infrastructure:** Terraform, Scaleway Provider.
* **Orchestration:** Kubernetes (K8s), Ingress Nginx.
* **Backend:** Python, Flask.
* **Frontend:** HTML5, CSS3, JavaScript, Nginx.
* **Messaging & Storage:** RabbitMQ, Redis.
* **CI/CD & Containers:** Docker, Google Cloud