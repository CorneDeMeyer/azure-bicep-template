@minLength(3)
@maxLength(24) 
// Have a look at 
// https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules
// for name restrictions rules
param storageAccountName string

@description('Storage account name (3-24 chars, lower letters and numbers)')
param location string = resourceGroup().location

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param skuName string = 'Standard_LRS'

@allowed([
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param kind string = 'StorageV2'

@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

param enableHttpsTrafficOnly bool = true
param allowBlobPublicAccess bool = false

@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

param hierarchicalNamespace bool = false // ADLS Gen2

param tags object = {}

@description('Optional network rules object matching Azure Storage networkAcls schema. Leave {} for defaults (no rules).')
param networkAcls object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    accessTier: accessTier
    supportsHttpsTrafficOnly: enableHttpsTrafficOnly
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: minimumTlsVersion
    isHnsEnabled: hierarchicalNamespace
    networkAcls: networkAcls
  }
  tags: tags
}

// Outputs are used for when you would like to reference values from this module deployment
output storageAccountId string = storageAccount.id
output name string = storageAccount.name
output primaryEndpoints object = storageAccount.properties.primaryEndpoints
output primaryBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob

// This is a no no, do not output secrets like this. Rather use connection strings in Key Vault or Azure App Configuration.
// output connectionString string = storageAccount.listKeys().keys[0].value
