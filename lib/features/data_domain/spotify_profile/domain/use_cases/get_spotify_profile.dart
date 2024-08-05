import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/domain.dart';

class GetSpotifyProfile implements UseCase<Failure, SpotifyProfile, void> {
  GetSpotifyProfile({required SpotifyProfileService spotifyProfileService})
      : _spotifyProfileService = spotifyProfileService;

  final SpotifyProfileService _spotifyProfileService;

  @override
  Future<Result<Failure, SpotifyProfile>> call(void params) async {
    return _spotifyProfileService.getSpotifyProfile();
  }
}
