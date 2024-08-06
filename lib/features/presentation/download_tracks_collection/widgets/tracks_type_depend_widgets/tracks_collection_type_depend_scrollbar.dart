import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollbar_ultima/scrollbar_ultima.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/liked_track.dart';

class TracksCollectionTypeDependScrollbar extends StatelessWidget {
  const TracksCollectionTypeDependScrollbar(
      {super.key,
      required this.type,
      required this.child,
      required this.prototypeItem,
      required this.controller,
      required this.scrollbarPadding,
      required this.minScrollOffset,
      required this.getTrackWithLoadingObserverByIndex});

  final TracksCollectionType type;
  final TrackWithLoadingObserver? Function(int index) getTrackWithLoadingObserverByIndex;
  final Widget child;

  final Widget prototypeItem;
  final ScrollController controller;
  final EdgeInsets scrollbarPadding;
  final double minScrollOffset;

  @override
  Widget build(BuildContext context) {
    if (type == TracksCollectionType.likedTracks) {
      return ScrollbarUltima.semicircle(
          prototypeItem: prototypeItem,
          controller: controller,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          durationBeforeHide: const Duration(seconds: 2),
          scrollbarPadding: scrollbarPadding,
          minScrollOffset: minScrollOffset,
          hideThumbWhenOutOfOffset: true,
          alwaysShowThumb: false,
          isFixedScroll: true,
          precalculateItemByOffset: true,
          itemPrecalculationOffset: minScrollOffset,
          backgroundColor: surfaceColor,
          arrowsColor: onSurfaceSecondaryColor,
          labelSidePadding: 70,
          labelBehaviour: LabelBehaviour.showOnlyWhileAndAfterDragging,
          labelContentBuilder: (offset, precalculatedIndex) {
            String labelText = "";

            if (precalculatedIndex != null) {
              final trackWithLoadingObserver = getTrackWithLoadingObserverByIndex.call(precalculatedIndex);

              if (trackWithLoadingObserver != null) {
                if (trackWithLoadingObserver.track is LikedTrack) {
                  final addedAt = (trackWithLoadingObserver.track as LikedTrack).addedAt;

                  if (addedAt != null) {
                    labelText = DateFormat("MMM yyyy").format(addedAt).toUpperCase();
                  }
                }
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                  child: Container(
                constraints: const BoxConstraints(minWidth: 50),
                child: Text(
                  labelText,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              )),
            );
          },
          child: child);
    }

    return ScrollbarUltima(
        prototypeItem: prototypeItem,
        controller: controller,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        durationBeforeHide: const Duration(seconds: 2),
        scrollbarPadding: scrollbarPadding,
        minScrollOffset: minScrollOffset,
        hideThumbWhenOutOfOffset: true,
        dynamicThumbLength: false,
        alwaysShowThumb: false,
        isFixedScroll: true,
        thumbBuilder: _buildDefaultThumb,
        child: child);
  }

  Widget _buildDefaultThumb(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates) {
    final animatedPosition = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(animation);
    return SlideTransition(
        position: animatedPosition,
        child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(left: 10, right: 7),
            child: Container(
                height: 50,
                width: 5,
                decoration: BoxDecoration(
                    color: widgetStates.contains(WidgetState.dragged) ? primaryColor : onBackgroundSecondaryColor,
                    borderRadius: BorderRadius.circular(2.5)))));
  }
}
