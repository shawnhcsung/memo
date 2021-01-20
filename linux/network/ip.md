# Internet Protocol (IP)

## IPv4

IPv4 uses a 32-bit address space.

## IPv6

An IPv6 address is made of 128 bits divided into eight 16-bit blocks. Each block is then separated by ':' symbol. For example:

```text
2001:0000:3238:DFE1:0063:0000:0000:FEFB
```

Since IPv6 address are relatively longer than IPv6 address, there are rules to shorten them:

1. Discard leading Zeroes:

    ```text
    2001:0000:3238:DFE1:63:0000:0000:FEFB
                        ^^
    ```

2. If two of more blocks contain consecutive zeros, omit them all and replace with "::":

    ```text
    2001:0000:3238:DFE1:63::FEFB
                          ^^
    ```

    Another example (localhost):

    ```text
    ::1
    ```

    This is equivalent to:

    ```text
    0000:0000:0000:0000:0000:0000:0000:0001
    ```

3. If there are still blocks of zeros, shrink them down to a single zero:

    ```text
    2001:0:3238:DFE1:63::FEFB
         ^
    ```

### IPv6 Format

- Link-Local Address

    The first 16 bits of link-local address is always always set to FE80. The next 48 bits are set to 0:

    ```text""::
    fe80:0000:0000:0000:0000:0000:0000:0000
                        ^^^^^^^^^^^^^^^^^^^
                        Interface ID (any)
    ```

    Then we can use the following commands to ping:

    ```bash
    ifconfig eth0 inet6 add fd00::f
    ping6 fd00::f%eth0
    ```

### IPv6 Configuration

```bash
ifconfig $iface inet6 add $addr/$prefix
```