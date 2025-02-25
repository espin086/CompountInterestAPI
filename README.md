# Compound Interest Calculator API

🚀 Overview

The Compound Interest Calculator API calculates compound interest with monthly contributions and provides a yearly breakdown of investment growth. Built with FastAPI, it supports asynchronous processing and is containerized for easy deployment.

 ## 🛠 Getting Started

### 🔹 1. Prerequisites

Ensure you have the following installed:

Docker

Git

### 🔹 2. Clone the Repository

```bash
git clone https://github.com/your-username/compound-interest-api.git
cd compound-interest-api
```
### 🔹 3. Run with Docker

Build the Docker image:

```bash
docker build -t compound-interest-api .
```

Run the container:

```bash
docker run -d -p 8000:8000 compound-interest-api
```

🔹 4. Send a Request to the API


Using cURL

```bash
curl -X POST "http://127.0.0.1:8000/calculate" \
     -H "Content-Type: application/json" \
     -d '{
           "initial_amount": 10000,
           "monthly_contribution": 500,
           "annual_interest_rate": 7,
           "time_horizon_years": 10
         }'
```


Using Python

```python
import requests

# API URL
API_URL = "http://127.0.0.1:8000/calculate"

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