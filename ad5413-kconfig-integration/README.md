# AD5413 Kconfig Integration

This directory contains example files to integrate the AD5413 DAC driver into the Linux kernel build system via `menuconfig`. This guidance is provided for reference only; customers should adjust steps as needed to suit their specific Linux distribution and kernel build environment.

## Files

* **Kconfig**
  Defines the `CONFIG_AD5413` option to build the AD5413 driver as a module or builtin.
* **Makefile**
  Registers `ad5413.o` for compilation when `CONFIG_AD5413` is enabled.

## Integration Steps

1. **Copy files into the kernel source tree**

   * Place this `Kconfig` in `drivers/iio/dac/` alongside other DAC driver Kconfig files.
   * Update `drivers/iio/Makefile` to include `ad5413.o` under the IIO DAC rules.

2. **Modify parent Kconfig & Makefile**

   * In `drivers/iio/Kconfig`, add near the end:

     ```kconfig
     source "drivers/iio/dac/Kconfig"
     ```
   * In `drivers/iio/Makefile`, append:

     ```makefile
     obj-$(CONFIG_AD5413)    += dac/ad5413.o
     ```

3. **Configure and compile**

   ```bash
   cd /path/to/linux
   make menuconfig
     → Device Drivers → Industrial I/O support → IIO ADC/DAC support
       → [M] Analog Devices AD5413 DAC driver
   make ARCH=<arch> CROSS_COMPILE=<prefix>- modules
   ```

4. **Install and load the module**

   ```bash
   sudo cp drivers/iio/dac/ad5413.ko /lib/modules/$(uname -r)/extra/
   sudo depmod -a
   sudo modprobe ad5413
   ls /sys/bus/iio/devices/
   ```

After successful insertion, you should see an `iio:deviceX` entry, allowing you to read/write DAC values via sysfs.
