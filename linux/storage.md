# Storage

## Resize LVM Partitions

Run `df -h` to check available spaces:

```
$ df -h
Filesystem        Size  Used Avail Use% Mounted on
udev              1.9G     0  1.9G   0% /dev
tmpfs             394M  1.1M  393G   1% /run
/dev/mapper/my-lv 196G  186G  829M 100% /
tmpfs             2.0G     0  2.0G   0% /dev/shm
tmpfs             5.0M  4.0K  5.0M   1% /run/lock
tmpfs             2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/sda2         976M  104M  806M  12% /boot
tmpfs             394M     0  394G   0% /run/user/1000
```

```
$ sudo vgs
```

```
$ sudo vgdisplay
```

```
$ sudo pvs
```

```
$ sudo pvdisplay
```

```
$ sudo lvs
```

```
$ sudo lvdisplay
```

```
$ sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

```
$ sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```

# Disk Encryption

```
$ sudo apt install cryptsetup
$ cryptsetup luksFormat --type luks /dev/$DEVICE
```

## Unlock

```
$ sudo cryptsetup luksOpen /dev/sdb1 myEntry
Enter passphrase for /dev/sdb1:

$ sudo dmsetup ls
myEntry    (253:0)

$ ls -lah /dev/mapper
total 0
drwxr-xr-x  2 root root      80 Feb 16 16:33 .
drwxr-xr-x 22 root root    4.4K Feb 16 16:33 ..
crw-------  1 root root 10, 236 Feb 16 12:42 control
lrwxrwxrwx  1 root root       7 Feb 16 16:33 myEntry -> ../dm-0

$ sudo mount /dev/mapper/myEntry /mnt
```

# Lock

```
$ sudo umount /mnt
$ sudo cryptsetup luksClose myEntry
$ sudo dmsetup ls
No devices found
```
