@description('The environment for the managed identity.')
param environment string = 'dev'

@description('The name of the managed identity.')
param managedIndetityNames array = []

@description('The location for the managed identity. Defaults to the resource group location.')
param location string = resourceGroup().location

module managedIdentities './managed-identity-module.bicep' = [for name in managedIndetityNames: {
  name: '${name}-${environment}-mi-deployment'
  params: {
    indetityName: name
    location: location
  }
}]

// Output the IDs of the created managed identities
output managedIdentityIds array = [for i in range(0, length(managedIndetityNames)): managedIdentities[i].outputs.managedIdentityId]
