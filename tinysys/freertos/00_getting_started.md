# Getting Started

## Building Demo Source

Download the source code from [FreeRTOS](https://github.com/FreeRTOS/FreeRTOS):

```
git clone https://github.com/FreeRTOS/FreeRTOS.git
```

Follow the instruction [here](https://www.freertos.org/FreeRTOS-simulator-for-Linux.html) to build the simulator demo on Linux:

```
cd FreeRTOS/FreeRTOS/Demo/Posix_GCC
make
```

You will get the following error:

```
main_full.c:77:10: fatal error: FreeRTOS.h: No such file or directory
   77 | #include <FreeRTOS.h>
      |          ^~~~~~~~~~~~
compilation terminated.
make: *** [Makefile:79: build/main_full.o] Error 1
```

By reading [Repository structure](https://github.com/FreeRTOS/FreeRTOS#repository-structure) carefully, you'll find this:

> FreeRTOS/Source contains the FreeRTOS kernel source code (submoduled from https://github.com/FreeRTOS/FreeRTOS-Kernel).

So we have to download the kernel as well, and extract it to `FreeRTOS/Source`. After all, you should be able to build the demo source into the `build` directory now:

```
$ ls -l
total 144
-rw-rw-r-- 1   148 FreeRTOS-simulator-for-Linux.url
-rw-rw-r-- 1  7990 FreeRTOSConfig.h
-rw-rw-r-- 1  3453 Makefile
drwxrwxr-x 3   304 build
-rw-rw-r-- 1 16848 code_coverage_additions.c
-rw-rw-r-- 1  1879 console.c
-rw-rw-r-- 1  1604 console.h
-rw-rw-r-- 1 14721 main.c
-rw-rw-r-- 1 11014 main_blinky.c
-rw-rw-r-- 1 30759 main_full.c
-rw-rw-r-- 1  2400 run-time-stats-utils.c
-rw-rw-r-- 1 14039 trcConfig.h
-rw-rw-r-- 1 17696 trcSnapshotConfig.h
```

Run `./build/posix_demo`:

```
Trace started.
The trace will be dumped to disk if a call to configASSERT() fails.

The trace will be dumped to disk if Enter is hit.
Starting echo blinky demo
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from software timer
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from task
Message received from software timer
Message received from task
Message received from task
...
```

## RTOS Fundamentals

Heap memory management
Task management
Queue management
Software Timer management
Interrupt management
Resource management
Event groups
Task notifications
Low power support

### Multitasking

A piece of code (instructions) for a particular function can be regarded as a task to operating sㄋystem.

Operating systems should be capable of running multiple tasks seemingly simultaneously even on a platform with single-core CPU.

For this purpose, the following concepts are introduced:

- Memory management
  - Heap
- Task management
- Queue management

- Scheduling
  - Task priorities
  - Task states
  - Co-routine priorities
  - Co-routine states
- Context Switching

### Scheduling

### Context Switching
