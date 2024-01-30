import 'package:flutter/material.dart';

class SwitchTile extends StatelessWidget {
  const SwitchTile(this.title, this.value, this.callback, {super.key});

  final String title;
  final bool value;
  final Function(bool) callback;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        contentPadding: const EdgeInsets.only(left: 8, right: 4),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(48))),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        value: value,
        onChanged: (isOpen) => callback(isOpen));
  }
}

class IconTextTitle extends StatelessWidget {
  const IconTextTitle(this.title, this.icon, {super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 4),
      Icon(icon, color: Theme.of(context).colorScheme.outline, size: 20),
      const SizedBox(width: 8),
      SelectableText(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Theme.of(context).colorScheme.outline),
      )
    ]);
  }
}

class RadioTile extends StatelessWidget {
  const RadioTile(
      this.title, this.tooltip, this.groupValue, this.value, this.callback,
      {super.key});

  final String title;
  final String tooltip;
  final int value;
  final int groupValue;
  final Function(int?) callback;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: value,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(48))),
      contentPadding: const EdgeInsets.only(left: 4, right: 0),
      groupValue: groupValue,
      toggleable: true,
      activeColor: Theme.of(context).colorScheme.secondary,
      title: Text(title),
      onChanged: (val) => callback(val),
      secondary: IconButton(
        icon: const Icon(Icons.info_outline, size: 20),
        onPressed: () {},
        tooltip: tooltip,
      ),
      selected: groupValue == value,
    );
  }
}
