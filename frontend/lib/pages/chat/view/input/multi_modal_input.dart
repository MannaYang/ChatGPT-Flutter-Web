import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/chat/model/chat_attach_info.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/service/file/file_model.dart';
import 'package:frontend/service/file/file_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:record/record.dart';

import 'multi_modal_audio.dart';
import 'multi_modal_file.dart';

///
/// Multi-Modal-Input
/// text / doc / image / audio
///
class MultiModalInput extends ConsumerStatefulWidget {
  const MultiModalInput(this.controller, this.handInput,
      {this.hintStr, this.maxWidth = 752, super.key});

  final TextEditingController controller;
  final String? hintStr;
  final double maxWidth;
  final Function(String, List<ChatAttachInfo>) handInput;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MultiModalInputState();
  }
}

class _MultiModalInputState extends ConsumerState<MultiModalInput> {
  late FocusNode _focusNode;
  late final record = AudioRecorder();
  final ScrollController _scrollController = ScrollController();

  ///Attach file list
  late final attachList = <FileInfo>[];

  ///Current input str
  var _inputStr = '';

  Color iconColor(bool allowInput) {
    return allowInput
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.outline;
  }

  double get maxInputHeight => 168;

  double get minInputHeight => 56;
  var modalHeight = 0.0;

  ///
  /// Calculate input height
  /// [TextPainter.maxWidth] Dynamically calculates the width based on your text characters
  ///
  (double, double) inputHeight(String value) {
    final textPainter = TextPainter(
        text: TextSpan(text: value, style: const TextStyle(height: 22)),
        textDirection: TextDirection.ltr,
        maxLines: null)
      // ..layout(maxWidth: widget.maxWidth - 16 * 2 - 128);
      ..layout(maxWidth: 400);
    final lineList = textPainter.computeLineMetrics();
    final lines = lineList.length;
    var lineHeight = lineList.fold(0.0,
        (previousValue, element) => previousValue.toDouble() + element.height);
    final totalHeight = minInputHeight * (lines == 0 ? 1 : lines);
    if (totalHeight > 152) return (152, lineHeight * lines);
    return (totalHeight, lineHeight * lines);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(() {
      if (modalHeight == maxInputHeight) return;
      var (value1, _) = inputHeight(widget.controller.text);
      if (modalHeight == value1) return;
      Future.delayed(Durations.short1, () {
        ref.read(modalInputProvider.notifier).updateHeight(value1);
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    modalHeight = ref.watch(modalInputProvider);
    final allowInput = ref.watch(allowInputProvider);
    final allowRecord = ref.watch(allowRecordProvider);
    ref.listen(attachFileProvider, (previous, next) {
      attachList.clear();
      attachList.addAll(next);
    });
    return AnimatedContainer(
        duration: Durations.medium3,
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
            minWidth: 360,
            maxWidth: widget.maxWidth,
            maxHeight: maxInputHeight),
        height: modalHeight,
        child: Material(
            elevation: 0,
            borderRadius:
                BorderRadius.circular(modalHeight == minInputHeight ? 26 : 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Image.asset('assets/images/ic_chat.png',
                      width: 24, height: 24)),

              ///
              /// When maxLines: null,it will occur
              ///
              /// TextField Line break problem in Chinese input on the web page
              /// https://github.com/flutter/flutter/issues/140728
              ///
              /// Multiline TextField misbehaves on korean inputs only on web
              /// https://github.com/flutter/flutter/issues/134797
              Expanded(
                  child:
                      // TextField(
                      //     focusNode: _focusNode,
                      //     maxLines: null,
                      //     scrollController: _scrollController,
                      //     controller: widget.controller,
                      //     textInputAction: TextInputAction.done,
                      //     keyboardType: TextInputType.multiline,
                      //     expands: true,
                      //     style: style18,
                      //     onSubmitted: (str) => handleInputStr(allowInput),
                      //     enabled: allowInput && !allowRecord,
                      //     onChanged: (str) => _inputStr = str,
                      //     decoration: InputDecoration(
                      //       border: InputBorder.none,
                      //       hintText: allowRecord
                      //           ? t.app.text_field_hint_record
                      //           : t.app.text_field_hint,
                      //       counter: const SizedBox(width: 0, height: 0),
                      //       isCollapsed: true,
                      //       hoverColor: const Color(0xFFCAC4D0),
                      //       contentPadding: const EdgeInsets.only(top: 18),
                      //     )),
                      TextFormField(
                          focusNode: _focusNode,
                          maxLines: null,
                          scrollController: _scrollController,
                          controller: widget.controller,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          expands: true,
                          style: style18,
                          onFieldSubmitted: (str) => handleInputStr(allowInput),
                          enabled: allowInput && !allowRecord,
                          onChanged: (str) => _inputStr = str,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: allowRecord
                                ? t.app.text_field_hint_record
                                : t.app.text_field_hint,
                            counter: const SizedBox(width: 0, height: 0),
                            isCollapsed: true,
                            hoverColor: const Color(0xFFCAC4D0),
                            contentPadding: const EdgeInsets.only(top: 18),
                          ))),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: SizedBox(
                            width: 128,
                            child: MultiModalFile(
                                maxInputHeight, minInputHeight))),
                    Container(
                        width: 128,
                        height: 48,
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(right: 8, bottom: 8),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => uploadFile(),
                              icon: const Icon(Icons.attach_file_outlined),
                              tooltip: "1.Upload image\n2.Upload Vector docs",
                            ),
                            MultiModalAudio(record),
                            IconButton(
                                onPressed: () => handleInputStr(allowInput),
                                icon: Icon(Icons.send,
                                    color: iconColor(allowInput)))
                          ],
                        )),
                  ]),
              // RawKeyboardListener(
              //     focusNode: _focusNode,
              //     onKey: (event) {
              //       // if (event.logicalKey == LogicalKeyboardKey.enter ||
              //       //     event.logicalKey == LogicalKeyboardKey.numpadEnter) {
              //       //   if (!event.isShiftPressed) handleInputStr(allowInput);
              //       // }
              //     },
              //     child: const SizedBox(width: 0, height: 0))
            ])));
  }

  void uploadFile() {
    ref.read(uploadFileProvider.notifier).uploadFile();
  }

  ///
  /// Response send action
  /// - [onSubmitted] - TextField
  /// - [onPressed] - IconButton
  /// - [onKey] - enter
  ///
  void handleInputStr(bool allowInput) {
    if (!allowInput) return;
    var attachRes = attachList.map((e) =>
        ChatAttachInfo(e.fileName!, e.resId!, e.fileName!.split(".").last));
    widget.handInput(_inputStr, attachRes.toList());
    widget.controller.clear();
    _inputStr = '';
  }
}
