# Keybox

## What is Keybox?

Currently there're two kinds of Keyboxes in Android:

- Widevine DRM Keybox (Digital Rights Management)
- Android Attestation Keybox

### Widevine DRM Keybox

Widevine is a technology company dedicated to provide digital rights management (DRM) solution for distributing digital contents safely over the Internet, and this company was purchased by Google in 2010.

Digital content providers such as YouTube or Netflix may encrypt their contents using Widevine DRM Keybox for protecting their assets from being snipped or redistributed over the Internet.

Android devices must support Widevine DRM keybox, however, it could be at different security levels.

- Level 3

    Every Android device must be at least provisioned with Widevine DRM keybox level 3 (L3), which is the lowest level of security (L1 is the safest). At this level, the keybox is saved in plaintext, and is at a place that could be exposed to users.

    At this level, the digital contents could be restricted or even unavailable. For example, you won't be able to download high definition videos, but only watching them in 480p or something like that. Of course, these all depends on policy of the content providers.

- Level 2 (Not supported by Android)

- Level 1

    At security level 1, the whole DRM process (digital content processing, encryption ...etc.) must be done within the Trusted Execution Environment (TEE) or trust zone completely. In other words, it's safer. The users are now able to download high resolution videos due to the higher security level.

### Android Attestation Keybox (Keymaster)

The attestation keybox (or keymaster) is used for protecting keys on Android devices.


## Reference

- [Google Keybox](https://developers.google.com/android-partner/guide/keybox)
- [Widevine DRM](https://widevine.com/solutions/widevine-drm)
