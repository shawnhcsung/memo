# Attestation Keybox

## Verification

### Notice

- Whether the device is locked will affect the test result (`fastboot oem lock`)

  If attestation key is provisioned when the device is locked, then you have to run the CTS/CTS-on-GSI tests by locking the device and vice versa.

  Since you may be unable to lock the device after replacing the GSIs, I suggest not to lock the device for the related tests.

- Make sure the device is in the following conditions otherwise the test may fail:

  - Being able to connect the internet

      Better to actually `ping` some domains you know in adb shell not just connecting to a WiFi.

  - The screen lock is disabled

      The screen lock has to be set to "None" to completely turn if off, instead of "Swipe" without a password.

### CTS

```
run cts -m CtsDevicePolicyManagerTestCases -t com.android.cts.devicepolicy.MixedDeviceOwnerTest#testDelegatedCertInstallerDeviceIdAttestation
run cts -m CtsDevicePolicyManagerTestCases -t com.android.cts.devicepolicy.MixedManagedProfileOwnerTest#testDelegatedCertInstallerDeviceIdAttestation
run cts -m CtsDevicePolicyManagerTestCases -t com.android.cts.devicepolicy.MixedManagedProfileOwnerTest#testDeviceIdAttestationForProfileOwner
```

### CTS-on-GSI

```
vts-tf> run cts-on-gsi -m CtsDevicePolicyManagerTestCases -t com.android.cts.devicepolicy.MixedDeviceOwnerTest#testDelegatedCertInstallerDeviceIdAttestation
```

```
vts-tf> run cts-on-gsi -m CtsDevicePolicyManagerTestCases -t  com.android.cts.devicepolicy.MixedManagedProfileOwnerTest#testDelegatedCertInstallerDeviceIdAttestation
```

```
vts-tf> run cts-on-gsi -m CtsDevicePolicyManagerTestCases -t com.android.cts.devicepolicy.MixedManagedProfileOwnerTest#testDeviceIdAttestationForProfileOwner
```

## Debugging

### Required information

Always capture the following logs if you wanna fire a keybox related Qualcomm case:

```
adb shell logcat -b all -d > logcat.log
adb shell cat /d/tzdbg/qsee_log > qsee.log
adb shell cat /d/tzdbg/log > tzdbg.log
```

## Case Study

### Being able to pass CTS but failed at CTS-on-GSI

#### Reproduction Steps

- Make sure the device is no locked
- Reset the device to default settings (erase userdata)
- Provision the keybox
- Connect to a WiFi and disable the screen lock
- Run CTS test and get a pass

  ```
  run cts -m CtsDevicePolicyManagerTestCases -t com.android.cts.devicepolicy.MixedDeviceOwnerTest#testDelegatedCertInstallerDeviceIdAttestation
  ```

- Replace the GSI

  ```
  fastboot flash system gsi-system.img
  fastboot --disable-verification flash vbmeta vbmeta.img
  fastboot erase userdata
  fastboot reboot
  ```

- Connect to a WiFi and disable the screen lock
- Run CTS-on-GSI in VTS but failed

  ```
  run cts-on-gsi -m CtsDevicePolicyManagerTestCases -t com.android.cts.devicepolicy.MixedDeviceOwnerTest#testDelegatedCertInstallerDeviceIdAttestation
  ```

#### Logs

```log
E QC-time-services: Daemon: Time-services: Waiting to accept connection
D DropBoxManager: About to call service->add()
I DropBoxManagerService: add tag=keymaster isTagEnabled=true flags=0x0
D DropBoxManager: service->add returned No error
E KeyMasterHalDevice: Attest key send cmd failed
E KeyMasterHalDevice: ret: 0
E KeyMasterHalDevice: resp->status: -66
E KeyChain: Failure attesting for key com.android.test.generated-rsa-1: -66
E KeyMasterHalDevice: Attest key send cmd failed
E KeyMasterHalDevice: ret: 0
E KeyMasterHalDevice: resp->status: -41
E KeyChain: Failure attesting for key com.android.test.generated-rsa-1: -41
E DevicePolicyManager: Attestation for com.android.test.generated-rsa-1 failed (rc=4), deleting key.
I keystore: del USRPKEY_com.android.test.generated-rsa-1 1000
I keystore: del USRCERT_com.android.test.generated-rsa-1 1000
I keystore: del CACERT_com.android.test.generated-rsa-1 1000
W KeyChain: WARNING: Removing alias com.android.test.generated-rsa-1, existing grants will be revoked.
E DevicePolicyManager: Error generating key via DevicePolicyManagerService.
I keystore: del USRPKEY_com.android.test.generated-rsa-1 1000
I keystore: del USRSKEY_com.android.test.generated-rsa-1 1000
I keystore: del USRCERT_com.android.test.generated-rsa-1 1000
I keystore: del CACERT_com.android.test.generated-rsa-1 1000
W KeyChain: WARNING: Removing alias com.android.test.generated-rsa-1, existing grants will be revoked.
I s.certinstalle: Explicit concurrent copying GC freed 8285(4111KB) AllocSpace objects, 1(20KB) LOS objects, 92% free, 1065KB/13MB, paused 127us total 15.641ms
I s.certinstalle: Explicit concurrent copying GC freed 59(33KB) AllocSpace objects, 0(0B) LOS objects, 92% free, 1063KB/13MB, paused 74us total 12.278ms
E TestRunner: failed: testGenerateKeyPairWithDeviceIdAttestationExpectingSuccess(com.android.cts.certinstaller.DelegatedDeviceIdAttestationTest)
E TestRunner: ----- begin exception -----
E TestRunner: java.lang.AssertionError: Not true that the subject is a non-null reference
E TestRunner: at com.google.common.truth.FailureStrategy.fail(FailureStrategy.java:24)
E TestRunner: at com.google.common.truth.FailureStrategy.fail(FailureStrategy.java:20)
E TestRunner: at com.google.common.truth.Subject.failWithoutSubject(Subject.java:365)
E TestRunner: at com.google.common.truth.Subject.isNotNull(Subject.java:76)
E TestRunner: at android.keystore.cts.KeyGenerationUtils.generateKeyWithIdFlagsExpectingSuccess(KeyGenerationUtils.java:52)
E TestRunner: at android.keystore.cts.KeyGenerationUtils.generateKeyWithDeviceIdAttestationExpectingSuccess(KeyGenerationUtils.java:60)
E TestRunner: at com.android.cts.certinstaller.DelegatedDeviceIdAttestationTest.testGenerateKeyPairWithDeviceIdAttestationExpectingSuccess(DelegatedDeviceIdAttestationTest.java:35)
E TestRunner: at java.lang.reflect.Method.invoke(Native Method)
E TestRunner: at android.test.InstrumentationTestCase.runMethod(InstrumentationTestCase.java:220)
E TestRunner: at android.test.InstrumentationTestCase.runTest(InstrumentationTestCase.java:205)
E TestRunner: at junit.framework.TestCase.runBare(TestCase.java:134)
E TestRunner: at junit.framework.TestResult$1.protect(TestResult.java:115)
E TestRunner: at androidx.test.internal.runner.junit3.AndroidTestResult.runProtected(AndroidTestResult.java:73)
E TestRunner: at junit.framework.TestResult.run(TestResult.java:118)
E TestRunner: at androidx.test.internal.runner.junit3.AndroidTestResult.run(AndroidTestResult.java:51)
E TestRunner: at junit.framework.TestCase.run(TestCase.java:124)
E TestRunner: at androidx.test.internal.runner.junit3.NonLeakyTestSuite$NonLeakyTest.run(NonLeakyTestSuite.java:62)
E TestRunner: at androidx.test.internal.runner.junit3.AndroidTestSuite$2.run(AndroidTestSuite.java:101)
E TestRunner: at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:462)
E TestRunner: at java.util.concurrent.FutureTask.run(FutureTask.java:266)
E TestRunner: at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1167)
E TestRunner: at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:641)
E TestRunner: at java.lang.Thread.run(Thread.java:919)
E TestRunner: ----- end exception -----
```
