# Sales Application – ECS Fargate Deployment

I built a complete CI/CD pipeline for a containerized Flask application using Jenkins, Terraform, Docker, and AWS ECS Fargate.
The infrastructure is provisioned using Terraform with remote state stored in S3 and state locking using DynamoDB.
When code is pushed to GitHub, Jenkins triggers a pipeline that builds a Docker image, pushes it to Amazon ECR, registers a new ECS task definition revision, and deploys it to an ECS Fargate service behind an Application Load Balancer.
The service is configured with ECS auto scaling based on CPU utilization and logs are sent to CloudWatch for monitoring.



# Sales Application CI/CD Pipeline

This project demonstrates a production-style CI/CD pipeline for deploying a containerized Flask application using Jenkins, Terraform, Docker, and AWS ECS Fargate.

## Architecture

GitHub → Jenkins → Terraform → Docker → ECR → ECS Fargate → ALB → Flask App → DynamoDB

Infrastructure state is stored in Amazon S3 and locked using DynamoDB.

## CI/CD Workflow

1. Developer pushes code to GitHub
2. Jenkins pipeline is triggered
3. Terraform provisions/updates infrastructure
4. Docker image is built
5. Image is pushed to Amazon ECR
6. ECS task definition revision is created
7. ECS service deploys the new version

## Infrastructure Components

- Amazon ECS Fargate
- Amazon ECR
- Application Load Balancer
- DynamoDB
- CloudWatch Logs
- Terraform S3 Backend
- DynamoDB State Locking

## Features

- Infrastructure as Code with Terraform
- Fully automated CI/CD pipeline
- Containerized application deployment
- ECS Service Auto Scaling
- Centralized logging with CloudWatch

## Technologies Used

- AWS ECS Fargate
- Docker
- Jenkins
- Terraform
- Python Flask
- DynamoDB
- Amazon ECR


Developer (Git Push)
        │
        ▼
     GitHub
        │
        ▼
     Jenkins CI/CD
        │
        ├── Terraform (Infrastructure)
        │
        └── Docker Build
               │
               ▼
           Amazon ECR
               │
               ▼
        ECS Fargate Service
               │
        (Auto Scaling Enabled)
               │
               ▼
      Application Load Balancer
               │
               ▼
           Flask App
               │
               ▼
           DynamoDB
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
