import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/domain/entities/entities.dart';

abstract class LocalTracksRepository {
  Future<Result<Failure, LocalTrack?>> getLocalTrack(LocalTracksCollection localTracksCollection, String spotifyId);
  Future<Result<Failure, void>> saveLocalTrack(LocalTrack localTrack);
  Future<Result<Failure, void>> removeLocalTrack(LocalTrack localTrack);
}