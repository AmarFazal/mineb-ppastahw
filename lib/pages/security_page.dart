import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  // Dummy list of devices for demonstration
  final List<Device> devices = [
    Device('iPhone 11', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.phone_android),
    Device('iMac OSX · Edge browser', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.tv),
    Device('Iphone 14 pro max', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.phone_android),
    Device('Dell Laptop Win11', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.laptop),
    Device('Reeder s19 max', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.phone_android),
    Device('iMac OSX · Edge 10.2', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.tv),
    Device('Dell Inspiron 5567 Win11', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.laptop),
    Device('Samsung s23 ultra', 'Indonesia, MakassarJan 01 at 00:05pm', Icons.phone_android),
    // Add more devices as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Device History",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "If you see a device here that you believe wasn’t you, please contact our account fraud department immediately.",
              ),
            ),
            const SizedBox(height: 16.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text(
                "List of Devices:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
              onPressed: () {},
              child: const Text('Log out all devices'),
            ),],),
            const SizedBox(height: 16.0),
            // Use ListView.builder to build the list of devices
            ListView.builder(
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                final device = devices[index];
                return ListTile(
                  leading: Icon(device.icon), // Icon for the device type
                  title: Text(device.name),
                  subtitle: Text(device.address),
                  trailing: TextButton(
                    onPressed: () {
                      // Add logout device logic here
                    },
                    child: const Text('Log out'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Device {
  final String name;
  final String address;
  final IconData icon;

  Device(this.name, this.address, this.icon);
}
