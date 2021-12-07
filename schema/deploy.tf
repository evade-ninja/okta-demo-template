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
    org_name = "" //set this to the name of your org, eg: dev-0123456789
    base_url = "okta.com"
    api_token = var.okta_key //This is stored in secret.tf to make it less likely that we commit it to github. Remember to add secret.tf to .gitignore!
}

terraform {
  backend "local" {
      //This is the basic backend - the state is stored locally. OK for demos, but not for production. Production should use S3/dynamo backend
  }
}

//Add the default "user" type as a reference.
data "okta_user_type" "user" {
  name = "user"
}

//We can modify some of the attributes of the built-in properties
//See https://developer.okta.com/docs/reference/api/users/#understanding-user-status-values

resource "okta_user_base_schema_property" "firstName" {
  index       = "firstName"
  title       = "First name"
  type        = "string"
  required    = false
  master      = "OKTA"
  user_type   = "${data.okta_user_type.user.id}"
}

//Custom Properties: We can add whatever properties we want to the profile. Lots of options for what and how it is stored.

resource "okta_user_schema_property" "quote" {
  index = "quote"
  title = "Favorite Quote"
  type = "string"
  description = "CES UUID"
  required = false
  master = "OKTA"
  permissions = "HIDE"
  user_type   = "${data.okta_user_type.user.id}"
}

resource "okta_user_schema_property" "fruit" {
    index = "fruit"
    title = "Favorite Fruit"
    type = "string"
    required = "true"
    #array_type = "string"
    enum = ["None", "Apple", "Bananna", "Orange", "Pear"]
    master = "OKTA"
    scope = "SELF"
    permissions = "READ_ONLY"
    user_type   = "${data.okta_user_type.user.id}"
}

resource "okta_user_schema_property" "color" {
    index = "color"
    title = "Favorite Color"
    type = "string"
    required = "true"
    #array_type = "string"
    enum = ["Red", "Blue", "Yellow", "Brown", "White", "Teal", "Green"]
    master = "OKTA"
    scope = "SELF"
    permissions = "READ_WRITE"
    user_type   = "${data.okta_user_type.user.id}"
}
