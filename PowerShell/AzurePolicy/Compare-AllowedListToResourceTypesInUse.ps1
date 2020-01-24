<#
.SYNOPSIS
    Compares a list of allowed Azure resource types to the what's in the tenant
.DESCRIPTION
    Compares a list of allowed Azure resource types to the what's currently deployed
    across all subscriptions within a single tenant.
.PARAMETER list
    An array of strings, each of which is in the format "Provider/resourceType" or
    "Provider/resourceType/subResourceType".  For example "Microsoft.Compute/virtualMachines"
    or "Microsoft.Compute/locations/diskoperations"

.EXAMPLE
    $allowedResources = @("Microsoft.Compute/availabilitySets",
        "Microsoft.Compute/virtualMachines",
        "Microsoft.Compute/virtualMachines/extensions",
    )
    Compare-AllowedListToResourceTypesInUse -list $allowedResources
.NOTES
Author: Michael Blackistone
Date: January 17, 2020
#>

param (
    [Array]$list = @(
        "Microsoft.Compute/availabilitySets",
        "Microsoft.Compute/virtualMachines",
        "Microsoft.Compute/virtualMachines/extensions",
        "Microsoft.Compute/locations",
        "Microsoft.Compute/locations/operations",
        "Microsoft.Compute/locations/vmSizes",
        "Microsoft.Compute/locations/runCommands",
        "Microsoft.Compute/locations/usages",
        "Microsoft.Compute/locations/virtualMachines",
        "Microsoft.Compute/locations/publishers",
        "Microsoft.Compute/operations",
        "Microsoft.Compute/restorePointCollections",
        "Microsoft.Compute/restorePointCollections/restorePoints",
        "Microsoft.Compute/disks",
        "Microsoft.Compute/snapshots",
        "Microsoft.Compute/locations/diskoperations",
        "Microsoft.Compute/images",
        "Microsoft.insights/migrateToNewPricingModel",
        "Microsoft.insights/rollbackToLegacyPricingModel",
        "Microsoft.insights/listMigrationdate",
        "Microsoft.insights/logprofiles",
        "Microsoft.insights/alertrules",
        "Microsoft.insights/autoscalesettings",
        "Microsoft.insights/eventtypes",
        "Microsoft.insights/eventCategories",
        "Microsoft.insights/actiongroups",
        "Microsoft.insights/activityLogAlerts",
        "Microsoft.insights/locations",
        "Microsoft.insights/locations/operationResults",
        "Microsoft.insights/operations",
        "Microsoft.insights/diagnosticSettings",
        "Microsoft.insights/diagnosticSettingsCategories",
        "Microsoft.insights/extendedDiagnosticSettings",
        "Microsoft.insights/metricDefinitions",
        "Microsoft.insights/logDefinitions",
        "Microsoft.insights/metrics",
        "Microsoft.KeyVault/vaults",
        "Microsoft.KeyVault/vaults/secrets",
        "Microsoft.KeyVault/vaults/accessPolicies",
        "Microsoft.KeyVault/operations",
        "Microsoft.KeyVault/checkNameAvailability",
        "Microsoft.KeyVault/deletedVaults",
        "Microsoft.KeyVault/locations",
        "Microsoft.KeyVault/locations/deletedVaults",
        "Microsoft.KeyVault/locations/operationResults",
        "Microsoft.Network/virtualNetworks",
        "Microsoft.Network/publicIPAddresses",
        "Microsoft.Network/networkInterfaces",
        "Microsoft.Network/loadBalancers",
        "Microsoft.Network/networkSecurityGroups",
        "Microsoft.Network/applicationSecurityGroups",
        "Microsoft.Network/networkIntentPolicies",
        "Microsoft.Network/routeTables",
        "Microsoft.Network/publicIPPrefixes",
        "Microsoft.Network/networkWatchers",
        "Microsoft.Network/networkWatchers/connectionMonitors",
        "Microsoft.Network/virtualNetworkGateways",
        "Microsoft.Network/localNetworkGateways",
        "Microsoft.Network/connections",
        "Microsoft.Network/applicationGateways",
        "Microsoft.Network/locations",
        "Microsoft.Network/locations/operations",
        "Microsoft.Network/locations/operationResults",
        "Microsoft.Network/locations/CheckDnsNameAvailability",
        "Microsoft.Network/locations/usages",
        "Microsoft.Network/locations/virtualNetworkAvailableEndpointServices",
        "Microsoft.Network/locations/availableDelegations",
        "Microsoft.Network/locations/supportedVirtualMachineSizes",
        "Microsoft.Network/locations/checkAcceleratedNetworkingSupport",
        "Microsoft.Network/locations/validateResourceOwnership",
        "Microsoft.Network/locations/setResourceOwnership",
        "Microsoft.Network/locations/effectiveResourceOwnership",
        "Microsoft.Network/operations",
        "Microsoft.Network/dnszones",
        "Microsoft.Network/dnsOperationResults",
        "Microsoft.Network/dnsOperationStatuses",
        "Microsoft.Network/dnszones/A",
        "Microsoft.Network/dnszones/AAAA",
        "Microsoft.Network/dnszones/CNAME",
        "Microsoft.Network/dnszones/PTR",
        "Microsoft.Network/dnszones/MX",
        "Microsoft.Network/dnszones/TXT",
        "Microsoft.Network/dnszones/SRV",
        "Microsoft.Network/dnszones/SOA",
        "Microsoft.Network/dnszones/NS",
        "Microsoft.Network/dnszones/CAA",
        "Microsoft.Network/dnszones/recordsets",
        "Microsoft.Network/dnszones/all",
        "Microsoft.Network/trafficmanagerprofiles",
        "Microsoft.Network/checkTrafficManagerNameAvailability",
        "Microsoft.Network/trafficManagerGeographicHierarchies",
        "Microsoft.Network/expressRouteCircuits",
        "Microsoft.Network/routeFilters",
        "Microsoft.Network/expressRouteServiceProviders",
        "Microsoft.Network/bgpServiceCommunities",
        "Microsoft.Network/applicationGatewayAvailableWafRuleSets",
        "Microsoft.Network/applicationGatewayAvailableSslOptions",
        "Microsoft.Network/ddosProtectionPlans",
        "Microsoft.OperationalInsights/workspaces",
        "Microsoft.OperationalInsights/workspaces/dataSources",
        "Microsoft.OperationalInsights/workspaces/query",
        "Microsoft.OperationalInsights/storageInsightConfigs",
        "Microsoft.OperationalInsights/linkTargets",
        "Microsoft.OperationalInsights/operations",
        "Microsoft.Resources/tenants",
        "Microsoft.Resources/locations",
        "Microsoft.Resources/providers",
        "Microsoft.Resources/checkresourcename",
        "Microsoft.Resources/resources",
        "Microsoft.Resources/subscriptions",
        "Microsoft.Resources/subscriptions/resources",
        "Microsoft.Resources/subscriptions/providers",
        "Microsoft.Resources/subscriptions/operationresults",
        "Microsoft.Resources/resourceGroups",
        "Microsoft.Resources/subscriptions/resourceGroups",
        "Microsoft.Resources/subscriptions/resourcegroups/resources",
        "Microsoft.Resources/subscriptions/locations",
        "Microsoft.Resources/subscriptions/tagnames",
        "Microsoft.Resources/subscriptions/tagNames/tagValues",
        "Microsoft.Resources/deployments",
        "Microsoft.Resources/deployments/operations",
        "Microsoft.Resources/links",
        "Microsoft.Resources/operations",
        "Microsoft.RecoveryServices/vaults",
        "Microsoft.RecoveryServices/operations",
        "Microsoft.RecoveryServices/locations",
        "Microsoft.RecoveryServices/locations/backupStatus",
        "Microsoft.RecoveryServices/locations/backupValidateFeatures",
        "Microsoft.RecoveryServices/locations/backupPreValidateProtection",
        "Microsoft.RecoveryServices/locations/allocatedStamp",
        "Microsoft.RecoveryServices/locations/allocateStamp",
        "Microsoft.Media/checknameavailability",
        "Microsoft.Media/locations",
        "Microsoft.Media/locations/checkNameAvailability",
        "Microsoft.Media/mediaservices",
        "Microsoft.Media/mediaservices/accountFilters",
        "Microsoft.Media/mediaservices/assets",
        "Microsoft.Media/mediaservices/assets/assetFilters",
        "Microsoft.Media/mediaservices/contentKeyPolicies",
        "Microsoft.Media/mediaservices/eventGridFilters",
        "Microsoft.Media/mediaservices/liveEventOperations",
        "Microsoft.Media/mediaservices/liveEvents",
        "Microsoft.Media/mediaservices/liveEvents/liveOutputs",
        "Microsoft.Media/mediaservices/liveOutputOperations",
        "Microsoft.Media/mediaservices/streamingEndpointOperations",
        "Microsoft.Media/mediaservices/streamingEndpoints",
        "Microsoft.Media/mediaservices/streamingLocators",
        "Microsoft.Media/mediaservices/streamingPolicies",
        "Microsoft.Media/mediaservices/transforms",
        "Microsoft.Media/mediaservices/transforms/jobs",
        "Microsoft.Media/operations",
        "Microsoft.Storage/checkNameAvailability",
        "Microsoft.Storage/locations",
        "Microsoft.Storage/locations/asyncoperations",
        "Microsoft.Storage/locations/deleteVirtualNetworkOrSubnets",
        "Microsoft.Storage/locations/usages",
        "Microsoft.Storage/operations",
        "Microsoft.Storage/storageAccounts",
        "Microsoft.Storage/storageAccounts/blobServices",
        "Microsoft.Storage/storageAccounts/fileServices",
        "Microsoft.Storage/storageAccounts/listAccountSas",
        "Microsoft.Storage/storageAccounts/listServiceSas",
        "Microsoft.Storage/storageAccounts/queueServices",
        "Microsoft.Storage/storageAccounts/tableServices",
        "Microsoft.Storage/usages",
        "Microsoft.Web/sites/instances",
        "Microsoft.Web/sites/metrics",
        "Microsoft.Web/sites/slots/instances",
        "Microsoft.Web/sites/slots/metrics",
        "Microsoft.ApiManagement/checkFeedbackRequired",
        "Microsoft.ApiManagement/checkNameAvailability",
        "Microsoft.ApiManagement/checkServiceNameAvailability",
        "Microsoft.ApiManagement/operations",
        "Microsoft.ApiManagement/reportFeedback",
        "Microsoft.ApiManagement/service",
        "Microsoft.ApiManagement/validateServiceName",
        "Microsoft.Automation/automationAccounts/runbooks",
        "Microsoft.Automation/automationAccounts",
        "Microsoft.Sql/servers",
        "Microsoft.Sql/servers/databases",
        "Microsoft.Automation/automationAccounts/webhooks",
        "Microsoft.Automation/operations",
        "Microsoft.Automation/automationAccounts/variables",
        "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
        "Microsoft.Automation/automationAccounts/configurations",
        "Microsoft.Compute/sharedVMImages/versions",
        "Microsoft.Compute/sharedVMImages",
        "Microsoft.DocumentDB/databaseAccountNames",
        "Microsoft.DocumentDB/databaseAccounts",
        "Microsoft.insights/components",
        "Microsoft.insights/metricalerts",
        "Microsoft.insights/scheduledqueryrules",
        "Microsoft.insights/components/query",
        "Microsoft.insights/components/metrics",
        "Microsoft.insights/components/events",
        "Microsoft.insights/components/pricingPlans",
        "Microsoft.ManagedIdentity/userAssignedIdentities",
        "Microsoft.ManagedIdentity/Identities",
        "Microsoft.ManagedIdentity/operations",
        "Microsoft.OperationsManagement/solutions",
        "Microsoft.Web/sites/slots/config",
        "Microsoft.Web/sites/slots/metricdefinitions",
        "Microsoft.Web/sites/resourcehealthmetadata",
        "Microsoft.Web/sites/recommendations",
        "Microsoft.Web/sites/metricdefinitions",
        "Microsoft.Web/sites/domainownershipidentifiers",
        "Microsoft.Web/serverfarms/workers",
        "Microsoft.Web/serverfarms/metrics",
        "Microsoft.Web/serverfarms/metricdefinitions",
        "Microsoft.Web/hostingenvironments/metricdefinitions",
        "Microsoft.Web/hostingenvironments/metrics",
        "Microsoft.Web/hostingenvironments/multirolepools/instances",
        "Microsoft.Web/hostingenvironments/multirolepools/instances/metricdefinitions",
        "Microsoft.Web/hostingenvironments/multirolepools/instances/metrics",
        "Microsoft.Web/hostingenvironments/multirolepools/metricdefinitions",
        "Microsoft.Web/hostingenvironments/multirolepools/metrics",
        "Microsoft.Web/hostingenvironments/workerpools/instances",
        "Microsoft.Web/hostingenvironments/workerpools/instances/metricdefinitions",
        "Microsoft.Web/hostingenvironments/workerpools/instances/metrics",
        "Microsoft.Web/hostingenvironments/workerpools/metricdefinitions",
        "Microsoft.Web/hostingenvironments/workerpools/metrics",
        "Microsoft.Portal/dashboards",
        "Microsoft.Portal/userSettings",
        "Microsoft.Portal/operations",
        "Microsoft.Portal/locations/userSettings",
        "Microsoft.Portal/locations/consoles",
        "Microsoft.Portal/locations",
        "Microsoft.Portal/consoles"
    )
)

$blockedList = @()
Get-AzSubscription | ForEach-Object {
    Select-AzSubscription -SubscriptionObject $_
    Get-AzResource | ForEach-Object {
        if ($_.ResourceType -notin $list) {
            if ($_.ResourceType -notin $blockedList) {
                $blockedList += $_.ResourceType
            }
        }
    }
}

return (,$blockedList)