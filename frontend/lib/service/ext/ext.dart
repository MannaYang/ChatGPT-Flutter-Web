import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/chat/model/chat_prompt_info.dart';

///
/// TextStyle
///
const style12 = TextStyle(fontSize: 12);
const styleWeight12 = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const style13 = TextStyle(fontSize: 13);
const styleWeight13 = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
const style14 = TextStyle(fontSize: 14);
const styleWeight14 = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
const style15 = TextStyle(fontSize: 15);
const styleWeight15 = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
const style16 = TextStyle(fontSize: 16);
const styleWeight16 = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
const style18 = TextStyle(fontSize: 18);
const styleWeight18 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const style20 = TextStyle(fontSize: 20);
const styleWeight20 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const style48 = TextStyle(fontSize: 48);
const styleWeight48 = TextStyle(fontSize: 48, fontWeight: FontWeight.bold);

TextStyle? labelLarge(BuildContext context) {
  return Theme.of(context).textTheme.labelLarge;
}

///
/// ColorTheme
///
Color primary(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

Color onSecondaryContainer(BuildContext context) {
  return Theme.of(context).colorScheme.onSecondaryContainer;
}

const color80 = Color(0x80000000);

///
/// FileExtensions
///
const imageExt = ["jpg", "jpeg", "png", "webP"];
const fileExt = ["pdf", "docx", "txt", "md"];
const audioExt = ["wav"];

isImage(String ext) => imageExt.contains(ext);

isFile(String ext) => fileExt.contains(ext);

isAudio(String ext) => audioExt.contains(ext);

///
/// PromptTemplate display
///
final promptTemplateList = [
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic1,
      content: t.chat.chat_prompt_content1,
      label: t.chat.chat_prompt_label),
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic2,
      content: t.chat.chat_prompt_content2,
      label: t.chat.chat_prompt_label),
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic3,
      content: t.chat.chat_prompt_content3,
      label: t.chat.chat_prompt_label),
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic4,
      content: t.chat.chat_prompt_content4,
      label: t.chat.chat_prompt_label),
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic5,
      content: t.chat.chat_prompt_content5,
      label: t.chat.chat_prompt_label),
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic6,
      content: t.chat.chat_prompt_content6,
      label: t.chat.chat_prompt_label),
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic7,
      content: t.chat.chat_prompt_content7,
      label: t.chat.chat_prompt_label),
  ChatPromptInfo(
      topic: t.chat.chat_prompt_topic8,
      content: t.chat.chat_prompt_content8,
      label: t.chat.chat_prompt_label),
];

///
/// check time length and substring it
///
String checkTimeStr(String displayTime) {
  if (displayTime.isEmpty) return '';
  return displayTime.replaceAll("T", " ");
}