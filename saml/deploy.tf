//Okta Demo Template

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    okta = {
        source = "okta/okta"
        version = ">= 3.20"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "okta"
}

provider "okta"{
    org_name = "dev-06323384" //set this to the name of your org, eg: dev-0123456789
    base_url = "okta.com"
    api_token = var.okta_key //This is stored in secret.tf to make it less likely that we commit it to github. Remember to add secret.tf to .gitignore!
}

terraform {
  backend "local" {
      //This is the basic backend - the state is stored locally. OK for demos, but not for production. Production should use S3/dynamo backend
  }
}

//We need to bring in the "everyone" built-in group so that we can reference it
data "okta_everyone_group" "todomundo" {
}

resource "okta_app_saml" "superSAMLapp1" {
  label                    = "Super SAML App"
  sso_url                  = "" //sso_url, recipient, and destination are often the same.
  recipient                = ""
  destination              = ""
  default_relay_state      = ""
  audience                 = "saml01"
  response_signed          = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = true
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  subject_name_id_template = "$${user.username}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"

/*
lifecycle {
    ignore_changes = [groups] //because OktaTerraform Provider can't handle it otherwise
  }*/
}


resource "okta_app_group_assignment" "grantall"{
  app_id = okta_app_saml.superSAMLapp1.id
  group_id = data.okta_everyone_group.todomundo.id
}
