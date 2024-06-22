import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollbarWithSlideAnimation extends StatefulWidget {
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

  const ScrollbarWithSlideAnimation(
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
      this.hideThumbWhenOutOfOffset = false});

  @override
  ScrollbarWithSlideAnimationState createState() => ScrollbarWithSlideAnimationState();
}

class ScrollbarWithSlideAnimationState extends State<ScrollbarWithSlideAnimation> with SingleTickerProviderStateMixin {
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

  double get minScrollOffset => widget.minScrollOffset ?? 0;
  double get maxScrollOffsetFromEnd => widget.maxScrollOfssetFromEnd ?? 0;

  Timer? plannedHidding;

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

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController!.position.isScrollingNotifier.addListener(_onScrollStatusChanged);
    });
  }

  Widget _createDeffaultThumb(BuildContext context, bool isDragging) {
    return Container(width: 6, height: 100, color: Colors.black.withOpacity(0.7));
  }

  @override
  void didChangeDependencies() {
    if (_scrollController == null) {
      _scrollController = widget.controller ?? PrimaryScrollController.of(context);
      _scrollController!.addListener(_onScroll);
    } else if (widget.controller == null) {
      _scrollController!.removeListener(_onScroll);
      _scrollController = PrimaryScrollController.of(context);
      _scrollController!.addListener(_onScroll);
      _scrollController!.position.isScrollingNotifier.addListener(_onScrollStatusChanged);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollOffset = _scrollController!.offset - minScrollOffset;
    final totalScrollOffset = _scrollController!.position.maxScrollExtent - maxScrollOffsetFromEnd - minScrollOffset;
    _thumbOffset = (scrollOffset / totalScrollOffset * _maxThumbOffset);
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
      plannedHidding?.cancel();
      plannedHidding = null;
      _showThumb();
      return;
    }

    if (_thumbShouldHide()) {
      plannedHidding?.cancel();
      plannedHidding = null;

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
    plannedHidding = Timer(widget.durationBeforeHide, () {
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
                )))
      ],
    );
  }

  void _onThumbDragged(details) {
    final newOffset = _calculateOffset(details, _scrollController!);
    _scrollController!.jumpTo(newOffset);
  }

  double _calculateOffset(DragUpdateDetails details, ScrollController controller) {
    final maxScrollOffset = _scrollController!.position.maxScrollExtent - maxScrollOffsetFromEnd;
    final scrollDelta = details.primaryDelta! / _scrollBarHeight;
    final oldOffset = max(minScrollOffset, controller.offset);
    double newOffset = (oldOffset + scrollDelta * maxScrollOffset).clamp(minScrollOffset, maxScrollOffset);
    return newOffset;
  }
}
