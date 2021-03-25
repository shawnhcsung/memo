# TTY (Teletypewriter)

```c
int rc;

struct tty_ldisc_ops shirda_ldisc_ops = {
    .magic = TTY_LDISC_MAGIC,
    .name = SHIRDA_LDISC_DRIVER_NAME,
    .open = shirda_ldisc_open,
    .close = shirda_ldisc_close,
    .read = shirda_ldisc_read,
    .write = shirda_ldisc_write,
    .ioctl = shirda_ldisc_ioctl,
    .receive_buf = shirda_ldisc_receive_buf,
    .write_wakeup = shirda_ldisc_write_wakeup,
    .compat_ioctl = compat_shirda_ldisc_ioctl,
};

rc = tty_register_ldisc(N_SHIRDA, &shirda_ldisc_ops);
if (rc != 0)
    printk(KERN_ERR "tty_register_ldisc() failed: %d\n", rc);
```
