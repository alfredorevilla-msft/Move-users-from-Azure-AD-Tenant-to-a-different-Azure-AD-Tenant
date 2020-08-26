param(
    [Paramater(Mandatory)]
    [string]
    $Username,
    [Paramater(Mandatory)]
    [string]
    $SourceTenant,
    [Paramater(Mandatory)]
    [string]
    $DestinationTenant,
    [Paramater(Mandatory)]
    [string[]]
    $UserUpns
)

$Credential = [pscredential]::new($Username, (Read-Host -AsSecureString -Prompt "Please input your password"))
Connect-AzureAD -TenantId $SourceTenant -Credential $Credential

$Users = [System.Collections.ArrayList]::new()
foreach ($item in $UserUpns) {
    $Users.Add((Get-AzureADUser -Filter "userPrincipalName eq '$item'"))
}

Connect-AzureAD -TenantId $DestinationTenant -Credential $Credential

foreach ($item in $Users) {
    New-AzureADUser -AccountEnabled $item.AccountEnabled -ExtensionProperty <new_dictionary_selectively_built_from_$item.ExtensionProperty> -AgeGroup $item.AgeGroup  # and so on with rest of desired properties
}