# Arch

## Installation

### Summary

1. Partition and format disks
    - MBR or GPT? (will affect the bootloader)
    - Encrypt disk or not?
2. Mount partitions to organize your filesystem structure
3. Install the OS (Arch)
4. Regenerate initramfs (for encrypted volume)
5. Install the bootloader (GRUB)
6. Configure the system
7. Reboot

### Prerequisites

- Virtualbox VM Setup
  - CPU    : 2 cores
  - MEM    : 2G
  - EFI    : enabled
  - Disk   : 32G
  - Network: Bridge

- OS Setup
  - Repo   : Arch
  - FS     : luks + btrfs

### Partition Disk

- Check available disks

  ```bash
  > lsblk
  NAME    MAJ:MIN RM    SIZE RO  TYPE MOUNTPOINT
  loop0     7:0    0  549.2M  1  loop /run/archiso/sfs/airootfs
  sda       8:0    0     32G  0  disk
  sr0      11:0    1    671M  0  rom  /run/archiso/bootmnt
  ```

- Partition
  - Tools: `fdisk`, `cfdisk`, `parted`
  - Why `parted`?
      If you try to partition large disks (>2TB), fdisk will show a warning suggesting you to use `parted`

  ```bash
  > parted /dev/sda
  GNU Parted 3.3
  Using /dev/sda
  Welcome to GNU Parted! Type 'help' to view a list of commands
  (parted) mklabel gpt
  (parted) mkpart primary 1MiB 513MiB     # efi   (512M
  (parted) mkpart primary 513MiB 2561MiB  # swap  (2G <- same as memory
  (parted) mkpart primary 2561MiB 100%    # the rest of space (for luks)
  (parted) name 1 "EFI System Partition"
  (parted) name 2 "Swap"
  (parted) name 3 "Encrypted LUKS1 Volume"
  (parted) toggle 1 esp
  (parted) print
  Model: ATA VBOX HARDDISK (scsi)
  Disk /dev/sda: 34.4GB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags:

  Number  Start   End     Size    File system  Name                    Flags
  1      1049kB  538MB   537MB                EFI System Partition    boot, esp
  2      538MB   2685MB  2147MB               Swap
  3      2685MB  34.4GB  31.7GB               Encrypted LUKS1 Volume
  (parted) q
  Information: You may need to update /etc/fstab
  ```

### Format Partition

```bash
> lsblk
NAME    MAJ:MIN RM    SIZE RO  TYPE MOUNTPOINT
loop0     7:0    0  549.2M  1  loop /run/archiso/sfs/airootfs
sda       8:0    0     32G  0  disk
 |--sda1  8:1    0    512M  0  part
 |--sda2  8:2    0      2G  0  part
 +--sda3  8:3    0   29.5G  0  part
sr0      11:0    1    671M  0  rom  /run/archiso/bootmnt
```

UEFI only supports FAT12, FAT16, FAT32

```bash
> mkfs.vfat /dev/sda1
mkfs.fat 4.1 (2107-01-24)
```

Use `mkswap` and `swapon` to create swap partition

```bash
> mkswap /dev/sda2
Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
no label, UUID=13d1836c-947a-4bc4-a612-43a532e1db7b

> swapon -v /dev/sda2
swapon: /dev/sda2: found signature [pagesize=4096, signature=swap]
swapon: /dev/sda2: pagesize=4096, swapsize=2147483648, devsize=2147483648
swapon /dev/sda2
```

### Full Disk Encryption (include `/boot`)

> Caution
>
> - Encrypt `/boot` using LUKS2 is not yet supported by GRUB
> - Don't forget to use luks1 for full disk encryption

```bash
> cryptsetup luksFormat --type luks1 /dev/sda3

WARNING!
========
This will overwrite data on /dev/sda3 irrevocably

Are you sure? (Type 'yes' in capital letters): YES
Enter passphrase for /dev/sda3:
Verify passphrase:
WARNING: Locking directory /run/cryptsetup is missing!
cryptsetup luksFormat /dev/sda3 16.12s user 1.23s system 113% cpu 15.318 total
```

### Unlock the encrypted disk using password

```bash
> cryptsetup open /dev/sda3 my-luks-vol
Enter passphrase for /dev/sda3:
```

```bash
> dmsetup ls
my-luks-vol     (254:0)

> ll /dev/mapper
total 0
crw------- 1 root root 10, 236 Aug  7 03:46 control
lrwxrwxrwx 1 root root       7 Aug  7 03:47 my-luks-vol -> ../dm-0
```

```bash
> mkfs.btrfs -L "Arch Linux" /dev/mapper/my-luks-vol
btrfs-progs v5.7
See http://btrfs.wiki.kernel.org for more information

Label:              Arch Linux
UUID:               2764021f-db7f-47af-a7e0-6afa36e79d8d
Node size:          16384
Sector size:        4096
Filesystem size:    29.50GiB
Block group profiles:
  Data:             single        8.00MiB
  Metadata:         DUP         256.00MiB
  System:           DUP           8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-Metadata
Runtime features:
Checksum:           crc32c
Number of devices:  1
Devices:
   ID       SIZE  PATH
    1   29.50GiB  /dev/mapper/my-luks-vol
```

### Create BTRFS Sub Volumes

```bash
> mount /dev/mapper/my-luks-vol /mnt
> mkdir /mnt/__current
> mkdir /mnt/__snapshot
> btrfs subvolume create /mnt/__current/boot
> btrfs subvolume create /mnt/__current/root
> btrfs subvolume create /mnt/__current/home
> btrfs subvolume list /mnt
ID 256 gen 6 top level 5 path __current/boot
ID 258 gen 7 top level 5 path __current/root
ID 259 gen 8 top level 5 path __current/home

> umount /mnt
```

### Prepare the filesystem for installation

Do not use `nosuid` here unless you don't need `sudo`

```bash
> mount -o defaults,ssd,nodev,subvol=__current/root \
>    /dev/mapper/my-luks-vol \
>    /mnt
```

```bash
> mkdir /mnt/boot
> mount -o defaults,ssd,nodev,subvol=__current/boot \
>    /dev/mapper/my-luks-vol \
>    /mnt/boot
```

```bash
> mkdir /mnt/home
> mount -o defaults,ssd,nodev,subvol=__current/home \
>    /dev/mapper/my-luks-vol \
>    /mnt/home
```

```bash
> mkdir /mnt/boot/efi
> mount /dev/sda1 /mnt/boot/efi
```

### Install Arch

You'll see some errors related to fsck.btrfs, it's ok to ignore it.

```sh
> pacstrap /mnt \
>    base \
>    base-devel \      # build essentials
>    linux \
>    linux-firmware \
>    grub \            # I choose GRUB as my bootloader
>    efibootmgr \      # used by the GRUB installation script
>    man \
>    vim \
>    iwd               # wireless connection
```

Edit `fstab` to remove the duplicate `subvol=*` in the mount option and double check if the content is as what you expect.

```bash
> genfstab -U /mnt > /mnt/etc/fstab
> vi /mnt/etc/fstab
```

```bash
> arch-chroot /mnt
```

```bash
> ln -sf /usr/bin/vim /usr/bin/vi
```

### Generate key file for the encrypted volume

- [Cryptkey](https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration#cryptkey)

- Create a binary key file

  > **Question:**
  > Why `iflag=fullblock` ?

  ```bash
  > dd bs=512 count=4 if=/dev/random of=/my-luks-key iflag=fullblock
  ```

  Since I'm going to put the device key in initramfs, which will be extracted to `/boot`, make sure the users (except sudoers) cannot access this file

  ```bash
  > chmod 600 /my-luks-key
  ```

- Add the key file to key slot

  ```bash
  > cryptsetup luksAddKey /dev/sda3 /my-luks-key
  Enter any existing passphrase:
  cryptsetup luksAddKey /dev/sda3 /my-luks-key 6.82s user 0.02s system 68% cpu 9.955 total
  ```

  LUKS can support up to 8 key slots. Run the following command to check the key slots:

  ```bash
  > cryptsetup luksDump /dev/sda3
  ```

  The key is ready if you're not seeing "No key available with this passphrase" error

  ```bash
  > cryptsetup open /dev/sda3 test --key-file=/my-luks-key
  Cannot use device /dev/sda3 which is in use (already mapped or mounted).
  ```

### Regenerate Initramfs Image

[initramfs](https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption#With_a_keyfile_embedded_in_the_initramfs)

Modify `/etc/mkinitcpio.conf`:

1. Assign the LUKS key file

    ```bash
    FILES=(/my-luks-key)
    ```

2. Add 'encrypt' to the HOOKS

   ```sh
   HOOKS=(base udev autodetect modconf block encrypt
   #                                         ^^^^^^^
   ```

3. Check key file's permission again

    ```bash
    > ls -al /my-luks-key
    -r-------- 1 root root 2048 Aug 8 08:40 /boot/my-luks-key
    ```

4. Regenerate the initramfs image

    ```bash
    > mkinitcpio -p linux
    ```

    - Don't run `mkinitcpio -P` here otherwise `mkinitcpio.conf` will be reset to default
    - Notice that this step has to be **AFTER** `mkinitcpio.conf` is modified
    - Check `boot/initramfs-linux.img`
5. list the files in the initramfs to check if the key file is included

    ```bash
    > lsinitcpio -l /boot/initramfs-linux.img | grep my-luks-key
    ```

6. remove the key file

    ```bash
    > shred --remove --zero /my-luks-key
    ```

> **Warning**
>
> Make sure the key files' permissions is still `600` after installing a new kernel

### Install the bootloader

- [UEFI](https://wiki.archlinux.org/index.php/GRUB#UEFI_systems)
- [GRUB](https://wiki.archlinux.org/index.php/GRUB#Configuration)

- Modfy `/etc/default/grub`
  - Set `GRUB_TIMEOUT=1`
  - Set the kernel parameters to `GRUB_CMDLINE_LINUX`

    ```bash
    GRUB_CMDLINE_LINUX=" \
        cryptdevice=/dev/sda3:my-luks-vol \
        cryptkey=rootfs:/my-luks-key \
        root=/dev/mapper/my-luks-vol"
    ```

- Uncomment `GRUB_ENABLE_CRYPTODISK=y`

  ```bash
  > vi /etc/default/grub

  > grub-install \
  >    --target=x86_64-efi \        # default=i386-pc, can be any in /usr/lib/grub/*
  >    --bootloader-id=GRUB \       # only available on EFI and Macs
  >    --boot-directory=/boot \     # where the "grub" folder will be created at
  >    --efi-directory=/boot/efi \  # use this dir as the ESP root
  >    /dev/sda3                    # install device
  Installing for x86_64-efi plarform.
  Installation finished. No error reported.
  ```

  > **Question**
  > Why we need two grub config here?
  >
  > - grub-mkconfig -o /boot/grub/grub.cfg
  > - grub-mkconfig -o /boot/efi/EFI/GRUB/grub.cfg

### Configure the system

- Time zone

  ```bash
  > ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
  > hwclock --systohc
  ```

- Locale

  Uncomment the needed locales:

  ```bash
  > vi /etc/locale.gen
  > locale-gen
  Generating locales...
    en_US.UTF-8... done
    zh_TW.UTF-8... done
    zh_TW.BIG5... done
  Generation complete.
  ```

- Hostname

  ```bash
  > vi /etc/hostname
  ```

- Hosts

  ```bash
  > vi /etc/hosts
  ```

- Set the password for root

  ```bash
  > passwd
  ```

- Reboot

  ```bash
  > sync
  > reboot
  ```
