# Checking Bluetooth Status

Before you can add Bluetooth devices, the Bluetooth service on your computer must be up and running. You can check it with the help of the systemctl command.

```
sudo systemctl status bluetooth
```

If the Bluetooth service status is not active you will have to enable it first. Then start the service so it launches automatically whenever you boot your computer.

```
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
```

# Scanning for Nearby Devices

```
bluetoothctl scan on
```

When you run the command above, your PC will look for and list all the Bluetooth devices that are within the reach of your system.

All Bluetooth devices are labeled as Device followed by their respective Media Access Control (MAC) addresses, a unique identifier for a device on a network. The MAC address follows the format XX : XX : XX : XX : XX : XX. Bluetoothctl also displays the name of the device, for example, ruwido BLE in the output above.

Note: If you can't find the Bluetooth device you are looking for, make sure that your system Bluetooth is discoverable.

To make your Bluetooth adapter discoverable to other devices, use the following command:

```
bluetoothctl discoverable on
```

# Connecting to Your Device

Now that you have a list of Bluetooth devices you can connect to, use the MAC address to connect to a particular device.

The simplest way to connect with a Bluetooth device is to pair it with your PC using the pair command.

```
bluetoothctl pair FC:69:47:7C:9D:A3
```

Note: Remember to replace the MAC address FC:69:47:7C:9D:A3 with the respective MAC address of your device.

If the device you are connecting to has a GUI interface, for example, a smartphone, the device will display a prompt asking you to accept the connection. The system will also ask you to confirm the pairing on your PC. You can do so by typing yes in the command line.

For devices that are already paired with your PC, you can simply connect to them in the future using the connect command as follows:

```
bluetoothctl connect FC:69:47:7C:9D:A3
```

# Listing Paired Devices With bluetoothctl

You can look at the devices that are currently paired with your system by running the following command:

```
bluetoothctl paired-devices
```

You can also list devices that are within the Bluetooth range of your computer using the command below:

```
bluetoothctl devices
```

Trusting Paired Devices

In addition to pairing with a Bluetooth device, you can also choose to trust certain devices so that you easily connect to them in the future.

To trust a Bluetooth device:

```
bluetoothctl trust FC:69:47:7C:9D:A3
```

You can untrust a device by issuing the following command:

```
bluetoothctl untrust FC:69:47:7C:9D:A3
```

# Disconnecting Bluetooth Devices

To unpair a Bluetooth device, use the remove command as follows:

```
bluetoothctl remove FC:69:47:7C:9D:A3
```

You can also disconnect a device from your system using bluetoothctl:

```
bluetoothctl disconnect FC:69:47:7C:9D:A3
```

If you wish to block a specific device from connecting to your system, you can use the block command followed by the MAC address of the device.

```
bluetoothctl block FC:69:47:7C:9D:A3
```

To unblock a device, simply replace the word block in the aforementioned command with unblock.

# Using the Interactive Mode

To enter the interactive mode, simply run the bluetoothctl command without arguments as follows:

```
bluetoothctl
```

After you've switched to the interactive mode, you can issue the commands without prepending bluetoothctl.