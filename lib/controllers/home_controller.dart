import 'package:get/get.dart';
import '../services/bluetooth_service.dart';
import 'package:just_audio/just_audio.dart';

class HomeController extends GetxController {
  final bluetoothService = Get.find<BluetoothService>();
  late final AudioPlayer _audioPlayer;
  
  final _isHungry = false.obs;
  final _isSleeping = false.obs;
  final _isWater = false.obs;
  final _isHelp = false.obs;
  final _isWake = false.obs;
  final _isAlone = false.obs;
  final _isSee = false.obs;

  bool get isHungry => _isHungry.value;
  bool get isSleeping => _isSleeping.value;
  bool get isWater => _isWater.value;
  bool get isHelp => _isHelp.value;
  bool get isWake => _isWake.value;
  bool get isAlone => _isAlone.value;
  bool get isSee => _isSee.value;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    bluetoothService.initialize();
    _setupBluetoothListener();
  }

  void _setupBluetoothListener() {
    bluetoothService.receivedDataStream.listen((data) {
      _handleReceivedData(data);
    });
  }

  void _handleReceivedData(String data) {
    // Reset all states first
    _isHungry.value = false;
    _isSleeping.value = false;
    _isWater.value = false;
    _isHelp.value = false;
    _isWake.value = false;
    _isAlone.value = false;
    _isSee.value = false;

    // Set the appropriate state and play audio
    switch (data) {
      case 'A':
        _isHungry.value = true;
        _playAudio('sound/audio3.mp3');
        break;
      case 'B':
        _isSleeping.value = true;
        _playAudio('sound/audio4.mp3');
        break;
      case 'C':
        _isWater.value = true;
        _playAudio('sound/audio5.mp3');
        break;
      case 'D':
        _isHelp.value = true;
        _playAudio('sound/audio6.mp3');
        break;
      case 'E':
        _isWake.value = true;
        _playAudio('sound/audio7.mp3');
        break;
      case 'F':
        _isAlone.value = true;
        _playAudio('sound/audio8.mp3');
        break;
      case 'G':
        _isSee.value = true;
        _playAudio('sound/audio9.mp3');
        break;
      default:
        print('Unknown data received: $data');
        break;
    }
  }

  Future<void> _playAudio(String assetPath) async {
    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();
      
      // Set and play the new audio
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
