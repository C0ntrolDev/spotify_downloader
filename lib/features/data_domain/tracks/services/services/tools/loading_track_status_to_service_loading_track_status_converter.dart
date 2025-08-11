import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/service_loading_track_status.dart';

class LoadingTrackStatusToServiceLoadingTrackStatusConverter
    implements ConverterWithParameter<ServiceLoadingTrackStatus, LoadingTrackStatus, ServiceLoadingTrackStatus> {
  @override
  ServiceLoadingTrackStatus convert((LoadingTrackStatus, ServiceLoadingTrackStatus) value) {
    final repositoryStatus = value.$1;
    final prevStatus = value.$2;

    switch (repositoryStatus) {
      case LoadingTrackStatusWaitInLoadingQueue():
        return ServiceLoadingTrackStatusLoading(youTubeUrl: prevStatus.youTubeUrl);
      case LoadingTrackStatusLoading():
        return ServiceLoadingTrackStatusLoading(
            percent: repositoryStatus.percent, youTubeUrl: repositoryStatus.youTubeUrl);
      case LoadingTrackStatusLoaded():
        return ServiceLoadingTrackStatusLoaded(savePath: repositoryStatus.savePath, youTubeUrl: prevStatus.youTubeUrl);
      case LoadingTrackStatusFailure():
        return ServiceLoadingTrackStatusFailure(failure: repositoryStatus.failure);
      case LoadingTrackStatusCancelled():
        return ServiceLoadingTrackStatusNotLoaded(youTubeUrl: prevStatus.youTubeUrl);
    }
  }

  @override
  LoadingTrackStatus convertBack((ServiceLoadingTrackStatus, ServiceLoadingTrackStatus) value) {
    throw UnimplementedError();
  }
}
