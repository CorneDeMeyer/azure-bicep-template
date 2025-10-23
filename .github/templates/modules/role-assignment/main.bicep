@description('Environment name for which the role assignment is being created.')
param environment string

@description('The name of the managed identity to which the role will be assigned.')
param managedIdentityName string

@description('Storage Account Name for which the role assignment is being created.')
param storageAccountName string

// Built-in role ID for Storage Blob Data Contributor (Read, write, and delete access to Azure Storage blobs)
var storageBlobDataContributorRoleId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

module sqlReadWriteRole './sql-read-write-role.bicep' = {
  name: 'sqlReadWriteRole'
  params: {
    roleName: 'role-sql-read-write-${uniqueString(resourceGroup().id)}'
    description: 'Custom role for SQL read/write access for '
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

// Reference existing user-assigned managed identity in the same resource group
resource userIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

// Reference existing storage account in the same resource group
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
}

// Create role assignment at resource group scope
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: resourceGroup()
  dependsOn: [ sqlReadWriteRole, userIdentity ] // Ensure role definition and identity exist before assignment
  name: guid(resourceGroup().id, environment, 'sql-read-write-role', userIdentity.id)
  properties: {
    roleDefinitionId: sqlReadWriteRole.outputs.roleDefinitionId
    principalId: userIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Create role assignment for Storage Blob Data Contributor at storage account scope
resource roleAssignmentStorage 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccount
  dependsOn: [ userIdentity, storageAccount ] // Ensure identity and storage accounts exists before assignment
  name: guid(storageAccount.id, environment, 'storage-blob-data-contributor-role', userIdentity.id)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: userIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output roleAssignmentId string = roleAssignment.id
