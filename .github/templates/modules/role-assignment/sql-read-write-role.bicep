@minLength(2)
@maxLength(36)
@sys.description('Custom role definition for SQL read/write access')
param roleName string

@sys.description('Description of the custom role')
param description string = 'SQL Server Role granting read/write permissions on Azure SQL resources'
param assignableScopes array = [
  resourceGroup().id
]

var roleGuid = guid(subscription().id, roleName)

resource sqlRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: roleGuid
  properties: {
    roleName: roleName
    description: description
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.Sql/servers/read'
          'Microsoft.Sql/servers/write'
          'Microsoft.Sql/servers/databases/read'
          'Microsoft.Sql/servers/databases/write'
          'Microsoft.Sql/servers/firewallRules/*'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
    assignableScopes: assignableScopes
  }
}

output roleDefinitionId string = sqlRole.id
