@description('The environment for the deployment (e.g., dev, prod)')
param environment string

@description('The location for the resources')
param location string = resourceGroup().location

@description('Container instance name')
param containerName string

@description('Container image (e.g. myregistry.azurecr.io/myapp:latest)')
param containerImage string = 'myacr.azurecr.io/myapp:latest'

@description('Container port exposed by the app')
param containerPort int = 80

@description('CPU cores for the container')
param cpu int = 1

@description('Memory (GB) for the container')
param memoryInGb int = 2

@description('Restart policy: Always, OnFailure or Never')
param restartPolicy string = 'Always'

@description('Optional registry server (leave empty for public registries)')
param registryServer string = ''

@description('Optional registry username (used when registryServer is set)')
@secure()
param registryUsername string = ''

@description('Optional registry password (used when registryServer is set)')
@secure()
param registryPassword string = ''

@description('Optional user-assigned managed identity name to assign to the container group')
param managedIdentityName string = ''

@description('Set true to attach the user-assigned identity to the container group')
param assignUserAssignedIdentity bool = false

@description('Environment variables as an object, e.g. { "ASPNETCORE_ENVIRONMENT": "Production" }')
param environmentVariables object = {}

// Optional existing user-assigned identity (only referenced when assignUserAssignedIdentity == true)
resource userIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (assignUserAssignedIdentity) {
  name: managedIdentityName
}

// Evironment Keys: convert environmentVariables object to array expected by ACI
var environmentVarKey = [{ 
  name: 'ENVIRONMENT'
  value: environment
 }]
var envVarArray = [for k in objectKeys(environmentVariables): {
  name: k
  value: string(environmentVariables[k])
}]

var environmentVariablesOutput = concat(environmentVarKey, envVarArray)

// optional image registry credentials
var registryCreds = length(registryServer) > 0 ? [
  {
    server: registryServer
    username: registryUsername
    password: registryPassword
  }
] : null

// deterministic DNS label (must be lowercase and unique within region)
var dnsNameLabel = toLower('${containerName}-${uniqueString(resourceGroup().id)}')

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: containerName
  location: location
  identity: assignUserAssignedIdentity ? {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userIdentity.id}': {}
    }
  } : null
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: containerImage
          resources: {
            requests: {
              cpu: cpu
              memoryInGB: memoryInGb
            }
          }
          ports: [
            {
              port: containerPort
            }
          ]
          environmentVariables: environmentVariablesOutput
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: containerPort
        }
      ]
      dnsNameLabel: dnsNameLabel
    }

    restartPolicy: restartPolicy
    imageRegistryCredentials: registryCreds
  }
}

output containerFqdn string = containerGroup.properties.ipAddress.fqdn
output containerId string = containerGroup.id
