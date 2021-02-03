# Ubuntu

## FAQ

- Stuck at "A start job is running for Wait For Network to be configured" on boot

  Add `optional: true` to the network devices in `/etc/netplan/$yaml`
