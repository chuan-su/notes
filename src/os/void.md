# Install Void Linux


## Download & Flash

First download a [live image](https://docs.voidlinux.org/installation/index.html#downloading-installation-media). Download `void-live-x86_64-20210218-gnome.iso` if you want to use the [GNOME](https://www.gnome.org/) desktop.

Next, flash the downloaded image to a USB drive. You can use [etcher](https://www.balena.io/etcher/).

## Bios Settings

I am installing void linux on a Lenove Thinkpad. Press `F12` to enter Bios setup.

In order to boot from a USB drive, we need to disable `Secure Boot` in the **Security** settings.

Next, in the Bios **Startup** settings, make sure we have `UEFI/Legacy Boot` set to `UEFI only`

## Install

Before starting installation, make sure we are using UEFI booting by checking:

```bash
ls /sys/firware/efi
# /sys/firware/efi exists means system uses UEFI
```

Type `sudo void-installer` in terminal, we will get into void linux installation wizard.

*The `keymap` for swedish keyboard is `se-latin1`.*

### Bootloader

Select the disk, for example `/dev/sda` to install the boot loader and choose graphical terminal for GRUB menu.

### Partition

For EFI systems GPT is mandatory and a FAT32 partition with at least 100MB must be created with the TOGGLE `boot`, this will be used as EFI System Partition. This partition must be mounted as `/boot/efi`.

At least 1 partition is required for the root file system `/`.

Therefore, we need at least 2 partitions for our computer disk (device name might be `/dev/sda`):

<style>
table {
  margin: 0!important;
}
</style>

| Device    | Size | Type             | 
| :---      | :--- | :---             | 
| /dev/sda1 | 100M | BIOS boot        | 
| /dev/sda2 | 298G | Linux filesystem | 

### File system

We need to create and mount the file systems for each of the 2 partitions:

| Device    |  Mount point | File system type     |
| :---      |  :---        | :---                 |
| /dev/sda1 |  /boot/efi   | vfat  FAT32          |
| /dev/sda2 |  /           | btrfs Oracle's Btrfs |

## Post Installation

Now we have void linux installed. We need to [perform a system update](https://docs.voidlinux.org/xbps/index.html#updating) for the first time:

```bash
sudo xbps-install -u xbps
sudo xbps-install -Su
```

<br>
Reference

[https://docs.voidlinux.org/installation/live-images/guide.html](https://docs.voidlinux.org/installation/live-images/guide.html)


