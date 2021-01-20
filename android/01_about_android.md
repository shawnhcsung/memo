# About Android

## How to download source code

- Install [repo](https://source.android.com/setup/develop#installing-repo)
- Init the repository

  ```bash
  mkdir android
  cd android
  repo init -u https://android.googlesource.com/platform/manifest --depth=1
  ```

  - `--depth=1`: you'll see only the last one commit in the history (check `git clone --help` )

- Create an alias (optional)

  ```bash
  alias reposync='repo sync -qc --no-tags --no-clone-bundle'
  ```

  - `-q`: Quite. Will only show the progress summary
  - `-c`: Sync the current branch only
  - `--no-tags`: Don't fetch tags
  - `--no-clone-bundle`: Disable [git-bundle](https://git-scm.com/docs/git-bundle)

- Sync the code

  ```bash
  reposync # call the alias that is just created
  ```

## Android Boot Process

Android(R)'s boot process by sequence is as below:

1. ROM

    When the device is powered on, system chip will read a predefined area in ROM, copy these codes to RAM and execute it. We call this very first program **Preloader**. The preloader will prepare the environment and bring up the bootloader.

2. Bootloader

    Bootloader is a more complex program than preloader. Currently there are mainly two types of bootloader: LK and 

3. Kernel
4. Init
5. Zygote / Dalvik VM
6. System servers
