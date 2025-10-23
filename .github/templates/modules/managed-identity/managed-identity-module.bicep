@description('The name of the managed identity to create.')
param indetityName string
@description('The location where the managed identity will be created (default is the resource group location).')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: indetityName
  location: location
}

output managedIdentityId string = managedIdentity.id
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
