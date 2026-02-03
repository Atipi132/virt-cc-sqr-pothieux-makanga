import os
import json
import pika
import redis
import time

# Configuration via variables d'environnement
RABBITMQ_HOST = os.environ.get('RABBITMQ_HOST', 'localhost')
REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
QUEUE_NAME = 'task_queue'

# Connexion à Redis
try:
    r = redis.Redis(host=REDIS_HOST, port=6379, db=0, decode_responses=True)
except Exception as e:
    print(f"Erreur de connexion Redis: {e}")

# Fonction de connexion à RabbitMQ avec retries (car RabbitMQ peut être lent à démarrer)
def get_rabbitmq_connection():
    while True:
        try:
            connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBITMQ_HOST))
            return connection
        except pika.exceptions.AMQPConnectionError: # type: ignore
            print("En attente de RabbitMQ...")
            time.sleep(5)

def callback(ch, method, properties, body):
    """Fonction appelée à chaque message reçu"""
    print(f" [x] Reçu {body}")
    data = json.loads(body)
    task_id = data.get('id')
    calculation = data.get('calculation')

    result = None
    try:
        # Sécurité basique : on n'autorise que les caractères mathématiques
        allowed = set("0123456789+-*/.()")
        if not set(calculation).issubset(allowed):
            raise ValueError("Caractères non autorisés")

        # Évaluation du calcul
        # Note: eval() est utilisé ici pour la simplicité du projet école. 
        # En prod, utiliser une lib de parsing sécurisée.
        result = str(eval(calculation))
        
    except ZeroDivisionError:
        result = "Erreur: Division par zéro"
    except Exception as e:
        result = f"Erreur: {str(e)}"

    print(f" [.] Résultat pour {task_id}: {result}")

    # Stockage dans Redis
    # On stocke directement le résultat. Le backend détectera que ce n'est plus "PENDING".
    if r:
        r.set(task_id, result)

    # Acquittement du message (suppression de la file)
    ch.basic_ack(delivery_tag=method.delivery_tag)

# Démarrage du consommateur
def start_consumer():
    connection = get_rabbitmq_connection()
    channel = connection.channel()

    # Assure que la queue existe
    channel.queue_declare(queue=QUEUE_NAME, durable=True)

    # Une seule tâche à la fois par worker
    channel.basic_qos(prefetch_count=1)
    
    channel.basic_consume(queue=QUEUE_NAME, on_message_callback=callback)

    print(' [*] En attente de calculs. CTRL+C pour quitter.')
    channel.start_consuming()

if __name__ == '__main__':
    start_consumer()