# Sales Application – ECS Fargate Deployment

## Overview
This is a simple Flask-based sales application deployed on AWS ECS (Fargate)
and exposed publicly using an Application Load Balancer (ALB).
CI/CD is implemented using GitHub Actions.

## Endpoints
- `/` → Health check
- `/sales` → Returns sales data in JSON

## Tech Stack
- Flask (Python)
- Docker
- Amazon ECR
- Amazon ECS (Fargate)
- Application Load Balancer
- GitHub Actions

## Architecture
User → ALB → ECS Service → Fargate Task → Flask App

## Deployment
1. Code pushed to GitHub
2. GitHub Actions builds Docker image
3. Image pushed to Amazon ECR
4. ECS service redeployed automatically

## Public URL DNS
http://https://
