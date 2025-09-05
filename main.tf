terraform {
    backend "azurerm" {
    resource_group_name   = "mk123"
    storage_account_name  = "mk123storageacc"
    container_name        = "mycontainer"
    key                   = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.42.0"
    
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "177b7e12-5f03-4f63-bcd1-ed6d1d776bff"
}

# Resource Group
resource "azurerm_resource_group" "mk123" {
  name     = "mk123"
  location = "Central India"
}

# Virtual Network (VNet)
resource "azurerm_virtual_network" "example" {
  name                = "mk123vnet"
  location            = azurerm_resource_group.mk123.location
  resource_group_name = azurerm_resource_group.mk123.name
  address_space       = ["10.0.0.0/16"]  # VNet ka address space

  tags = {
    environment = "dev"
  }
}

# Subnet for VNet
resource "azurerm_subnet" "example" {
  name                 = "mk123subnet"
  resource_group_name  = azurerm_resource_group.mk123.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]  # Subnet ka address range
}

# Network Security Group (Optional)
resource "azurerm_network_security_group" "example" {
  name                = "mk123nsg"
  location            = azurerm_resource_group.mk123.location
  resource_group_name = azurerm_resource_group.mk123.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet (Optional)
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}
