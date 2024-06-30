import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotify_downloader/core/utils/utils.dart';

class CustomScrollbar extends StatefulWidget {
  final Widget Function(BuildContext context, bool isDragging)? thumbBuilder;
  final EdgeInsets thumbMargin;
  final ScrollController? controller;
  final Widget child;
  final double? scrollBarHeight;

  final double? minScrollOffset;
  final double? maxScrollOfssetFromEnd;

  final bool hideThumbWhenOutOfOffset;

  final Curve animationCurve;
  final Duration animationDuration;
  final Duration durationBeforeHide;

  final bool isFixedScroll;
  final Widget? _prototypeItem;
  Widget? get prototypeItem => _prototypeItem;

  const CustomScrollbar(
      {super.key,
      required this.child,
      this.thumbBuilder,
      this.controller,
      this.scrollBarHeight,
      this.animationCurve = Curves.easeInOut,
      this.animationDuration = const Duration(milliseconds: 500),
      this.thumbMargin = const EdgeInsets.all(0),
      this.durationBeforeHide = const Duration(seconds: 1),
      this.minScrollOffset,
      this.maxScrollOfssetFromEnd,
      this.hideThumbWhenOutOfOffset = false})
      : isFixedScroll = false,
        _prototypeItem = null;

  const CustomScrollbar.fixedScroll(
      {super.key,
      required this.child,
      this.thumbBuilder,
      this.controller,
      this.scrollBarHeight,
      this.animationCurve = Curves.easeInOut,
      this.animationDuration = const Duration(milliseconds: 500),
      this.thumbMargin = const EdgeInsets.all(0),
      this.durationBeforeHide = const Duration(seconds: 1),
      this.minScrollOffset,
      this.maxScrollOfssetFromEnd,
      this.hideThumbWhenOutOfOffset = false,
      required Widget prototypeItem})
      : _prototypeItem = prototypeItem,
        isFixedScroll = true;

  @override
  CustomScrollbarState createState() => CustomScrollbarState();
}

class CustomScrollbarState extends State<CustomScrollbar> with SingleTickerProviderStateMixin {
  late final Widget Function(BuildContext context, bool isDragging) _thumbBuilder;
  ScrollController? _scrollController;

  double _thumbOffset = 0;
  double thumbHeight = 0;
  double get _scrollBarHeight => (widget.scrollBarHeight ?? context.size!.height) - widget.thumbMargin.vertical;
  double get _maxThumbOffset => _scrollBarHeight - thumbHeight;

  late final AnimationController _animationController;
  late final Animation<Offset> _animationOffset;

  bool _isThumbShown = false;
  bool _isDragging = false;

  bool _isOutOfOffsetScroll = true;

  double get _minScrollOffset => widget.minScrollOffset ?? 0;
  double get _maxScrollOffsetFromEnd => widget.maxScrollOfssetFromEnd ?? 0;
  double? get _maxScrollOffset =>
      _scrollController != null ? _scrollController!.position.maxScrollExtent - _maxScrollOffsetFromEnd : null;

  Timer? _plannedHidding;

  final GlobalKey _prototypeItemKey = GlobalKey();
  double? _prototypeHeight;

  double _scrollBarOffset = 0;

  @override
  void initState() {
    super.initState();
    _thumbBuilder = widget.thumbBuilder ?? _createDeffaultThumb;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animationOffset = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    _updateScrollController();
    _updatePrototypeHeight();
  }

  @override
  void didUpdateWidget(CustomScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateScrollController();
    _updatePrototypeHeight();
  }

  void _updateScrollController() {
    if (_scrollController != null) {
      _scrollController!.removeListener(_onScroll);
      _scrollController!.position.isScrollingNotifier.removeListener(_onScrollStatusChanged);
    }

    _scrollController = widget.controller ?? PrimaryScrollController.of(context);
    _scrollController!.addListener(_onScroll);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController!.position.isScrollingNotifier.addListener(_onScrollStatusChanged);
    });
  }

  void _updatePrototypeHeight() {
    if (widget.isFixedScroll) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _prototypeHeight = (_prototypeItemKey.currentContext?.findRenderObject() as RenderBox?)?.size.height;
      });
    }
  }

  Widget _createDeffaultThumb(BuildContext context, bool isDragging) {
    return Container(width: 6, height: 100, color: Colors.black.withOpacity(0.7));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isDragging) {
      _scrollBarOffset = _scrollController!.offset;
      _updateThumbOffset();
    }
  }

  void _updateThumbOffset() {
    var thumbScrollOffset = _scrollBarOffset - _minScrollOffset;
    final totalScrollOffset = _scrollController!.position.maxScrollExtent - _maxScrollOffsetFromEnd - _minScrollOffset;
    _thumbOffset = (thumbScrollOffset / totalScrollOffset * _maxThumbOffset);
    if (_thumbOffset < 0 || _thumbOffset > _maxThumbOffset || totalScrollOffset < 0) {
      if (!_isOutOfOffsetScroll) {
        _isOutOfOffsetScroll = true;
        if (widget.hideThumbWhenOutOfOffset) {
          _hideThumb();
        }
      }
    } else {
      if (_isOutOfOffsetScroll) {
        _isOutOfOffsetScroll = false;
        if (widget.hideThumbWhenOutOfOffset) {
          _showThumb();
        }
      }
    }

    setState(() {
      _thumbOffset = _thumbOffset.clamp(0, _maxThumbOffset);
    });
  }

  void _onScrollStatusChanged() {
    if (_scrollController!.position.isScrollingNotifier.value && !_isThumbShown && !_isOutOfOffsetScroll) {
      _plannedHidding?.cancel();
      _plannedHidding = null;
      _showThumb();
      return;
    }

    if (_thumbShouldHide()) {
      _plannedHidding?.cancel();
      _plannedHidding = null;

      _schedulePossibleThumbHidding();
    }
  }

  void _showThumb() {
    _animationController.forward();
    _isThumbShown = true;
  }

  bool _thumbShouldHide() =>
      _isOutOfOffsetScroll ||
      (!_scrollController!.position.isScrollingNotifier.value && _isThumbShown && !_isDragging);

  void _schedulePossibleThumbHidding() {
    _plannedHidding = Timer(widget.durationBeforeHide, () {
      if (_thumbShouldHide()) {
        _hideThumb();
      }
    });
  }

  void _hideThumb() {
    _animationController.reverse();
    _isThumbShown = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
            right: 0,
            top: _thumbOffset,
            bottom: 0,
            child: Container(
                padding: widget.thumbMargin,
                alignment: Alignment.topCenter,
                child: SlideTransition(
                  position: _animationOffset,
                  child: GestureDetector(
                      onVerticalDragStart: (_) {
                        _isDragging = true;
                        _showThumb();
                      },
                      onVerticalDragUpdate: _onThumbDragged,
                      onVerticalDragEnd: (_) {
                        setState(() {
                          _isDragging = false;
                        });
                        _schedulePossibleThumbHidding();
                      },
                      child: Container(
                          color: Colors.transparent,
                          child: Builder(builder: (context) {
                            SchedulerBinding.instance.addPostFrameCallback((duration) {
                              thumbHeight = context.size!.height;
                            });

                            return _thumbBuilder(context, _isDragging);
                          }))),
                ))),
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Container(
                key: _prototypeItemKey,
                child: widget.prototypeItem ?? Container(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onThumbDragged(DragUpdateDetails details) {
    final newOffset = _addDragDeltaToOffset(oldOffset: _scrollBarOffset, dragDelta: details.primaryDelta!);
    _scrollBarOffset = newOffset;
    _updateThumbOffset();

    if (widget.isFixedScroll && _prototypeHeight != null) {
      final closestTopItemOffset = newOffset ~/ _prototypeHeight! * _prototypeHeight!;
      final closestBottomItemOffset = (newOffset ~/ _prototypeHeight! + 1) * _prototypeHeight!;

      final newScrollControllerOffset =
          closest(newOffset, closestTopItemOffset, closestBottomItemOffset).clamp(_minScrollOffset, _maxScrollOffset!);

      _scrollController!.jumpTo(newScrollControllerOffset);
    } else {
      _scrollController!.jumpTo(newOffset);
    }
  }

  double _addDragDeltaToOffset({required double oldOffset, required double dragDelta}) {
    final absoluteDelta = dragDelta / _scrollBarHeight;
    oldOffset = max(_minScrollOffset, oldOffset);
    double newOffset = (oldOffset + (absoluteDelta * (_maxScrollOffset! - _minScrollOffset)))
        .clamp(_minScrollOffset, _maxScrollOffset!);
    return newOffset;
  }
}
