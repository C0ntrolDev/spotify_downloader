import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class StyledTextField extends StatefulWidget {
  const StyledTextField(
      {super.key,
      required this.theme,
      required this.onSubmitted,
      required this.iconPadding,
      this.height,
      this.width});

  final ThemeData theme;
  final EdgeInsets iconPadding;
  final double? height;
  final double? width;
  final void Function(String value) onSubmitted;

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  String _textFieldValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(color: searchFieldColor, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          IconButton(
            padding: widget.iconPadding,
            constraints: BoxConstraints(),
            onPressed: () => widget.onSubmitted(_textFieldValue),
            icon: SvgPicture.asset(
              'resources/images/svg/search_icon.svg',
            ),
          ),
          Expanded(
            child: TextField(
              onSubmitted: widget.onSubmitted,
              onChanged: (value) => _textFieldValue = value,
              keyboardType: TextInputType.visiblePassword,
              style: widget.theme.textTheme.bodyMedium?.copyWith(color: onPrimaryColor),
              decoration: InputDecoration.collapsed(
                  hintText: 'Ссылка на трек, плейлист или альбом',
                  hintStyle: widget.theme.textTheme.bodyMedium?.copyWith(color: onSearchFieldColor)),
            ),
          ),
        ],
      ),
    );
  }
}
