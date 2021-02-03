# Netplan

[Netplan](https://netplan.io/) is a utility for configuring networking on linux.

Example:

```yaml
network:
  ethernets:
    eno1:
      optional: true
      dhcp4: yes
      dhcp4-overrides:
        use-routes: no
      dhcp6: no
      routes:
        - to: 10.0.0.0/8
          via: 10.57.60.253
          metric: 33
        - to: 0.0.0.0/0
          via: 10.57.60.253
          metric: 77
    enp3s0:
      optional: true
      dhcp4: no
      dhcp6: no
      addresses:
        - 192.168.0.66/24
        - fd00::f/8
```

## Connecting to WiFi

- Connecting to a open WiFi

  ```yaml
  network:
    wifis:
      wlp4s0:
        optional: true
        dhcp4: yes
        access-points:
          "ssid": {}
  ```

- Connecting to a secured WiFi

  ```yaml
  network:
    wifis:
      wlp4s0:
        optional: true
        dhcp4: yes
        access-points:
          "ssid":
            password: "******"
  ```
