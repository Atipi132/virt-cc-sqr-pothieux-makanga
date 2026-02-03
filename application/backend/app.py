import os
import uuid
import json
import pika
import redis
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for Frontend communication

# Configuration from Environment Variables (Best Practice for Kubernetes/Docker)
REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
RABBITMQ_HOST = os.environ.get('RABBITMQ_HOST', 'localhost')

# Connect to Redis
try:
    r = redis.Redis(host=REDIS_HOST, port=6379, db=0, decode_responses=True)
except Exception as e:
    print(f"Error connecting to Redis: {e}")

# Helper to send message to RabbitMQ
def send_to_queue(message):
    connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBITMQ_HOST))
    channel = connection.channel()
    channel.queue_declare(queue='task_queue', durable=True)
    
    channel.basic_publish(
        exchange='',
        routing_key='task_queue',
        body=json.dumps(message),
        properties=pika.BasicProperties(
            delivery_mode=pika.spec.PERSISTENT_DELIVERY_MODE
        ))
    connection.close()

@app.route('/api/calculate', methods=['POST'])
def calculate():
    """
    Receives a calculation request (e.g., "5+5"), generates an ID,
    pushes it to RabbitMQ, and returns the ID.
    """
    try:
        data = request.get_json()
        calculation = data.get('calculation')

        if not calculation:
            return jsonify({'error': 'No calculation provided'}), 400

        # Generate a unique ID for this task
        task_id = str(uuid.uuid4())

        # Create the payload
        message = {
            'id': task_id,
            'calculation': calculation
        }

        if r:
            r.set(task_id, 'PENDING')

        send_to_queue(message)

        return jsonify({'task_id': task_id}), 202

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/result/<task_id>', methods=['GET'])
def get_result(task_id):
    """
    Checks Redis for the result of a specific task ID.
    """
    try:
        # Fetch result from Redis
        result = r.get(task_id)

        if result is None:
            return jsonify({'status': 'Not Found'}), 404
        
        if result == 'PENDING':
             return jsonify({'status': 'Pending'}), 202

        return jsonify({'task_id': task_id, 'result': result, 'status': 'Completed'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)