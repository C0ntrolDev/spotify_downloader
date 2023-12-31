import 'package:flutter/material.dart';

class SettingWithTextField extends StatefulWidget {
  const SettingWithTextField({super.key, required this.title, this.value, this.onChangedValueSubmitted});

  final String title;
  final String? value;
  final Function(String newValue)? onChangedValueSubmitted;

  @override
  State<SettingWithTextField> createState() => _SettingWithTextFieldState();
}

class _SettingWithTextFieldState extends State<SettingWithTextField> {
  final TextEditingController textEditingController = TextEditingController();
  String? textBeforeFocus;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      textEditingController.text = widget.value!;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Text(
              widget.title,
              style: theme.textTheme.bodyMedium,
            ),
          
        ),
        const SizedBox(width: 10),
        Expanded(
            flex: 2,
            child: Focus(
              onFocusChange: (isFocused) {
                if(isFocused) {
                  textBeforeFocus = textEditingController.text;
                }
                if (!isFocused && textBeforeFocus != textEditingController.text) {
                  widget.onChangedValueSubmitted?.call(textEditingController.text);
                }
              } ,
              child: TextField(
                controller: textEditingController,
                style: theme.textTheme.bodyMedium,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 10),
                ),
              ),
            ))
      ],
    );
  }
}
