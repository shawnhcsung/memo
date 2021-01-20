# How USB works on Android

## Selecting USB port from the menu

When connecting a USB cable to an Android device, usually you're able to see a pop up or drop down menu with the following ports on it:

- Media device (MTP)
- Camera (PTP)
- Charge only
- MIDI

These settings are implemented in the `packages/apps/Settings` folder. For example, the USB menu is created by `addUsbSettingsItem()` in `Settings/src/com/android/settings/connecteddevice/usb/UsbSettingsExts.java`. Since `bicr` port is rare to see so I'll keep it in the source code as a reminder:

```java
public class UsbSettingsExts {
  private static final String KEY_CHARGE = "usb_charge";
  public PreferenceScreen addUsbSettingsItem(UsbSettingsFragment usbSettings) {
    // ...
    // Add charge only Mode
    String chargeConfig = android.os.SystemProperties.get(
      PROPERTY_USB_CHARGE_ONLY, FUNCTION_NOT_SUPPORT);
    boolean chargeExist = chargeConfig.equals(FUNCTION_SUPPORT);

    mCharge = (UsbRadioButtonPreference) root.findPreference(KEY_CHARGE);
    if (mCharge != null) {
      mCharge.setOnPreferenceChangeListener(usbSettings);
      mRadioButtonPreferenceList.add(mCharge);
    }
    // ...
    if (bicrExist) {
      PreferenceCategory bicrCategory = new PreferenceCategory(context);
      bicrCategory.setTitle(R.string.usb_connect_as_cdrom_category);
      root.addPreference(bicrCategory);
      mBicr = new UsbRadioButtonPreference(context);
      mBicr.setTitle(R.string.usb_use_built_in_cd_rom);
      mBicr.setSummary(R.string.usb_bicr_summary);
      mBicr.setOnPreferenceChangeListener(usbSettings);
      bicrCategory.addPreference(mBicr);
      mRadioButtonPreferenceList.add(mBicr);
    }
    if (DEBUG) Log.d(TAG, " chargeExist : " + chargeExist + " bicrExist : " + bicrExist);
  }
}
```

The related information is defined at `.xml` files such as `Settings/res/xml/usb_settings.xml`:

```xml
<com.android.settings.widget.UsbRadioButtonPreference
  android:key="usb_charge"
  android:title="@string/usb_charge_title_only"
  android:summary="@string/usb_charge_summary"
  />
```

As we can see, these options are just user interfaces. The one who really do the action is in `Settings/src/com/android/settings/connecteddevice/usb/UsbSettingsFragment.java`:

```java
private UsbBackend mBackend;
// ...
public boolean onPreferenceChange(Preference preference, Object newValue) {
  // Don't allow any changes to take effect as the USB host will be disconnected,
  // killing the monkeys
  if (preference != mUsbDebug) {
    if (Utils.isMonkeyRunning()) {
      return true;
    }
    // If this user is disallowed from using USB,
    // don't handle their attempts to change the setting.
    UserManager um = (UserManager) getActivity().getSystemService(Context.USER_SERVICE);
    if (um.hasUserRestriction(UserManager.DISALLOW_USB_FILE_TRANSFER)) {
      return true;
    }

    long currentMode = mUsbExts.getFunctionMode(preference);
    mBackend.setCurrentFunctions(currentMode);

    updateToggles(currentMode);

    mUsbExts.setNeedUpdate(false);
  }
  return true;
}
```

The `mBackend` here will be redirected to `framework/base/services/usb/java/com/android/server/usb/UsbDeviceManager.java`:

> **Todo**: find the proof

```java
public void setCurrentFunctions(long functions) {
  if (DEBUG) {
    Slog.d(TAG, "setCurrentFunctions(" + UsbManager.usbFunctionsToString(functions) + ")");
  }
  if (functions == UsbManager.FUNCTION_NONE) {
    MetricsLogger.action(mContext, MetricsEvent.ACTION_USB_CONFIG_CHARGING);
  } else if (functions == UsbManager.FUNCTION_MTP) {
    MetricsLogger.action(mContext, MetricsEvent.ACTION_USB_CONFIG_MTP);
  } else if (functions == UsbManager.FUNCTION_PTP) {
    MetricsLogger.action(mContext, MetricsEvent.ACTION_USB_CONFIG_PTP);
  } else if (functions == UsbManager.FUNCTION_MIDI) {
    MetricsLogger.action(mContext, MetricsEvent.ACTION_USB_CONFIG_MIDI);
  } else if (functions == UsbManager.FUNCTION_RNDIS) {
    MetricsLogger.action(mContext, MetricsEvent.ACTION_USB_CONFIG_RNDIS);
  } else if (functions == UsbManager.FUNCTION_ACCESSORY) {
    MetricsLogger.action(mContext, MetricsEvent.ACTION_USB_CONFIG_ACCESSORY);
  }
  mHandler.sendMessage(MSG_SET_CURRENT_FUNCTIONS, functions);
}
```

This change message will be sent to `handleMessage()` itself:

```java
public void handleMessage(Message msg) {
  switch (msg.what) {
  // ...
  case MSG_SET_CURRENT_FUNCTIONS:
    long functions = (Long) msg.obj;
    setEnabledFunctions(functions, false);
    break;
  }
  // ...
```

```java
protected void setEnabledFunctions(long usbFunctions, boolean forceRestart) {
  // ...
  if (trySetEnabledFunctions(usbFunctions, forceRestart)) {
    return;
  }

  if (oldFunctionsApplied && oldFunctions != usbFunctions) {
    Slog.e(TAG, "Failsafe 1: Restoring previous USB functions.");
    if (trySetEnabledFunctions(oldFunctions, false)) {
      return;
    }
  }

  // Still didn't work.  Try to restore the default functions.
  Slog.e(TAG, "Failsafe 2: Restoring default USB functions.");
  if (trySetEnabledFunctions(UsbManager.FUNCTION_NONE, false)) {
    return;
  }

  // last try
  Slog.e(TAG, "Failsafe 3: Restoring empty function list (with ADB if enabled).");
  if (trySetEnabledFunctions(UsbManager.FUNCTION_NONE, false)) {
    return;
  }

  // finally
  Slog.e(TAG, "Unable to set any USB functions!");
}
```

```java
private boolean trySetEnabledFunctions(long usbFunctions, boolean forceRestart) {
  String functions = null;
  if (usbFunctions != UsbManager.FUNCTION_NONE) {
      functions = UsbManager.usbFunctionsToString(usbFunctions);
  }
  mCurrentFunctions = usbFunctions;
  if (functions == null || applyAdbFunction(functions)
          .equals(UsbManager.USB_FUNCTION_NONE)) {
      functions = UsbManager.usbFunctionsToString(getChargingFunctions());
  }
  // append `adb` to the port combination if debugging mode is on
  functions = applyAdbFunction(functions);

  // ...

  // kick the USB stack to close existing connections
  setUsbConfig(UsbManager.USB_FUNCTION_NONE);

  if (!waitForState(UsbManager.USB_FUNCTION_NONE)) {
      Slog.e(TAG, "Failed to kick USB config");
      return false;
  }

  // set the new USB configuration.
  setUsbConfig(oemFunctions);
  // ...
}
```

```java
protected long getChargingFunctions() {
  if (isAdbEnabled()) {
    return UsbManager.FUNCTION_ADB;
  } else {
    return UsbManager.FUNCTION_MTP;
  }
}
```

Finally, we arrive the destination:

```java
private static final String USB_CONFIG_PROPERTY = "sys.usb.config";
private void setUsbConfig(String config) {
  setSystemProperty(USB_CONFIG_PROPERTY, config);
}
```

The USB port combination will be set to `sys.usb.config` property. We can observe the value using the command `adb shell getprop sys.usb.config`.

Let's take a look at this example. As soon as the user select "Charge Only" on the menu, the following log will show in logcat:

```log
D UsbDeviceManager: trySetEnabledFunctions(4,true)
I UsbDeviceManager: Setting USB config to mtp
```

```java
enum Function {
  FUNCTION_ADB = 1;
  FUNCTION_ACCESSORY = 2;
  FUNCTION_MTP = 4;
  FUNCTION_MIDI = 8;
  FUNCTION_PTP = 16;
  FUNCTION_RNDIS = 32;
  FUNCTION_AUDIO_SOURCE = 64;
}
```

The reason why "Charge only" is mapped to "MTP" is because of `getChargingFunctions()` we mentioned above.

Notice that `persist.vendor.usb.config` will affect how `UsbDeviceManager` decides the USB port combination. So on Qualcomm's platform, they usually use `init.qcom.usb.sh` to set this persist property to replace the port combination.

## Preparing the system (`init.rc`)

Once `UsbDeviceManager` decided the USB port combination, it will set the combination to `sys.usb.config` property, and then trigger the corresponding `.rc` files. Let's take an Android native USB rc file `/system/core/rootdir/init.usb.configfs.rc` as an example:

```rc
on property:sys.usb.config=none && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/UDC "none"
    stop adbd
    setprop sys.usb.ffs.ready 0
    write /config/usb_gadget/g1/bDeviceClass 0
    write /config/usb_gadget/g1/bDeviceSubClass 0
    write /config/usb_gadget/g1/bDeviceProtocol 0
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rmdir /config/usb_gadget/g1/functions/rndis.gs4
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=mtp,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=mtp,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "mtp_adb"
    symlink /config/usb_gadget/g1/functions/mtp.gs0 /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}
```

Don't forget to add `property:sys.usb.ffs.ready=1` to make sure `adbd` is ready.

## Ports

- `mass_storage` (cd-rom)
- `mtp` (media device)
- `adb` (debug)
- `ptp` (camera)
- `rndis` (tethering)
- `bicr`
