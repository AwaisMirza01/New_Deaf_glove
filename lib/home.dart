import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../controllers/home_controller.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        title: const Text('Deaf Glove'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'Speaker',
            onPressed: () {
              // TODO: Implement speaker functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () {
              Navigator.of(context).pushNamed('/help');
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.of(context).pushNamed('/about');
            },
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            // Bluetooth Connection Status
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.bluetooth,
                    color: homeController.bluetoothService.isConnected ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    homeController.bluetoothService.isConnected ? 'Connected' : 'Disconnected',
                    style: TextStyle(
                      color: homeController.bluetoothService.isConnected ? Colors.green : Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (homeController.bluetoothService.isConnected) {
                        await homeController.bluetoothService.disconnect();
                      } else {
                        final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
                        if (devices.isNotEmpty) {
                          await homeController.bluetoothService.connectToDevice(devices.first.address);
                        }
                      }
                    },
                    child: Text(
                      homeController.bluetoothService.isConnected ? 'Disconnect' : 'Connect',
                    ),
                  ),
                ],
              ),
            ),
            // Display states with proper styling
            ListTile(
              title: const Text('I am Hungry'),
              trailing: Icon(
                homeController.isHungry ? Icons.check_circle : Icons.radio_button_unchecked,
                color: homeController.isHungry ? Colors.green : Colors.grey,
              ),
            ),
            ListTile(
              title: const Text('I am Going to Sleep'),
              trailing: Icon(
                homeController.isSleeping ? Icons.check_circle : Icons.radio_button_unchecked,
                color: homeController.isSleeping ? Colors.green : Colors.grey,
              ),
            ),
            ListTile(
              title: const Text('I Need Water'),
              trailing: Icon(
                homeController.isWater ? Icons.check_circle : Icons.radio_button_unchecked,
                color: homeController.isWater ? Colors.green : Colors.grey,
              ),
            ),
            ListTile(
              title: const Text('I Need Help'),
              trailing: Icon(
                homeController.isHelp ? Icons.check_circle : Icons.radio_button_unchecked,
                color: homeController.isHelp ? Colors.green : Colors.grey,
              ),
            ),
            ListTile(
              title: const Text('I am Waking Up'),
              trailing: Icon(
                homeController.isWake ? Icons.check_circle : Icons.radio_button_unchecked,
                color: homeController.isWake ? Colors.green : Colors.grey,
              ),
            ),
            ListTile(
              title: const Text('I am Alone'),
              trailing: Icon(
                homeController.isAlone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: homeController.isAlone ? Colors.green : Colors.grey,
              ),
            ),
            ListTile(
              title: const Text('I can See'),
              trailing: Icon(
                homeController.isSee ? Icons.check_circle : Icons.radio_button_unchecked,
                color: homeController.isSee ? Colors.green : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }
}

