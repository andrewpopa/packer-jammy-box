// virtualbox
source "virtualbox-iso" "virtualbox" {
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
  boot_wait            = "5s"
  disk_size            = var.disk_size
  guest_additions_path = "VBoxGuestAdditions.iso"
  guest_os_type        = "Ubuntu_64"
  http_directory       = "http"
  iso_checksum         = var.iso_checksum
  iso_urls             = [var.iso_url]
  shutdown_command     = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_username         = var.ssh_username
  ssh_password         = var.ssh_password
  ssh_wait_timeout     = "10000s"
  vm_name              = "${var.name}-vbox"
  vboxmanage = [
    [
      "modifyvm", "${var.name}-vbox",
      "--memory", "${var.memory}"
    ],
    [
      "modifyvm", "${var.name}-vbox",
      "--cpus", "${var.cpus}"
    ]
  ]
}

// aws
source "amazon-ebs" "aws" {
  ami_name        = "${var.name}-${var.version}"
  ami_description = var.ami_description
  instance_type   = var.instance_type
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 50
    volume_type           = "gp2"
  }
  region       = var.region
  source_ami   = var.source_ami
  ssh_username = "ubuntu"

  dynamic "tag" {
    for_each = local.standard_tags
    content {
      key   = tag.key
      value = tag.value
    }
  }
}

build {
  sources = [
    "source.virtualbox-iso.virtualbox",
    "source.amazon-ebs.aws",
  ]

  // virtualbox
  provisioner "shell" {
    only = ["virtualbox-iso.virtualbox"]
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    execute_command   = "echo ${var.ssh_password} | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    expect_disconnect = true
    scripts = [
      "scripts/packages.sh",
      "scripts/vagrant.sh",
      "scripts/virtualbox.sh",
      "scripts/cleanup.sh"
    ]
  }

  // aws
  provisioner "shell" {
    only              = ["amazon-ebs.aws"]
    environment_vars  = ["DEBIAN_FRONTEND=noninteractive"]
    expect_disconnect = true
    scripts = [
      "scripts/aws.sh",
    ]
  }

  post-processor "manifest" {
    output = "stage-1-manifest.json"
  }

  post-processor "vagrant" {
    only   = ["virtualbox-iso.virtualbox"]
    output = "${var.name}_${var.version}.box"
  }

  post-processor "vagrant" {
    only   = ["vmware-iso.vmware"]
    output = "${var.name}_${var.version}_vmware.box"
  }
}
