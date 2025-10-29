# azure-bicep-dojo

Welcome to the Azure Bicep Dojo! This repository serves as a practical learning environment for mastering Bicep, Microsoft's Infrastructure as Code (IaC) language for deploying Azure resources.

## Purpose

The primary goal of this dojo is to provide hands-on experience with Bicep through a series of exercises and real-world scenarios. Whether you're a beginner or an experienced practitioner, you'll find valuable resources to enhance your Bicep skills.

## Structure

The repository is organized as follows:

-   `.azuredevops/`: Contains Azure DevOps pipeline configurations for CI/CD.
    -   `pipeline/`: Includes the main pipeline definition (`main-pipeline.yml`).
    -   `templates/`: Contains reusable templates for stages, steps, and variables.
        -   `modules/`: Bicep modules for various Azure resources (e.g., storage accounts, managed identities, role assignments).
        -   `stages/`: Stage templates for deployment and validation.
        -   `steps/`: Step templates for tasks like running unit tests and deploying infrastructure.
        -   `variables/`: Variable files for different environments (dev, test, nonprod, prod).
-   `src/`:  Placeholder for application source code (if applicable).
-   `README.md`: The current file, providing an overview of the repository.

## Key Components

### Bicep Modules

The `modules` directory contains Bicep modules for creating and configuring Azure resources. Each module is designed to be reusable and customizable.  Key modules include:

-   `managed-identity/`: Deploys user-assigned managed identities.  See [`managed-identity-module.bicep`](.azuredevops/templates/modules/managed-identity/managed-identity-module.bicep) and [`main.bicep`](.azuredevops/templates/modules/managed-identity/main.bicep).
-   `role-assignment/`: Defines custom roles for assigning permissions, such as the SQL read/write role in [`sql-read-write-role.bicep`](.azuredevops/templates/modules/role-assignment/sql-read-write-role.bicep).
-   `storage-account/`: Deploys Azure storage accounts with various configurations.  See [`main.bicep`](.azuredevops/templates/modules/storage-account/main.bicep).

### Azure DevOps Pipelines

The `.azuredevops` or `.github` directory contains the pipeline configurations for automating the deployment process.

-   [`main-pipeline.yml`](.azuredevops/pipeline/main-pipeline.yml): Defines the CI/CD pipeline, including stages for validation, deployment to different environments (Dev, Test, NonProd, Prod), and manual approval steps.
-   `templates/`: Contains reusable templates for pipeline stages and steps.
    -   `stages/`:
        -   [`deploy-environment.yml`](.azuredevops/templates/stages/deploy-environment.yml):  A template for deploying to a specific environment.
        -   [`validate-codebase.yml`](.azuredevops/templates/stages/validate-codebase.yml):  A template for validating the codebase, including running unit tests.
    -   `steps/`:
        -   [`run-angular-unit-tests.yml`](.azuredevops/templates/steps/run-angular-unit-tests.yml):  A template for running Angular unit tests.
        -   [`run-dot-net-unit-tests.yml`](.azuredevops/templates/steps/run-dot-net-unit-tests.yml): A template for running .NET unit tests.
    -   `variables/`: Environment-specific variable files (e.g., [`dev.yml`](.azuredevops/templates/variables/dev.yml), [`test.yml`](.azuredevops/templates/variables/test.yml), [`nonprod.yml`](.azuredevops/templates/variables/nonprod.yml), [`prod.yml`](.azuredevops/templates/variables/prod.yml)).

## Getting Started

1.  **Prerequisites:**
    -   Azure Subscription
    -   Azure DevOps organization
    -   Basic understanding of Azure and Infrastructure as Code concepts
    -   Azure Service Principle (One per environment, set as owner within resource group)
2.  **Clone the Repository:**

    ```bash
    git clone <repository-url>
    cd azure-bicep-dojo
    ```
3.  **Configure Azure DevOps Pipeline:**
    -   Create a new pipeline in your Azure DevOps organization.
    -   Connect the pipeline to this Git repository.
    -   Import the [`main-pipeline.yml`](.azuredevops/pipeline/main-pipeline.yml) file as the pipeline definition.
4.  **Set up Service Connections:**
    -   Create Azure Resource Manager service connections in Azure DevOps for each environment (Dev, Test, NonProd, Prod).  The service connection names should match the `serviceConnection` values defined in the variable files (e.g., [`dev.yml`](.azuredevops/templates/variables/dev.yml)).
5.  **Customize Variables:**
    -   Modify the variable files in the `templates/variables/` directory to match your Azure subscription and resource group settings.
6.  **Run the Pipeline:**
    -   Trigger the pipeline to deploy the infrastructure to your Azure environments.

## Exercises

Here are some suggested exercises to get you started:

1.  **Deploy a Storage Account:**
    -   Use the `storage-account` module to deploy a storage account to the Dev environment.
    -   Customize the storage account name, SKU, and other properties.
2.  **Create a Managed Identity:**
    -   Use the `managed-identity` module to create a managed identity.
    -   Assign the managed identity a specific role on a resource group.
3.  **Implement CI/CD:**
    -   Modify the pipeline to automatically deploy changes to the Test environment when code is merged into the `main` branch.
    -   Add a manual approval step before deploying to the Prod environment.
4.  **Add Unit Tests:**
    -   Implement unit tests for your Bicep modules using Pester or other testing frameworks.
    -   Integrate the unit tests into the pipeline.
5.  **Parameterize Modules:**
    -   Convert hardcoded values in the Bicep modules into parameters.
    -   Use variable files to manage the parameter values for different environments.

## References
- `Azure Naming Rules`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules
- `Azure Bicep Modules`: https://learn.microsoft.com/en-us/azure/templates 

## License

This project is licensed under the [MIT License](LICENSE).