import 'package:flutter/material.dart';

class SettingsGroup extends StatefulWidget {
  const SettingsGroup({super.key, required this.header, required this.settings});

  final String header;
  final List<Widget> settings;

  @override
  State<SettingsGroup> createState() => _SettingsGroupState();
}


class _SettingsGroupState extends State<SettingsGroup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              widget.header,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.settings.map((settingWidget) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: settingWidget,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
