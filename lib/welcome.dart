import 'package:deaf_glove/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/bluetooth_service.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _bluetoothService = Get.find<BluetoothService>();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Request permissions
      final bluetoothStatus = await Permission.bluetooth.request();
      final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      final bluetoothScanStatus = await Permission.bluetoothScan.request();

      if (bluetoothStatus.isGranted &&
          bluetoothConnectStatus.isGranted &&
          bluetoothScanStatus.isGranted) {
        // Initialize Bluetooth
        await _bluetoothService.initialize();
        
        // Navigate to home screen
        Get.off(() => Homepage());
      } else {
        setState(() {
          _error = 'Bluetooth permissions are required to use this app';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize app: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: Image.asset(
                  'images/deaf.png',
                  height: 100.h,
                  width: 100.w,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Deaf Glove',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Understand the deaf person through this application',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 224, 223, 223),
                  foregroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  // Navigate to the next screen or perform any action
                 Get.to(()=>Homepage());
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Security App'),
      ),
      body: Center(
        child: Text('Welcome to the Car Security App!'),
      ),
    );
  }
}
