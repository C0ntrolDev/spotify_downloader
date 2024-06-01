import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_tracks_collection.dart';

abstract class LocalTracksRepository {
  Future<Result<Failure, LocalTrack?>> getLocalTrack(LocalTracksCollection localTracksCollection, String spotifyId);
  Future<Result<Failure, void>> saveLocalTrack(LocalTrack localTrack);
  Future<Result<Failure, void>> removeLocalTrack(LocalTrack localTrack);
}