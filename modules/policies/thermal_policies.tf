#_________________________________________________________________________
#
# Intersight Power Policies Variables
# GUI Location: Configure > Policy > Create Policy > Power > Start
#_________________________________________________________________________

variable "thermal_policies" {
  default = {
    default = {
      description      = ""
      fan_control_mode = "Balanced"
      organization     = "default"
      tags             = []
    }
  }
  description = <<-EOT
  key - Name of the Power Policy.
  * description - Description to Assign to the Policy.
  * fan_control_mode - Sets the Fan Control Mode of the System. High Power, Maximum Power and Acoustic modes are only supported for Cisco UCS X series Chassis.
    - Acoustic - The fan speed is reduced to reduce noise levels in acoustic-sensitive environments. This Mode is only supported for UCS X series Chassis.
    - Balanced - The fans run faster when needed based on the heat generated by the chassis. When possible, the fans returns to the minimum required speed.
    - LowPower - The Fans run at the minimum speed required to keep the chassis cool.
    - HighPower - The fans are kept at higher speed to emphasizes performance over power consumption. This Mode is only supported for UCS X series Chassis.
    - MaximumPower - The fans are always kept at maximum speed. This option provides the most cooling and consumes the most power. This Mode is only supported for UCS X series Chassis.
  * organization - Name of the Intersight Organization to assign this Policy to.
    - https://intersight.com/an/settings/organizations/
  * tags - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = map(object(
    {
      description      = optional(string)
      fan_control_mode = optional(string)
      organization     = optional(string)
      tags             = optional(list(map(string)))
    }
  ))
}


#_________________________________________________________________________
#
# Thermal Policies
# GUI Location: Configure > Policy > Create Policy > Thermal > Start
#_________________________________________________________________________

module "thermal_policies" {
  depends_on = [
    local.org_moids,
    local.merged_profile_policies,
  ]
  version          = ">=0.9.6"
  source           = "terraform-cisco-modules/imm/intersight//modules/thermal_policies"
  for_each         = local.thermal_policies
  description      = each.value.description != "" ? each.value.description : "${each.key} Thermal Policy."
  fan_control_mode = each.value.fan_control_mode
  name             = each.key
  org_moid         = local.org_moids[each.value.organization].moid
  tags             = length(each.value.tags) > 0 ? each.value.tags : local.tags
  profiles = {
    for k, v in local.merged_profile_policies : k => {
      moid        = v.moid
      object_type = v.object_type
    }
    if local.merged_profile_policies[k].thermal_policy == each.key
  }
}
