provider "azurerm" {
  features {}
  use_cli         = true
  subscription_id = "c26a8acd-2122-48f5-9903-0794aec5c764"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.9.5"
}