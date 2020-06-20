variable "build_number" {
    type = string
    default = "1"
}

variable "cpus" {
    type = number
    default = 1
}
variable "memory" {
    type = number
    default = 1024
}
variable "disk_size" {
    type = number
    default = 10240
}

# the source block is what was defined in the builders section and represents a
# reusable way to start a machine. You build your images from that source. All
# sources have a 1:1 correspondance to what currently is a builder. The
# argument name (ie: ami_name) must be unquoted and can be set using the equal
# sign operator (=).
source "virtualbox-iso" "example" {
    vm_name       = "packer-ubuntu1404-${var.build_number}"
    format        = "ova"
    headless      = true
    guest_os_type = "Ubuntu_64"
    boot_wait     = "2m"
    guest_additions_mode    = "disable"
    virtualbox_version_file = ""

    ssh_username  = "ubuntu"
    ssh_password  = "secret"
    ssh_timeout   = "30m"

    cpus          = var.cpus
    memory        = var.memory
    disk_size     = var.disk_size

    iso_urls      = [
        "http://old-releases.ubuntu.com/releases/14.04.5/ubuntu-14.04.5-server-amd64.iso"
    ]
    iso_checksum  = "md5:dd54dc8cfc2a655053d19813c2f9aa9f"
    floppy_files  = [
        "./preseed.cfg"
    ]

    boot_command = [
        "<esc><esc><enter><wait>",
        "/install/vmlinuz noapic ",
        "preseed/file=/floppy/preseed.cfg ",
        "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
        "hostname={{ .Name }} ",
        "fb=false debconf/fronten=d=noninteractive ",
        "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA keyboard-configuration/variant=USA console-setup/ask_detect=false ",
        "initrd=/install/initrd.gz -- <enter>"
    ]

    shutdown_command      = "echo secret | sudo -S shutdown -P now"
    post_shutdown_delay   = "2m"
    skip_export           = false
    export_opts = [
        "--vsys", "0",
        "--manifest"
    ]
    output_directory      = "output-${var.build_number}"
}

# A build starts sources and runs provisioning steps on those sources.
build {
    sources = [
        # there can be multiple sources per build
        "source.virtualbox-iso.example"
    ]

    # All provisioners and post-processors have a 1:1 correspondence to their
    # current layout. The argument name (ie: inline) must to be unquoted
    # and can be set using the equal sign operator (=).
    provisioner "shell" {
        execute_command = "echo secret | sudo -S bash"
        inline = [
            "echo 'Hello, world'"
        ]
    }
    provisioner "file" {
        source = "../files/index.html"
        destination = "/home/ubuntu/index.html"
    }

    # post-processors work too, example: `post-processor "shell-local" {}`.
    post-processor "vagrant" {
        name    = "vagrant-box"
        output  = "output-${var.build_number}/packer-ubuntu1404-${var.build_number}.box"
        # Comment this as https://github.com/hashicorp/packer/issues/9460
        # keep_input_artifact = true
    }
    post-processor "shell-local" {
        inline = [
                "echo 'You should upload artifacts to somewhere'"
            ]
    }
}