# AD5413 Out-of-Tree Driver

**Target Platform:** Raspberry Pi 4B running Debian Bookworm

This README provides step-by-step instructions to build, install, and load the AD5413 IIO DAC driver out-of-tree on Raspberry Pi 4B with Debian Bookworm. Adjust commands and paths as needed.

## Files in this directory

* `ad5413.c` – IIO DAC driver source code
* `ad5413.dts` – Device Tree source for AD5413 overlay
* `Makefile` – Out-of-tree build script for `ad5413.ko`
* `install_dtbo.sh` – Compile `ad5413.dts` to `ad5413.dtbo` and copy it to `/boot/firmware/overlays`
* `insert_modules.sh` – Load required kernel modules and `ad5413.ko`

## Prerequisites

Install required packages:

```bash
sudo apt update
sudo apt install raspberrypi-kernel-headers device-tree-compiler build-essential
```

## 1. Build the kernel module

```bash
cd $(dirname "$0")
make
# Generates: ad5413.ko
```

## 2. Install Device Tree Overlay

```bash
sudo ./install_dtbo.sh
# Produces ad5413.dtbo and copies it to /boot/firmware/overlays
```

Edit `/boot/firmware/config.txt` and add:

```text
dtoverlay=ad5413
```

Reboot to apply the overlay.

Verify the overlay file exists:

```bash
ls /boot/firmware/overlays/ad5413.dtbo
```

## 3. Load modules

```bash
sudo ./insert_modules.sh
# Runs modprobe industrialio and insmod ad5413.ko
```

Alternatively, manually:

```bash
sudo modprobe industrialio
sudo insmod ad5413.ko
```

## 4. Verify installation

```bash
ls /sys/bus/iio/devices/
# Should show: iio:device0

ls /sys/bus/iio/devices/iio:device0
# name  of_node  out_voltage_offset  out_voltage_powerdown  out_voltage_raw  out_voltage_scale  power  subsystem  uevent  waiting_for_supplier
```

## 5. Basic usage

Set DAC output (raw counts):

```bash
echo 32768 | sudo tee /sys/bus/iio/devices/iio:device0/out_voltage_raw
```

Read back DAC value:

```bash
cat /sys/bus/iio/devices/iio:device0/out_voltage_raw
```

---

*This guide is specific to Raspberry Pi 4B running Debian Bookworm. For other platforms or distributions, adapt steps and paths accordingly.*
