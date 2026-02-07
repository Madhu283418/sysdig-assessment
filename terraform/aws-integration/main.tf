terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~>1.48"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://app.us4.sysdig.com"
  sysdig_secure_api_token = "8c012dc5-02c1-44dd-a14b-198cf2ae066c"
}

provider "aws" {
  region              = "us-west-2"
  allowed_account_ids = ["848487018340"]
}

module "onboarding" {
  source  = "sysdiglabs/secure/aws//modules/onboarding"
  version = "~>4.0"
}

module "config-posture" {
source                     = "sysdiglabs/secure/aws//modules/config-posture"
  version                  = "~>4.0"
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
}

resource "sysdig_secure_cloud_auth_account_feature" "config_posture" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_CONFIG_POSTURE"
  enabled    = true
  components = [module.config-posture.config_posture_component_id]
  depends_on = [module.config-posture]
}

resource "sysdig_secure_cloud_auth_account_feature" "identity_entitlement_basic" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_IDENTITY_ENTITLEMENT"
  enabled    = true
  components = [module.config-posture.config_posture_component_id]
  depends_on = [module.config-posture, sysdig_secure_cloud_auth_account_feature.config_posture]
  flags = {"CIEM_FEATURE_MODE": "basic"}
  lifecycle {
    ignore_changes = [flags, components]
  }
}

