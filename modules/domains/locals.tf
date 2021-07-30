#__________________________________________________________
#
# Local Variables Section
#__________________________________________________________

#__________________________________________________________
#
# Assign Global Attributes from global_vars Workspace
#__________________________________________________________

locals {
  # Intersight Organization Variables
  organizations = var.organizations
  org_moids = {
    for v in sort(keys(data.intersight_organization_organization.org_moid)) : v => {
      moid = data.intersight_organization_organization.org_moid[v].results[0].moid
    }
  }

  # Intersight Provider Variables
  endpoint = var.endpoint
  # Tags for Deployment
  tags     = var.tags

  #______________________________________________
  #
  # UCS Domain Variables
  #______________________________________________
  ucs_domain_profile = {
    for k, v in var.ucs_domain_profile : k => {
      action             = (v.action != null ? v.action : "No-op")
      description_domain = (v.description_domain != null ? v.description_domain : "")
      description_fi_a   = (v.description_fi_a != null ? v.description_fi_a : "")
      description_fi_b   = (v.description_fi_b != null ? v.description_fi_b : "")
      fabric_a_serial    = (v.fabric_a_serial != null ? v.fabric_a_serial : "")
      fabric_b_serial    = (v.fabric_a_serial != null ? v.fabric_a_serial : "")
      organization       = (v.organization != null ? v.organization : "default")
      policy_bucket      = (v.policy_bucket != null ? v.policy_bucket : [])
      tags               = (v.tags != null ? v.tags : [])
    }
  }
}
