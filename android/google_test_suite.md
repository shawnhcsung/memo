# Google Test Suite

## CTS

## VTS

### Checking GSIs and the security patch

Download Android Verify Boot Tool ([avbtool](https://android.googlesource.com/platform/external/avb/)) and then execute:

```bash
$ avbtool info_image --image system.img
Footer version:           1.0
Image size:               1275564032 bytes
Original image size:      1255354368 bytes
VBMeta offset:            1275248640
VBMeta size:              2304 bytes
--
Minimum libavb version:   1.0
Header Block:             256 bytes
...
Release String:           'avbtool 1.1.0'
Descriptors:
    Hashtree descriptor:
      Version of dm-verity:  1
      ...
      Flags:                 0
    Prop: com.android.build.system.os_version -> '10'
    Prop: com.android.build.system.security_patch -> '2020-06-05'
```

Here we can see the security patch of this GSI system image is `2020-06-05`. Then we check the security patch on phone:

```bash
$ adb shell "getprop | grep patch"
[ro.build.version.security_patch]: [2020-06-01]
[ro.vendor.build.security_patch]: [2020-06-01]
```

Notice that the date of security patch on phone must be prior than the GSI's, otherwise the phone will not boot after locking the bootloader.