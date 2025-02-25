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

print(response.json())