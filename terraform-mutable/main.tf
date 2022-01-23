module "app-module" {
  source           = "git::https://github.com/siddhudeva/terraform_mutable_commom_infra.git"
  INSTANCES_NO     = var.INSTANCES_NO
  INSTANCES_TYPE   = var.INSTANCES_TYPE
  COMPONENT        = var.COMPONENT
  ENV              = var.ENV
  APP_VERSION      = var.APP_VERSION
  APP_PORT         = 8080
  LB_RULE_PRIORITY = 100
  LB_PRIVATE       = true
}