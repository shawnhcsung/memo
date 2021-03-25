# Serial

- UART: Universal Asynchronous Receiver-Transmitter
- I2C: Inter-Integrated Circuit
- SPI: Serial Peripheral Interface

|            | UART      | I2C         | SPI                  |
|------------|-----------|-------------|----------------------|
| Clock      | 0 (Async) | 1 (Sync)    | 1 (Sync)             |
| Wires      | TX, RX    | SDA, SCL    | SCLK, MOSI, MISO, SS |
| Connection | 1-to-1    | Half duplex | Full duplex          |
| Top Speed  | 20 Kbps   | 1 Mbps      | 25 Mbps              |
| Validation | Yes       | Yes         | No                   |

## UART

As there is no clock signal in UART, how do we know when is the start of a message and how to divide it in bit?

### Baud Rate

Before sending data to a receiver, define a data rate that is supported by both of the devices, for example, commonly used 9600 bps. So receiver now knows to capture the voltage difference every 104 us (1/9600). Common UART baud rates are 9600, 115200 or 921600.

### Start/Stop Bit

UART is conventionally held at high voltage level (5V) when idle. Pull the voltage from high to low (0V) can be used to inform the receiver that transmission is going to start.

Similarly, in contrast to start bit, stop bit is pulling the voltage to high for representing the end of a message. In a few cases, two stop bits is used alternatively.

### Parity Bit (optional)

Parity bit describes the evenness or oddness of the sending data, so receiver can tell if the received data stream is correct or not, since the bits can be changed due to electromagnetic radiation, mismatched baud rates ... etc. Of course, we can't detect the error if unfortunately two or even bits are flipped.

After receiving the whole data frame, receiver counts the number of `1`s and check if the total is an even or odd number. (`0`: even parity, `1`: odd parity)

### Data Frame

The length of a data frame is from 5 to 9 bits. When parity bit is included, the maximum data length is 8 bits (8+1=9).

Note that data is typically sent with the least significant bit (LSB) first. For instance, the data `0xA4 (1010 0100)` will be sent in reverse order `0 0 1 0 0 1 0 1`.

### Sending Data Over UART

Example 1:

```
‾‾‾‾|__
```

## I2C