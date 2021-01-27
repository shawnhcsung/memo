# Linux Kernel Driver

## Implementation

### Module Init

```c
#define MY_DRV_NAME "my sample driver"
#define MY_DRV_VERSION "version 1.0"

static const struct of_device_id my_of_match_table[] = {
    { .compatible = "vendor,platform-somecomponent", },
    {},
};

static struct platform_device *my_pdev;

static struct platform_driver my_pdrv = {
    .driver = {
        .name  = MY_DRV_NAME,
        .owner = THIS_MODULE,
        .of_match_table = my_of_match_table,
    },
    .probe   = my_probe,
    .suspend = my_suspend,
    .resume  = my_resume,
    .remove  = my_remove,
};

static int my_probe(struct platform_device *pdev) { /* ... */ }
static int my_suspend(struct platform_device *pdev, pm_message_t state) { /* ... */ }
static int my_resume(struct platform_device *pdev) { /* ... */ }
static int my_remove(struct platform_device *pdev) { /* ... */ }


static int __init my_init(void)
{
    int err;

    printk("%s: check point\n", __func__);

    err = platform_driver_register(&my_pdrv);
    if (err) return err;

    printk("%s: success\n", __func__);
    return 0;
}

static void __exit my_exit(void)
{
    platform_device_unregister(my_pdrv);
    platform_driver_unregister(&my_pdrv);
    printk("%s: check point\n", __func__);
}


module_init(my_init);
```
