# Sample usage

In this example, we want a setup to test the Linux routing capabilities. So we're looking for a simple 3 node configuration, in which 2 nodes are interconnected through a middle node.

Thus, the infrastructure we want looks as follows: ```
node0 <---(priv0)---> node1 <---(priv1)---> node2
  |                     |                     |
(pub0)               (pub1)                (pub2)
  |                     |                     |
  v                     v                     v

            - the internet (SNATted) -

```

Steps to use this code:
1. Create a `terraform.tfvars` file, and add the line `ssh_authorized_keys = ["<your_ssh_key_here>"]`
2. Run `terraform init`
3. Run `terraform apply`, verify that all looks as expected, and then confirm the apply.
