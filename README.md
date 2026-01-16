# Titan Infrastructure Suite

## Overview

Welcome to the **Titan Infrastructure Suite**. This project provides a robust, modular Infrastructure-as-Code (IaC) foundation for managing cloud resources on **Google Cloud Platform (GCP)** using [Terraform](https://www.terraform.io/).

It is designed to support multiple environments (Development and Production) with a focus on scalability, maintainability, and security.

## System Architecture

### Infrastructure Overview

```mermaid
flowchart TB
    subgraph GCP [Google Cloud Platform]
        subgraph VPC [VPC Network]


            subgraph Public_Subnet [Public Subnet]
                PublicVM["Public Instance\n(Bastion/Frontend)"]
                NAT[Cloud NAT]
            end

            subgraph Private_Subnet [Private Subnet]
                PrivateVM["Private Instance\n(Internal)"]
                BackendVM[Backend Server]
                CloudSQL[("Cloud SQL\nDatabase")]
            end

            PublicVM --> PrivateVM
            PublicVM --> BackendVM
            BackendVM --> CloudSQL
            PrivateVM --> CloudSQL
        end

        Internet((Internet)) -- IAP/SSH --> PublicVM
        Private_Subnet --> NAT --> Internet
    end

    classDef plain fill:#fff,stroke:#333,stroke-width:1px;
    classDef blue fill:#e1f5fe,stroke:#0277bd,stroke-width:2px;
    classDef green fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px;
    classDef yellow fill:#fffde7,stroke:#fbc02d,stroke-width:2px;

    class VPC plain
    class Public_Subnet blue
    class Private_Subnet green
    class CloudSQL yellow
```

### Module Dependencies

```mermaid
flowchart LR
    subgraph Environment [Environment: Dev]
        MainTF[main.tf]
    end

    subgraph Modules
        VPCModule[Module: VPC]
        InstancesModule[Module: Instances]
        DBModule[Module: DB]
    end

    MainTF -->|Configures| VPCModule
    MainTF -->|Configures| InstancesModule
    MainTF -->|Configures| DBModule

    VPCModule -->|Outputs: vpc_id, subnets| MainTF
    MainTF -->|Passes: subnet_id| InstancesModule
    MainTF -->|Passes: vpc_id| DBModule

    DBModule -->|Outputs: db_ip| MainTF
    MainTF -->|Passes: db_host| InstancesModule
```

## Architecture

The project follows a standard modular directory structure:

### Environments

Layered configurations for isolated deployments.

- **`environments/dev`**: Development environment for testing and iteration.
- **`environments/prod`**: Production environment for stable, live workloads.

### Modules

Reusable components that encapsulate infrastructure logic.

- **`modules/vpc`**: Networking foundation (Virtual Private Cloud, Subnets, Firewalls).
- **`modules/instances`**: Compute resources and virtual machines.
- **`modules/db`**: Database provisioning and management.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) configured with appropriate credentials.

## Getting Started

1. **Initialize Terraform**
   Navigate to the desired environment directory:

   ```bash
   cd environments/dev
   terraform init
   ```

2. **Plan Deployment**
   Review proposed changes:

   ```bash
   terraform plan
   ```

3. **Apply Configuration**
   Provision resources:
   ```bash
   terraform apply
   ```

## Best Practices

- **State Management**: Terraform state files (`*.tfstate`) are ignored to prevent sensitive data leakage. Use a remote backend (e.g., GCS) for team collaboration.
- **Variable Management**: Avoid committing `terraform.tfvars`. Use environment variables or a secure secret manager for sensitive inputs.

---

_Generated for the Terraform Learning Project._
