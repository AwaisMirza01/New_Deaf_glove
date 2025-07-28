import 'package:deaf_glove/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'about.dart';
import 'help.dart';
import 'services/bluetooth_service.dart';
import 'controllers/home_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX
  await Get.putAsync(() => BluetoothService().initialize());
  Get.put(HomeController());

  // Request Bluetooth permissions
  await Permission.bluetooth.request();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Deaf Glove',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Welcome(),
          routes: {
            '/about': (context) => const AboutPage(),
            '/help': (context) => const HelpPage(),
          },
        );
      },
    );
  }
}
