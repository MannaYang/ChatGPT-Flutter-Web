import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/widget/switch_radio_text_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// Setting-Multi-Modal
///
class SettingMultiModal extends ConsumerWidget {
  const SettingMultiModal({super.key});

  /// MultiModalConfig key
  final String multiModalConfig = "multi-modal-config";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configValue = ref.watch(settingMultiModalProvider);
    return ListView(
      children: [
        const SizedBox(height: 16),
        const SelectableText('Multi-Modal-Tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SelectableText('Tools unsupported prompt template',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),

        /// IMAGE
        const IconTextTitle("IMAGE", Icons.image_outlined),
        RadioTile("Text-To-Image", "Text-To-Image", configValue, 1,
            (val) => handleSelectedValue(ref, val)),
        RadioTile("Image-To-Image", "Image-To-Image", configValue, 2,
            (val) => handleSelectedValue(ref, val)),
        const SizedBox(height: 16),

        /// DOCS
        const IconTextTitle("DOCS", Icons.edit_document),
        RadioTile("Similarity-Search", "Similarity-Search", configValue, 3,
            (val) => handleSelectedValue(ref, val)),
        RadioTile("MMR-Search", "Max-Marginal-Search", configValue, 4,
            (val) => handleSelectedValue(ref, val)),
        RadioTile("Retrieval-Agent", "Retrieval-Agent", configValue, 5,
            (val) => handleSelectedValue(ref, val)),
        const SizedBox(height: 16),

        /// AUDIO
        const IconTextTitle("AUDIO", Icons.audio_file_outlined),
        RadioTile("Speech-To-Text", "Speech-To-Text", configValue, 6,
            (val) => handleSelectedValue(ref, val)),
        RadioTile("Text-To-Speech", "Text-To-Speech", configValue, 7,
            (val) => handleSelectedValue(ref, val)),
        const SizedBox(height: 16),

        /// Clean Selected
        Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => resetSelectedValue(ref),
              icon: Icon(Icons.remove_circle_outline,
                  color: Theme.of(context).colorScheme.secondary),
              label: Text(
                "Clean All",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ))
      ],
    );
  }

  ///
  /// Reset cache value
  ///
  resetSelectedValue(WidgetRef ref) async {
    ref.read(settingMultiModalProvider.notifier).updateStatus(0);
  }

  ///
  /// Cache selected value
  ///
  handleSelectedValue(WidgetRef ref, int? val) async {
    if (val == null) return;
    ref.read(settingMultiModalProvider.notifier).updateStatus(val);
  }
}
