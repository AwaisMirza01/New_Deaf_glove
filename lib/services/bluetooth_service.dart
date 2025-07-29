import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:logger/logger.dart';

final logger = Logger();

class BluetoothService extends GetxService {
  BluetoothConnection? connection;
  final StreamController<String> _receivedDataController = StreamController<String>.broadcast();
  final _isConnected = false.obs;

  Stream<String> get receivedDataStream => _receivedDataController.stream;
  bool get isConnected => _isConnected.value;

  String _buffer = '';

  Future<BluetoothService> initialize() async {
    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      if (devices.isNotEmpty) {
        await connectToDevice(devices.first.address);
      }
      return this;
    } catch (e) {
      print('Bluetooth initialization error: $e');
      rethrow;
    }
  }

  Future<void> connectToDevice(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(
          address,
      );

      _isConnected.value = true;

      connection!.input!.listen((Uint8List data) {
        // 1. Handle raw bytes properly
        final message = String.fromCharCodes(data);
        _buffer += message;

        // 2. Split by newline (common serial terminator)
        if (_buffer.contains('\n')) {
          final lines = _buffer.split('\n');
          _buffer = lines.removeLast(); // Save incomplete part

          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              _receivedDataController.add(trimmed);
              print('Received: "$trimmed" HEX: ${_stringToHex(trimmed)}');
            }
          }
        }
      }).onDone(() {
        print('Connection closed');
        _isConnected.value = false;
        _buffer = '';
      });
    } catch (e) {
      print('Connection error: $e');
      _isConnected.value = false;
    }
  }

  String _stringToHex(String input) {
    return input.codeUnits.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ');
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
