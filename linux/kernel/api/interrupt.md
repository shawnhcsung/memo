# Interrupt

## Overview

### What is an IRQ?

An interrupt request (IRQ) is an event raised by either software or hardware when it needs CPU's attention. For example, a keyboard input will trigger a hardware interrupt so we don't need to wait too long for CPU to handle it.

When an interrupt is activated, the CPU will complete the current instruction, and the

### Interrupt Types

- Synchronous: produced by software (exceptions)
  - Processor will throw an exception when it comes to page fault, access of NULL pointer or division by zero
    - Faults \
      The program can be restored without losing continuity after correction (ex. page fault)
    - Traps \
      The process being terminated by trap exception can be continued after all (ex. debugging breakpoints)
    - Aborts \
      For critical situations. The process will be terminated.
  - Kernel or softwares can throw exceptions for handling anomalous conditions that must be done in a short time
- Asynchronous: produced by hardware signals at arbitrary times (interrupts)
  - Maskable
    - Can be ignored \
      The maskable hardware interrupts are designed to be enabled/disabled through software. There's an Interrupt Flag (IF) in the register of Intel CPUs for determining if the process will service maskable interrupts
    - Platform dependent \
      For instance, `RST7.5`, `RST6.5` and `RST5.5` in x86 architecture are maskable hardware interrupts. The hardware devices can use these interrupts for handling lower priority events.
  - Non-maskable (NMI)
    - Should not be ignored \
      Non-maskable interrupts are typically triggered for non-recoverable errors, debugging and profiling, system corruption ...etc. Here we use the word "should not" means there's still a chance that it could be ignored due to higher priority NMIs.

## Programmable Interrupt Controller (PIC)

While it can be problematic if any hardware device can interrupt CPU directly, a hardware component was invented for handling the signals from them. Let's take a look at how Intel 8259 handles interrupts.

```text
        +----------------------------> CPU
        |
        |    Intel 8259
        |    +------------------+
        |    | CAS 2        GND |
        |    | -SP/-EN    CAS 1 |
        +--- | INT        CAS 0 |
Device ----> | IRQ0          D0 |
Device ----> | IRQ1          D1 |
Device ----> | IRQ2          D2 |
Device ----> | IRQ3          D3 |
Device ----> | IRQ4          D4 |
Device ----> | IRQ5          D5 |
Device ----> | IRQ6          D6 |
Device ----> | IRQ7          D7 |
             | -INTA        -RD |
             | A0           -WR |
             | VCC          -CS |
             +------------------+
```

As the system scale grow, 8 interrupt lins are soon not enough. The solution is to cascade two PICs into one. So now we have 16 lines available.

```text
        +----------------------------+         +----------------------------> CPU
        |                            |         |
        |    slave                   |         |    master
        |    +------------------+    |         |    +------------------+
        |    | CAS 2        GND |    |         |    | CAS 2        GND |
        |    | -SP/-EN    CAS 1 |    |         |    | -SP/-EN    CAS 1 |
        +--- | INT        CAS 0 |    |         +--- | INT        CAS 0 |
Device ----> | IRQ0          D0 |    | Device ----> | IRQ0          D0 |
Device ----> | IRQ1          D1 |    | Device ----> | IRQ1          D1 |
Device ----> | IRQ2          D2 |    +------------> | IRQ2          D2 |
Device ----> | IRQ3          D3 |      Device ----> | IRQ3          D3 |
Device ----> | IRQ4          D4 |      Device ----> | IRQ4          D4 |
Device ----> | IRQ5          D5 |      Device ----> | IRQ5          D5 |
Device ----> | IRQ6          D6 |      Device ----> | IRQ6          D6 |
Device ----> | IRQ7          D7 |      Device ----> | IRQ7          D7 |
             | -INTA        -RD |                   | -INTA        -RD |
             | A0           -WR |                   | A0           -WR |
             | VCC          -CS |                   | VCC          -CS |
             +------------------+                   +------------------+
```

|IRQ |Description                          |
|----|-------------------------------------|
|0   | System timer                        |
|1   | Keyboard                            |
|2   | Cascade (interrupts from slave PIC) |
|3   | Serial port COM2                    |
|4   | Serial port COM1                    |
|5   | Parallel port 2 and 3 or sound card |
|6   | Floppy                              |
|7   | Parallel port 1                     |
|8   | RTC timer (real-time clock)         |
|9   | ACPI                                |
|10  | open/SCSI/NIC                       |
|11  | open/SCSI/NIC                       |
|12  | mouse                               |
|13  | Math co-processor                   |
|14  | ATA channel 1                       |
|15  | ATA channel 2                       |

Now that we're mainly focus on how Kernel handles interrupts. Let's stop here for hardware interrupt introduction.

## Kernel Control Path
