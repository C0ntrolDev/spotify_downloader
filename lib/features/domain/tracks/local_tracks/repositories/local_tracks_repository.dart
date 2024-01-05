import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';

abstract class LocalTracksRepository {
  Future<Result<Failure, LocalTrack?>> getLocalTrack(LocalTracksCollection localTracksCollection, String spotifyId);
  Future<Result<Failure, void>> saveLocalTrack(LocalTrack localTrack);
  Future<Result<Failure, void>> removeLocalTrack(LocalTrack localTrack);
}