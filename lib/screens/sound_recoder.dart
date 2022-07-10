import 'dart:io';
import 'package:escope/screens/setfilename.dart';
import 'package:escope/screens/upload.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


String filepath="";

class SoundRecorder {

  String new_filename=global_filename;
  String new_name="";
  String new_age="";

  FlutterSoundRecorder?_audioRecorder;
  bool _isRecorderInitialised=false;
  bool get isRecording  =>_audioRecorder!.isRecording;
  final Storage storage =Storage();


  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted){
    throw RecordingPermissionException('Microphone permission denied');
    }
      await _audioRecorder!.openAudioSession();
    _isRecorderInitialised=true;

  }



  void dispose(){
    _audioRecorder!.closeAudioSession();
    _audioRecorder=null;
    _isRecorderInitialised=false;
  }



  Future _record() async {
    Directory directory = await getApplicationDocumentsDirectory();
       filepath = directory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.wav';
       print(filepath);

    if(!_isRecorderInitialised)return;
    await _audioRecorder!.startRecorder(toFile: filepath);
    print("started Recording");
  }

  Future _stop() async {
    await _audioRecorder!.stopRecorder();
    print("stoped recording");
    storage.uploadFile(filepath,new_filename);
  }

  Future toggleRecording() async {


    if (_audioRecorder!.isStopped) {
      await _record();
    }
    else {
      await _stop();
      final Storage storage =Storage();

    }
  }

}
