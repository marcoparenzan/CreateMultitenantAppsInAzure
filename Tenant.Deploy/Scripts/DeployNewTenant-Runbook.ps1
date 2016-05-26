param ( 
    $WebhookData,
    $TenantName
)

# If runbook was called from Webhook, WebhookData will not be null.
if ($WebhookData -ne $null) {   
    $Body = ConvertFrom-Json -InputObject $WebhookData.RequestBody
    $TenantName = $Body.TenantName
}

# Authenticate to Azure resources retrieving the credential asset
$Credentials = Get-AutomationPSCredential -Name "myaccountant"		
$subscriptionId = ‘{your subscriptionId}’
$tenantId = ‘{your tenantId}’
Login-AzureRmAccount -Credential $Credentials -SubscriptionId $subscriptionId -TenantId $tenantId
	
$artifactsLocation = 'https://myaccountant.blob.core.windows.net/myaccountant-stageartifacts'
$ResourceGroupName = 'MyAccountant'

# generate a temporary StorageSasToken (in a SecureString form) to give ARM template the access to the template and to the artifacts$StorageAccountName = 'myaccountant'
$StorageContainer = 'myaccountant-stageartifacts'
$StorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName).Key1
$StorageAccountContext = (Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName).Context
$StorageSasToken = New-AzureStorageContainerSASToken -Container $StorageContainer -Context $StorageAccountContext -Permission r -ExpiryTime (Get-Date).AddHours(4)
$SecureStorageSasToken = ConvertTo-SecureString $StorageSasToken -AsPlainText -Force

#prepare parameters for the template
$ParameterObject = New-Object -TypeName Hashtable
$ParameterObject['TenantName'] = $TenantName
$ParameterObject['_artifactsLocation'] = $artifactsLocation
$ParameterObject['_artifactsLocationSasToken'] = $SecureStorageSasToken

$deploymentName = 'MyAccountant' + '-' + $TenantName + '-'+ ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')
$templateLocation = $artifactsLocation + '/Tenant.Deploy/Templates/azuredeploy.json' + $StorageSasToken

# execute
New-AzureRmResourceGroupDeployment -Name $deploymentName `
                                   -ResourceGroupName $ResourceGroupName `
                                   -TemplateFile $templateLocation `
                                   @ParameterObject `
                                   -Force -Verbose
