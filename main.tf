#
# Volumes
#

resource "libvirt_volume" "baseimage" {
  name   = "${var.prefix}baseimage.qcow2"
  source = var.image
  format = "qcow2"
}

data "template_file" "userdata" {
  for_each = var.domains
  template = file("${path.module}/cloudinit/user-data")
  # Ugly hack warning: TF doesn't like when we pass anything other than strings as template variables
  vars     = {
    hostname            = each.key
    ssh_authorized_keys = join("|", var.ssh_authorized_keys)
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each  = var.domains
  name      = "${var.prefix}${each.key}-cloudinit.iso"
  user_data = data.template_file.userdata[each.key].rendered
}

resource "libvirt_volume" "rootfs" {
  for_each       = var.domains
  name           = "${var.prefix}${each.key}.qcow2"
  size           = 8589934592
  base_volume_id = libvirt_volume.baseimage.id
}



#
# Networks
#

resource "libvirt_network" "network" {
  for_each  = var.networks
  name      = "${var.prefix}${each.key}"
  autostart = true
  mode      = each.value["is_public"] ? "nat" : "none"
  addresses = [ each.value["cidr"] ]
  bridge    = "${var.prefix}${each.key}"
}


#
# Volumes
#

resource "libvirt_volume" "volume" {
  for_each = zipmap(
    flatten([ for domain, spec in var.domains : [ for i in range(0, length(spec.volumes)) : "${domain}-${i}" ]]),
    flatten([ for domain, spec in var.domains : [ for i in range(0, length(spec.volumes)) : spec.volumes[i] ]]),
  )
  name = each.key
  size = each.value
}



#
# Domains
#

resource "libvirt_domain" "domain" {
  for_each  = var.domains
  name      = "${var.prefix}${each.key}"
  vcpu      = lookup(each.value, "vcpu", 1)
  memory    = lookup(each.value, "memory", 1024)
  running   = true
  cloudinit = libvirt_cloudinit_disk.cloudinit[each.key].id

  disk {
    volume_id = libvirt_volume.rootfs[each.key].id
  }

  dynamic "network_interface" {
    for_each = each.value["networks"]
    iterator = network
    content {
      network_id     = libvirt_network.network[network.value].id
      wait_for_lease = var.wait_for_lease
    }
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}
