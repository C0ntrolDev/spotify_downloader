import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/domain.dart';

abstract class SpotifyProfileRepository {
  Future<Result<Failure, SpotifyProfile>> getSpotifyProfile(SpotifyRepositoryRequest spotifyClientRequest);
}