# Step 1: Enable Your Wi-Fi Device

```
nmcli dev status
```

You should get a list of your network devices along with their type, state, and network connection info.

If you're not sure whether your Wi-Fi device is enabled or not, you can check with this command:

```
nmcli radio wifi
```

If the output shows that the Wi-Fi is *disabled*, you can enable it with the following command:

```
nmcli radio wifi on
```

# Step 2: Identify a Wi-Fi Access Point

If you don't know the name of your Wi-Fi access point, otherwise known as the SSID, you can find it by scanning for nearby Wi-Fi networks.

```
nmcli dev wifi list
```

Note the name listed under SSID for the network you want to connect to. You'll need it for the next step.

# Step 3: Connect to Wi-Fi

With Wi-Fi enabled and your SSID identified, you're now ready to connect. You can establish a connection with the following command:

```
sudo nmcli dev wifi connect network-ssid
```

Replace network-ssid with the name of your network. If you have WEP or WPA security on your WI-Fi, you can specify the network password in the command as well.

```
sudo nmcli dev wifi connect network-ssid password "network-password"
```

Alternatively, if you don't want to write out your password onscreen, you can use the --ask option.

```
sudo nmcli --ask dev wifi connect network-ssid
```

The system will now ask you to enter your network password without making it visible.

Your device should now be connected to the internet. Test it with a ping.

```
ping google.com
```

# Managing Network Connections with nmcli

You can view all the saved connections by issuing the following command:

```
nmcli con show

```

If you're connected to one network, but you want to use a different connection, you can disconnect by switching the
connection to down. You'll need to specify the SSID, or if you have multiple connections with the same SSID, use the UUID.


```
nmcli con down ssid/uuid
```

To connect to another saved connection, simply pass the up option in the nmcli command. Make sure that you specify the SSID or
UUID of the new network that you want to connect with.

```
nmcli con up ssid/uuid
```












