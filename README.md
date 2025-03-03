# Compound Interest Calculator API

🚀 Overview

The Compound Interest Calculator API calculates compound interest with monthly contributions and provides a yearly breakdown of investment growth. Built with FastAPI, it supports asynchronous processing and is containerized for easy deployment.

## 🛠 Getting Started

### 🔹 1. Prerequisites

Ensure you have the following installed:
- Docker
- Git
- Minikube (for local Kubernetes deployment)
- kubectl (Kubernetes command-line tool)

### 🔹 2. Clone the Repository

```bash
git clone https://github.com/your-username/compound-interest-api.git
cd compound-interest-api
```

### 🔹 3. Deployment Options

You can run this API either using Docker directly or deploy it to Kubernetes using Minikube.

#### Option A: Run with Docker

Build the Docker image:
```bash
docker build -t compound-interest-api .
```

Run the container:
```bash
docker run -d -p 8000:8000 compound-interest-api
```

#### Option B: Deploy to Kubernetes (Minikube)

1. Start Minikube:
```bash
minikube start
```

2. Build the Docker image in Minikube's environment:
```bash
eval $(minikube docker-env)
docker build -t compound-interest-api:latest .
```

3. Deploy to Kubernetes:
```bash
kubectl apply -f k8s-manifest.yaml
```

4. Access the service (choose one method):

   Method 1 - Port forwarding:
   ```bash
   kubectl port-forward service/compound-interest-api-service 8080:80
   ```
   The API will be available at `http://localhost:8080`

   Method 2 - Minikube tunnel:
   ```bash
   minikube tunnel
   ```
   The API will be available at `http://127.0.0.1:80`

5. Verify deployment:
```bash
# Check pod status
kubectl get pods -l app=compound-interest-api

# Check service endpoint
kubectl get endpoints compound-interest-api-service
```

### 🔹 4. Test the API

Using cURL:

```bash
# For Docker deployment (port 8000)
curl -X POST "http://127.0.0.1:8000/calculate" \
     -H "Content-Type: application/json" \
     -d '{
           "initial_amount": 10000,
           "monthly_contribution": 500,
           "annual_interest_rate": 7,
           "time_horizon_years": 10
         }'

# For Kubernetes deployment with port-forward (port 8080)
curl -X POST "http://127.0.0.1:8080/calculate" \
     -H "Content-Type: application/json" \
     -d '{
           "initial_amount": 10000,
           "monthly_contribution": 500,
           "annual_interest_rate": 7,
           "time_horizon_years": 10
         }'

# For Kubernetes deployment with minikube tunnel (port 80)
curl -X POST "http://127.0.0.1/calculate" \
     -H "Content-Type: application/json" \
     -d '{
           "initial_amount": 10000,
           "monthly_contribution": 500,
           "annual_interest_rate": 7,
           "time_horizon_years": 10
         }'
```

Using Python:
```python
import requests

# Choose the appropriate URL based on your deployment method
# Docker deployment
API_URL = "http://127.0.0.1:8000/calculate"
# Kubernetes with port-forward
# API_URL = "http://127.0.0.1:8080/calculate"
# Kubernetes with minikube tunnel
# API_URL = "http://127.0.0.1/calculate"

# Sample investment input
data = {
    "initial_amount": 10000,
    "monthly_contribution": 500,
    "annual_interest_rate": 7,
    "time_horizon_years": 10
}

# Send POST request
response = requests.post(API_URL, json=data)
```

### 🔹 5. Cleanup

For Kubernetes deployment:
```bash
# Delete the deployment and service
kubectl delete -f k8s-manifest.yaml

# Stop minikube tunnel (if running)
# Press Ctrl+C in the terminal running the tunnel

# Stop minikube
minikube stop
```

For Docker deployment:
```bash
# Stop the container
docker stop $(docker ps -q --filter ancestor=compound-interest-api)
```