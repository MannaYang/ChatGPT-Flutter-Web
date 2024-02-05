import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/service/file/file_provider.dart';
import 'package:frontend/service/utils/device_provider.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

///
/// Audio input
/// - [Recording] - recording in realtime
/// - [Upload] - upload one of audio file
///
class MultiModalAudio extends ConsumerWidget {
  const MultiModalAudio(this.recorder, {super.key});

  final AudioRecorder recorder;
  final String tipEmpty =
      "Your multi-modal-config is unselect any one,can not operation this";

  final String tipAudio =
      "Your multi-modal-config is selected text-to-speech,do not operation this";

  final String tipAudio1 =
      "Your multi-modal-config is unselect any one of audio,do not operation this";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowRecord = ref.watch(allowRecordProvider);
    final configValue = ref.watch(settingMultiModalProvider);
    return IconButton(
      onPressed: () => startRecord(ref, allowRecord, configValue),
      icon: getDisplayIcon(allowRecord, context),
      tooltip: "Record audio(speech-to-text)",
    );
  }

  ///
  /// Recording icon status
  ///
  Icon getDisplayIcon(bool state, BuildContext context) {
    var data = state ? Icons.mic_outlined : Icons.mic_none_outlined;
    return Icon(data, color: state ? primary(context) : Colors.black);
  }

  ///
  /// Actual recording
  /// pub lib:[https://pub.dev/packages/record]
  ///
  /// If use it in Android, min SDK: 21 (amrNb/amrWb: 26, Opus: 29)
  /// ```
  /// <uses-permission android:name="android.permission.RECORD_AUDIO" />
  /// ```
  ///
  /// If use it in iOS, min SDK: 11.0
  /// ```
  /// <key>NSMicrophoneUsageDescription</key>
  /// <string>Some message to describe why you need this permission</string>
  /// ```
  ///
  /// If use it in macOS, min SDK: 10.15
  /// ```
  /// <key>NSMicrophoneUsageDescription</key>
  /// <string>Some message to describe why you need this permission</string>
  /// ```
  ///
  void startRecord(WidgetRef ref, bool state, int configValue) async {
    if (!checkMultiModalStatus(ref, configValue)) return;
    if (state) {
      ///
      /// Important Note:
      /// ```
      /// final path = await recorder.stop();
      /// ```
      /// only support web, if you use it not in web, please get the actual file
      /// pub lib:[https://pub.dev/packages/record]
      ///
      final path = await recorder.stop();
      if (path == null) {
        ref.read(allowRecordProvider.notifier).updateStatus(false);
        return;
      }
      if (DeviceProvider.isWeb) {
        final response = await http.get(Uri.parse(path));
        ref.read(uploadFileProvider.notifier).uploadFileUrl(response.bodyBytes);
      } else {
        final result = await File(path).readAsBytes();
        ref.read(uploadFileProvider.notifier).uploadFileUrl(result);
      }
      ref.read(allowRecordProvider.notifier).updateStatus(false);
      return;
    }
    if (await recorder.hasPermission()) {
      var path = "";
      if (!DeviceProvider.isWeb) {
        path = await _getPath();
      }
      await recorder.start(const RecordConfig(encoder: AudioEncoder.wav),
          path: path);
    }
    ref.read(allowRecordProvider.notifier).updateStatus(true);
  }

  ///
  /// speech-to-text
  /// text-to-speech
  ///
  bool checkMultiModalStatus(WidgetRef ref, int configValue) {
    final checkAudio =
        ref.read(settingMultiModalProvider.notifier).checkAudio(configValue);
    //var tip = switch (value) { 0 => tipEmpty, 6 || 7 => tipAudio, _ => "" };
    if (configValue == 0) {
      showSnackBar(tipEmpty);
      return false;
    }
    var tip = checkAudio.$1
        ? checkAudio.$2
            ? ""
            : tipAudio
        : tipAudio1;
    if (tip.isNotEmpty) {
      showSnackBar(tip);
      return false;
    }
    return true;
  }

  Future<String> _getPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.wav',
    );
  }
}
