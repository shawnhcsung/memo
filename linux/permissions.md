# Linux Permissions

## Users and Groups

### User Manipulation

- List all users \
  There are two ways to list all users:

  ```bash
  $ cat /etc/passwd | grep shawn
  shawn:x:1000:1000:shawn:/home/shawn:/bin/bash
  ```

  ```bash
  $ getent passwd | grep shawn
  shawn:x:1000:1000:shawn:/home/shawn:/bin/bash
  ```

- Add a user

  ```bash
  $ sudo useradd demo
  $ getent passwd | grep demo
  demo:x:1001:1001::/home/demo:/bin/sh
  ```

- Delete a user

  ```bash
  $ sudo userdel demo
  $ getent passwd | grep demo
  # <-- no result
  ```

- List the groups that a user belongs to

### Group Manipulation

- List all groups

  ```bash
  $ cat /etc/group | grep chrome
  chrome-remote-desktop:x:135:
  ```

  ```bash
  $ getent group | grep chrome
  chrome-remote-desktop:x:135:
  ```

- Add an existing user to a group

  ```bash
  # usermod -a -G $group $user
  $ sudo usermod -a -G chrome-remote-desktop shawn
  ```
