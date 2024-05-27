# Terraform Project: Deploying a Three-Tier App on VMware vSphere

A simple project which deploys 3 Linux VMs as following: app01, db01 and web01


1. The `versions.tf` file specifies the vsphere provider version to be used.
2. The `main.tf` file contains the vsphere provider definition and the main **logic** of the program: the various _data sources_ allow data to be fetched or computed for use elsewhere in the configuration (eg. vSphere cluster, datastore, portgroup etc.), and the _resource_ blocks describe the virtual machines to create. 
3. The `variables.tf` file contains the variables definition within the Terraform configuration (but not the values of those variables which are defined in  `terraform.tfvars`).
4. For the `terraform.tfvars` file present in the current directory, Terraform automatically loads them to populate variables. **This file can be modfied to match other vSphere infrastructure settings**.

# Requirements

1. VM Base Template must be present

   Refer to the [VMware Documentation](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-5B3737CC-28DB-4334-BD18-6E12011CDC9F.html) to create a Linux VM Template (this project uses Ubuntu).

3. Terraform binaries must be installed

   Refer to the [Terraform Documentation](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli) to install terraform on any OS of your choice.

# Execution

To execute the project, first copy all the `.tf` & `.tfvars` files into a working directory.

> terraform init

Init - This command initializes various local settings and data that will be used by subsequent commands. It also automatically downloads and installs any provider defined in the configuration.

> terraform plan

Plan - This command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

> terraform apply

> terraform apply -auto-approve

Apply - This command is used to apply the changes required to reach the desired state of the configuration. Add the `-auto-approve` option to skip the confirmation prompt.

> terraform destroy

> terraform destroy -auto-approve

Destroy - This command destroys the deployed resources. It is similar to terraform apply, but it behaves as if all of the resources have been removed from the configuration. Add the `-auto-approve` option to skip the confirmation prompt.

# Future

- Add an `output.tf` file to provide useful information for troubleshooting purposes.
- Combine this project with an Ansible palybook to install the applications in the VMs.

# Resources

- [Terraform vsphere provider documentation](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs)
- [Hashicorp Tutorial on Managing VMs and snapshots on vSphere](https://developer.hashicorp.com/terraform/tutorials/virtual-machine/vsphere-provider)
