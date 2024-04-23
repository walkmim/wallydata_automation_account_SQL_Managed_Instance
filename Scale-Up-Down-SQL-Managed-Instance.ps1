<#  
.SYNOPSIS  
    Scale Up and Down for Azure SQL Managed Instance 
  
.DESCRIPTION  
    This runbook scale Up and Down a specific Azure SQL Managed Instance
    
.EXAMPLE  
    rg-general-tests mi-casa-tu-casa GeneralPurpose Gen5 4

    Connect-AzAccount
    Set-AzSqlInstance -Name 'mi-casa-tu-casa' `
        -ResourceGroupName 'rg-general-tests' `
        -Edition 'GeneralPurpose' `
        -ComputeGeneration 'Gen5' `
        -VCore 8 `
        -Force `
        -Confirm:$false

  
.NOTES  
    Author: Walisson Alkmim
    Last Updated: 19/04/2024   
#> 

workflow Scale-Up-Down-SQL-Managed-Instance
{
    param
    (
        # TenantId
        [parameter(Mandatory=$true)] 
        [string] $TenantId = '',

        # Subscription Id
        [parameter(Mandatory=$true)] 
        [string] $SubscriptionId = '',

        # Name of the Resource Group
        [parameter(Mandatory=$true)] 
        [string] $ResourceGroupName = '',

        # The Azure SQL Managed Instance
        [parameter(Mandatory=$true)] 
        [string] $ManagedInstanceName = '',

        # Target Edition to the SQL Managed Instance
        # GeneralPurpose | BusinessCritical
        [parameter(Mandatory=$true)] 
        [string] $Edition = "",

        # Target ComputeGeneration to the SQL Managed Instance
        # Gen5 | G8IM | G8IH
        [parameter(Mandatory=$true)] 
        [string] $ComputeGeneration = "",

        # Target VCore to the SQL Managed Instance
        # 4 - 128.
        [parameter(Mandatory=$true)] 
        [INT32] $VCore = 4,

        # Identity to be used on authentication
        [parameter(Mandatory=$true)] 
        [string] $Identity = "system | user-managed-identity-name"
        
    )

    Write-Output "*****************************************************************************************"
    Write-Output "Used Parameters: " 
    
    Write-Output "TenantId: $TenantId"
    Write-Output "SubscriptionId: $SubscriptionId"
    Write-Output "ResourceGroupName: $ResourceGroupName"
    Write-Output "ManagedInstanceName: $ManagedInstanceName"
    Write-Output "Edition: $Edition"
    Write-Output "ComputeGeneration: $ComputeGeneration"
    Write-Output "VCore: $VCore"
    Write-Output "Identity: $Identity"

    Write-Output "*****************************************************************************************"

    Write-Output "Connecting to azure" 
    if ($Identity -contains "system") { 
        Connect-AzAccount -Identity
    }
    else{
        $Identity_uri = "/subscriptions/$SubscriptionId/resourcegroups/$ResourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$Identity"
        Connect-AzAccount -Identity -AccountId $Identity_uri
    }
    Write-Output "Successfully connected with Automation $Identity Managed Identity" 
    
    Write-Output "*****************************************************************************************"

    Write-Output "Context:" 

    $Subscription = Get-AzSubscription -TenantId $TenantId -SubscriptionId $SubscriptionId 
    [string] $SubscriptionName = $Subscription.Name
   
    Set-AzContext `
    -Tenant $TenantId `
    -Subscription $SubscriptionName

    Get-AzContext
    
    Write-Output "*****************************************************************************************"
    $sqlMI = Get-AzSqlInstance -Name $ManagedInstanceName -ResourceGroupName $ResourceGroupName | Select ManagedInstanceName,sku,VCores,StorageSizeInGB
    Write-Output "Current Configurations: "
    $sqlMI
    
    Write-Output "*****************************************************************************************"

    $startDatetime = Get-Date 
    Write-Output "Starting Changing: $startDatetime"

    $null = Set-AzSqlInstance -Name $ManagedInstanceName `
        -ResourceGroupName $ResourceGroupName `
        -Edition $Edition `
        -ComputeGeneration $ComputeGeneration `
        -VCore $VCore `
        -Force `
        -Confirm:$false
        
    $EndDatetime = Get-Date
    

    Write-Output "Change finished: $EndDatetime"

    # Calculate the time span between the two dates
    $timeDifference = New-TimeSpan -Start $startDatetime -End $EndDatetime
    
    # Get the difference 
    $secondsDifference = $timeDifference.TotalSeconds
    $MinutesDifference = $timeDifference.TotalMinutes

    #Write-Output "The Scale was executed in $secondsDifference seconds ($MinutesDifference minutes)."
    
    Write-Output "*****************************************************************************************"

    $sqlMI = Get-AzSqlInstance -Name $ManagedInstanceName -ResourceGroupName $ResourceGroupName | Select ManagedInstanceName,sku,VCores,StorageSizeInGB
    Write-Output "New Configurations: "
    $sqlMI

    
    Write-Output "*****************************************************************************************"
    Write-Output "`nBest regards, `nWalisson Alkmim"
}
