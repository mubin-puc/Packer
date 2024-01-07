variable "capture_name_prefix" {
  description = "Prefix for naming the captured image"
  default = "AzureWin2016CompileRunner"
}
variable "client_id" {
  description = "Azure Service Principal Client ID"
  default = env("AZURE_CLIENT_ID")
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret"
  default = env("AZURE_CLIENT_SECRET")
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  default = env("AZURE_SUBSCRIPTION_ID")
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  default = env("AZURE_TENANT_ID")
}

variable "resource_group_name" {
  description = "Azure Resource Group Name"
  default = "rg-gitlab-ayx-core-prod"
}

variable "location" {
  description = "Azure Region"
  default     = "westus2" # Change to your desired region
}

variable "vm_size" {
  description = "Azure VM Size"
  default     = "Standard_B4ms" # Change to your desired VM size
}

source "azure-arm" "win2016_compile_image" {
  build_resource_group_name = var.resource_group_name
  os_type             = "Windows"
  client_id           = var.client_id
  client_secret       = var.client_secret
  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id
  shared_image_gallery {
    subscription = var.subscription_id
    resource_group = var.resource_group_name
    gallery_name = "PackerImages"
    image_name = "AzureWin2016RunnerBase"
  }
  shared_image_gallery_destination {
    subscription = var.subscription_id
    resource_group = var.resource_group_name
    gallery_name = "PackerImages"
    image_name = var.capture_name_prefix
    image_version = "1.0.3"
    replication_regions = [var.location]
    storage_account_type = "Standard_LRS"
  }
  managed_image_resource_group_name = var.resource_group_name
  managed_image_name  = "${var.capture_name_prefix}-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  vm_size             = var.vm_size
  virtual_network_name = "vnet-gitlab-ayx-core-prod-westus2"
  virtual_network_subnet_name = "gitlab-ayx-core-1"
  virtual_network_resource_group_name = "rg-gitlab-ayx-core-prod"
  azure_tags = {
    os = "windows_2016",
    driver_type = "GuiTest"
    department = "devops"
    environment = "prod"
    owner = "dg_currentbuilddevops@alteryx.com"
    project = "currentbuild"
  }
  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "20m"
  winrm_username = "packer"
}

build {
  sources = ["source.azure-arm.win2016_compile_image"]
  

  provisioner "powershell" {
    script = "./Packer/Scripts/install_packages.ps1"
  }

  provisioner "powershell" {
    script = "./Packer/Scripts/install_psexec.ps1"
  }

  provisioner "powershell" {
    script = "./Packer/Scripts/copy_testfiles.ps1"
  }

  provisioner "powershell" {
    script = "./Packer/Scripts/disable_wer.ps1"
  }

  provisioner "powershell" {
    script = "./Packer/Scripts/tightvnc.ps1"
  }

  provisioner "powershell" {
    script = "./Packer/Scripts/tightvnc.ps1"
  }

   provisioner "powershell" {
    script = "./Packer/Scripts/startup_script.ps1"
  }

    provisioner "powershell" {
    script = "./Packer/Scripts/opencover.ps1"
  }

   provisioner "powershell" {
    script = "./Packer/Scripts/disable_realtime_defender.ps1"
  }

  provisioner "powershell" {
    inline = ["while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
  }
}
