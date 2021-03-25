# UART (Universal Asynchronous Receiver-Transmitter)

A UART consists of two GPIO (General Purpose Input/Output) pins: one for Tx (Transmit), another for Rx (Receive).

## Pin Control

Linux kernel supports [pin control subsystem](https://www.kernel.org/doc/html/v4.14/driver-api/pinctl.html) for driving specific pins, such as pull-up/down, open drain, load capacitance etc.

## Exmaple

```c
&soc {
    myplatform,foo {
        compatible = "myplatform,foo";
        foo,tx-gpio = <&tlmm 16 0x00>;
        foo,rx-gpio = <&tlmm 17 0x00>;

        pinctrl-names = "default", "sleep", "active", "rx-active", "tx-active";
        pinctrl-0 = <&foo_sd_active &serial1_tx_sleep  &serial1_rx_active>;
        pinctrl-1 = <&foo_sd_active &serial1_tx_sleep  &serial1_rx_sleep>;
        pinctrl-2 = <&foo_sd_active &serial1_tx_active &serial1_rx_active>;
        pinctrl-3 = <&foo_sd_active &serial1_tx_sleep  &serial1_rx_active>;
        pinctrl-4 = <&foo_sd_active &serial1_tx_active &serial1_rx_sleep>;

        vio_foo-supply = <&pm8953_l5>;
        vcc_foo-supply = <&pm8953_l8>;

        clock-names = "core", "iface";
        clocks = <&clock_gcc clk_gcc_blsp2_uart1_apps_clk>,
            <&clock_gcc clk_gcc_blsp2_ahb_clk>;

        status = "ok";
    };
};
```

```c
&tlmm {
    serial1_tx_active: serial1_tx_active {
        mux {
            pins = "gpio16";
            function = "blsp_uart5";
        };
        config {
            pins = "gpio16";
            drive-strength = <2>;
            bias-disable;
        };
    };

    serial1_tx_sleep: serial1_tx_sleep {
        mux {
            pins = "gpio16";
            function = "gpio";
        };
        config {
            pins = "gpio16";
            drive-strength = <2>;
            bias-disable;
        };
    };

    serial1_rx_active: serial1_rx_active {
        mux {
            pins = "gpio17";
            function = "blsp_uart5";
        };
        config {
            pins = "gpio17";
            drive-strength = <2>;
            bias-pull-up;
        };
    };

    serial1_rx_sleep: serial1_rx_sleep {
        mux {
            pins = "gpio17";
            function = "gpio";
        };
        config {
            pins = "gpio17";
            drive-strength = <2>;
            bias-pull-up;
        };
    };
};

```

```c
static int foo_probe(struct platform_device *pdev)
{
    struct device *dev = &pdev->dev;
}

static int foo_remove(struct platform_device *pdev)
{
}

static const struct of_device_id of_foo_match[] = {
    {
        .compatible = "myplatform,foo"
    },
    { },
};

static struct platform_driver foo_driver = {
    .probe  = foo_probe,
    .remove = foo_remove,
    .driver = {
        .name   = "foo",
        .owner  = THIS_MODULE,
        .of_match_table    = of_match_ptr(of_foo_match),
    },
};

module_platform_driver(foo_driver);
```
