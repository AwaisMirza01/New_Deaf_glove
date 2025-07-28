import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:logger/logger.dart';

final logger = Logger();

class BluetoothService extends GetxService {
  BluetoothConnection? connection;
  final _receivedData = ''.obs;
  final _isConnected = false.obs;

  Stream<String> get receivedDataStream => _receivedData.stream;
  bool get isConnected => _isConnected.value;

  Future<void> initialize() async {
    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      if (devices.isNotEmpty) {
        await connectToDevice(devices.first.address);
      }
    } catch (e) {
      logger.e('Bluetooth initialization error: $e');
    }
  }

  Future<void> connectToDevice(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      _isConnected.value = true;
      
      connection!.input!.listen((Uint8List data) {
        final message = utf8.decode(data);
        _receivedData.value = message;
        logger.d('Received data: ${utf8.decode(data)}');
      }).onDone(() {
        logger.i('Connection done');
        _isConnected.value = false;
      });
    } catch (e) {
      logger.e('Connection error: $e');
      _isConnected.value = false;
    }
  }

  Future<void> disconnect() async {
    try {
      await connection?.close();
      _isConnected.value = false;
    } catch (e) {
      print('Disconnect error: $e');
    }
  }

  Future<void> sendData(String data) async {
    if (!isConnected) return;
    
    try {
      connection?.output.add(utf8.encode(data + '\n'));
      await connection?.output.allSent;
    } catch (e) {
      print('Send data error: $e');
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
