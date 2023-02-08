resource "azurerm_resource_group" "infnext-GR" {
  name     = var.resource_group_name_infnext
  location = var.location
}

resource "azurerm_template_deployment" "infnext-arm" {
  name                = "InfinityNextGateway"
  resource_group_name = azurerm_resource_group.infnext-GR.name
  deployment_mode     = "Complete"
  depends_on = [ azurerm_resource_group.infnext-GR ]
  template_body = file("${path.module}/mainTemplate.json")
  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "location" = azurerm_resource_group.infnext-GR.location
    "adminPassword" = "${var.admin_password}"
    "authenticationType" = "password"
    "vmName" = "appsecgw"
    "vmSize" = "${var.vmsize}"
    "virtualNetworkName" = "vnet-inbound-hub"
    "virtualNetworkAddressPrefix" = "10.10.0.0/16"
    "Subnet1Name" = "Frontend"
    "Subnet1Prefix" = "10.10.0.0/24"
    "Subnet1StartAddress" = "10.10.0.5"
    "Subnet2Name" = "Backend"
    "Subnet2Prefix" = "10.10.0.0/24"
    "Subnet2StartAddress" = "10.10.0.21"
    "vnetNewOrExisting" = "new"
    "waapPublicIP" = "yes"
    "inboundSources" = "0.0.0.0/0"
    "waapAgentToken" = "${var.waaptoken}"
    "_artifactsLocation" = "https://raw.githubusercontent.com/CheckPointSW/CloudGuardIaaS/master/azure/templates/"
  }
}
