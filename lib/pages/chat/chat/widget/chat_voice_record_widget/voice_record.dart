import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

typedef RecordFc = Function(int sec, String path);

class VoiceRecord {
  static const _dir = "voice";
  static const _ext = ".m4a";
  late String _path;
  int _long = 0;
  late final int _tag;
  final RecordFc _callback;
  final _audioRecorder = Record();

  VoiceRecord(this._callback) : _tag = _now();

  start() async {
    if (await _audioRecorder.hasPermission()) {
      var path = (await getApplicationDocumentsDirectory()).path;
      _path = '$path/$_dir/$_tag$_ext';
      File file = File(_path);
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      _long = _now();
      _audioRecorder.start(path: _path);
    }
  }

  stop() async {
    if (await _audioRecorder.isRecording()) {
      _long = (_now() - _long) ~/ 1000;
      _audioRecorder.stop();
      _callback(_long, _path);
    }
  }

  static int _now() => DateTime.now().millisecondsSinceEpoch;
}
