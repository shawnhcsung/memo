# ADB

## Bypass Android setup wizard

```bash
adb root

# usually this should work
adb shell settings put secure user_setup_complete 1

# try this if the previous command doesn't work
adb shell settings put global device_provisioned 1
```

```bash
> adb shell "ps -A | grep setup"
u0_a108       1943   880 5508436  91468 0   0 S com.google.android.setupwizard
u0_a115       5775   880 5198044  50472 0   0 S com.google.android.partnersetup

> adb shell kill 1943
# now you should be able to see the desktop
```

Additionally, we can override `ro.setupwizard.mode` property to disable Setup Wizard totally:

```makefile
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.setupwizard.mode=DISABLED
```
