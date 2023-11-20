import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField(
      {super.key,
      required this.theme,
      required this.onSubmitted,
      this.controller,
      required this.iconPadding,
      this.height,
      this.width});

  final ThemeData theme;
  final EdgeInsets iconPadding;
  final double? height;
  final double? width;
  final void Function(String value) onSubmitted;
  final TextEditingController? controller;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController textEditingController;
  final ScrollController scrollController = ScrollController();

  late final FocusNode textInputFocusNode = FocusNode()
    ..addListener(() {
      if (!textInputFocusNode.hasFocus) {
        scrollController.jumpTo(0);
      }
    });

  @override
  void dispose() {
    textInputFocusNode.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textEditingController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(color: searchFieldColor, borderRadius: BorderRadius.circular(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
            padding: widget.iconPadding,
            constraints: const BoxConstraints(),
            onPressed: () => widget.onSubmitted(textEditingController.text),
            icon: SvgPicture.asset(
              'resources/images/svg/search_icon.svg',
            ),
          ),
          Expanded(
            child: TextField(
              controller: textEditingController,
              focusNode: textInputFocusNode,
              scrollController: scrollController,
              onSubmitted: widget.onSubmitted,
              style: widget.theme.textTheme.bodyMedium?.copyWith(color: onPrimaryColor),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ссылка на трек, плейлист или альбом',
                  hintStyle: widget.theme.textTheme.bodyMedium?.copyWith(color: onSearchFieldColor)),
            ),
          ),
        ],
      ),
    );
  }
}
