# 📦 Terraform Modules

This directory contains the Terraform modules used to deploy the Azure Chatbot infrastructure.

## 📋 Available Modules

### 🌐 Network Module

The `network` module creates the virtual network, subnets, and network security groups required for the infrastructure.

### 🔄 Application Gateway Module

The `appgw` module deploys an Azure Application Gateway for load balancing and routing traffic to the application.

### 🗄️ Database Module

The `database` module provisions a PostgreSQL Flexible Server for data storage.

### 📦 Storage Module

The `storage` module creates an Azure Storage Account for file storage.

### 💻 Compute Module

The `compute` module deploys a Virtual Machine Scale Set for application hosting.

### 🔐 Key Vault Module

The `keyvault` module provisions an Azure Key Vault for secure storage of secrets and credentials.

### 📊 Monitoring Module

The `monitoring` module implements comprehensive monitoring and alerting for the infrastructure:

- CPU and memory usage alerts for VMs
- Database connection and storage alerts
- Application Gateway health alerts
- Storage capacity alerts
- Centralized logging with Log Analytics
- Application performance monitoring with Application Insights
- Email and SMS notifications for critical alerts

## 📝 Module Documentation

Each module has its own README.md file with detailed information about:

- Input variables
- Output values
- Resources created
- Usage examples

## 🔄 Module Dependencies

```
network
  └── appgw
      └── compute
          └── keyvault
database
  └── keyvault
storage
  └── keyvault
monitoring
  └── (depends on all other modules)
```

## 🛠️ Best Practices

- Keep modules focused on a single responsibility
- Use consistent naming conventions
- Document all input variables and outputs
- Include validation for input variables
- Use locals for complex expressions
- Tag all resources appropriately
