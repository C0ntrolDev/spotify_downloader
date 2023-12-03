import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';

class TracksWithLoadingObserverGettingController {
  TracksWithLoadingObserverGettingController({required Function cancelFunction}) : _cancelFunction = cancelFunction;

  Function(Result<Failure, TracksGettingEndedStatus>)? onEnded;
  Function()? onPartGot;

  final Function _cancelFunction;

  void cancelGetting() => _cancelFunction.call();
}
