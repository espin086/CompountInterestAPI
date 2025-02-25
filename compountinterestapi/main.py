from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import List, Dict
import json

app = FastAPI(
    title="Compound Interest Calculator API",
    description="API for calculating compound interest with monthly contributions",
    version="0.0.1"
)

class InvestmentInput(BaseModel):
    """Purpose of this class is to define the input for the compound interest calculator"""
    initial_amount: float = Field(..., gt=0, description="Initial investment amount")
    monthly_contribution: float = Field(..., ge=0, description="Monthly contribution amount")
    annual_interest_rate: float = Field(..., gt=0, le=100, description="Annual interest rate (percentage)")
    time_horizon_years: int = Field(..., gt=0, le=50, description="Investment time horizon in years")

class YearlyGrowth(BaseModel):
    """Purpose of this class is to define the output for the compound interest calculator"""
    year: int
    starting_balance: float
    contributions: float
    interest_earned: float
    ending_balance: float

@app.post("/calculate", response_model=List[YearlyGrowth])
async def calculate_compound_interest(investment: InvestmentInput):
    """
    Calculate compound interest with monthly contributions
    
    Returns a year-by-year breakdown of the investment growth
    """
    yearly_results = []
    current_balance = investment.initial_amount
    annual_contribution = investment.monthly_contribution * 12
    interest_rate = investment.annual_interest_rate / 100

    for year in range(1, investment.time_horizon_years + 1):
        starting_balance = current_balance
        contributions = annual_contribution
        
        # Calculate interest earned on both initial balance and contributions
        # Assuming contributions are made at the start of each month
        interest_earned = (starting_balance + contributions) * interest_rate
        
        ending_balance = starting_balance + contributions + interest_earned
        current_balance = ending_balance

        yearly_results.append(
            YearlyGrowth(
                year=year,
                starting_balance=round(starting_balance, 2),
                contributions=round(contributions, 2),
                interest_earned=round(interest_earned, 2),
                ending_balance=round(ending_balance, 2)
            )
        )

    return yearly_results

@app.get("/")
async def root():
    """Welcome message and API information"""
    return {
        "message": "Welcome to the Compound Interest Calculator API",
        "documentation": "/docs",
        "openapi": "/openapi.json"
    } 