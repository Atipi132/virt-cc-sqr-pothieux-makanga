FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Variables d'environnement par défaut
ENV RABBITMQ_HOST=rabbitmq
ENV REDIS_HOST=redis
# PYTHONUNBUFFERED permet de voir les logs instantanément dans Docker/K8s
ENV PYTHONUNBUFFERED=1

CMD ["python", "consumer.py"]