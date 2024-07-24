import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    required this.theme,
    this.onSubmitted,
    this.onChanged,
    this.hintText = '',
    this.controller,
    this.iconPadding = const EdgeInsets.all(0),
    this.height,
    this.width,
    this.cornerRadius = 5,
    this.textStyle,
    this.hintStyle,
  });

  final ThemeData theme;
  final EdgeInsets iconPadding;
  final double? height;
  final double? width;
  final double cornerRadius;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
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
      decoration: BoxDecoration(color: searchFieldColor, borderRadius: BorderRadius.circular(widget.cornerRadius)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
            padding: widget.iconPadding,
            constraints: const BoxConstraints(),
            onPressed: () => widget.onSubmitted?.call(textEditingController.text),
            icon: SvgPicture.asset(
              'resources/images/svg/search_icon.svg',
              colorFilter: const ColorFilter.mode(onPrimaryColor, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Align(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      surface: surfaceColor,
                      onSurface: onSurfacePrimaryColor
                    )
                  ),
                  child: TextField(
                      controller: textEditingController,
                      focusNode: textInputFocusNode,
                      scrollController: scrollController,
                      onSubmitted: widget.onSubmitted,
                      onChanged: widget.onChanged,
                      style: widget.textStyle ?? widget.theme.textTheme.bodyMedium?.copyWith(color: onPrimaryColor),
                      decoration: InputDecoration(
                          focusedBorder:
                              const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                          disabledBorder:
                              const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                          enabledBorder:
                              const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                          border: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          hintText: widget.hintText,
                          hintStyle: widget.hintStyle ??
                              widget.theme.textTheme.bodyMedium?.copyWith(color: searchFieldHintColor, fontWeight: FontWeight.w700)),
                  ),
                ))
          ),
        ],
      ),
    );
  }
}