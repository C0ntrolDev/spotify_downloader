import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollbarWithSlideAnimation extends StatefulWidget {
  final Widget Function(BuildContext context, bool isDragging)? thumbBuilder;
  final ScrollController? controller;
  final Widget child;
  final double? scrollBarHeight;

  final Curve animationCurve;
  final Duration animationDuration;

  final Duration durationBeforeHide;

  const ScrollbarWithSlideAnimation({
    super.key,
    required this.child,
    this.thumbBuilder,
    this.controller,
    this.scrollBarHeight,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 500),
    this.durationBeforeHide  = const Duration(seconds: 1)
  });

  @override
  ScrollbarWithSlideAnimationState createState() => ScrollbarWithSlideAnimationState();
}

class ScrollbarWithSlideAnimationState extends State<ScrollbarWithSlideAnimation>
    with SingleTickerProviderStateMixin {
  late final Widget Function(BuildContext context, bool isDragging) _thumbBuilder;
  ScrollController? _scrollController;

  double _thumbOffset = 0;
  double thumbHeight = 0;
  double get _scrollBarHeight => widget.scrollBarHeight ?? context.size!.height;

  late final AnimationController _animationController;
  late final Animation<Offset> _animationOffset;

  bool _isThumbShown = false;
  bool _isDragging = false;

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
    setState(() {
      _thumbOffset =
          _scrollController!.offset / _scrollController!.position.maxScrollExtent * (_scrollBarHeight - thumbHeight);
    });
  }

  void _onScrollStatusChanged() {
    if (_scrollController!.position.isScrollingNotifier.value && !_isThumbShown) {
      _showThumb();
      return;
    }

    if (_thumbShouldHide()) {
      _schedulePossibleThumbHidding();
    }
  }

  void _showThumb() {
    _animationController.forward();
    _isThumbShown = true;
  }

  bool _thumbShouldHide() => !_scrollController!.position.isScrollingNotifier.value && _isThumbShown && !_isDragging;

  void _schedulePossibleThumbHidding() {
    Future.delayed(widget.durationBeforeHide, () {
      if (_thumbShouldHide()) {
        _animationController.reverse();
        _isThumbShown = false;
      }
    });
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
            child: Align(
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
    double listHeightToScreenHeightRatio = controller.position.maxScrollExtent / _scrollBarHeight;
    double newOffset = controller.offset + details.primaryDelta! * listHeightToScreenHeightRatio;
    newOffset =
        newOffset.clamp(_scrollController!.position.minScrollExtent, _scrollController!.position.maxScrollExtent);

    return newOffset;
  }
}