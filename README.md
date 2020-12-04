# terraform-libvirt-testbed

Terraform module for quickly spinning up libvirt-based infrastructure mockups.

Lets you define a set of networks (either public or isolated), and create and connect domains to them.

Requirements:
- Terraform 0.13.x
- A working libvirt installation, usable by your current user


### How to use

As with any Terraform module, you can simply instantiate this module in your Terraform plans. You will then be able to access those instance as the user `admin`, through your ssh key or with password `admin`.

Take a look at the [example dir](./example/) for a minimal code sample.

Gotchas:
- The length of `prefix + network name` must not exceed 16 characters, as it's used to name the network interface itself, as well as the libvirt network. This is required because of a currently existing race condition (in either the libvirt provider or libvirt itself), which tries to name multiple network interfaces the same, when creating networks in parallel, and thus failing creation.
