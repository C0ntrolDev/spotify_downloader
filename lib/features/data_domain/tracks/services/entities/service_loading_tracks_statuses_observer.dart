import 'package:spotify_downloader/features/data_domain/tracks/services/entities/service_loading_track_id.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/service_loading_track_status.dart';

class ServiceLoadingTracksStatusesObserver {
  void Function(Iterable<(ServiceLoadingTrackId, ServiceLoadingTrackStatus)>)? onUpdate;
}