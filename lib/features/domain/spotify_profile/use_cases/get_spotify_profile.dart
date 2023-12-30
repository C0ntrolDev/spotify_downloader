import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';

import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/entities/spotify_profile.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/service/spotify_profile_service.dart';

class GetSpotifyProfile implements UseCase<Failure, SpotifyProfile, AuthorizedClientCredentials> {
  GetSpotifyProfile({required SpotifyProfileService spotifyProfileService})
      : _spotifyProfileService = spotifyProfileService;

  final SpotifyProfileService _spotifyProfileService;

  @override
  Future<Result<Failure, SpotifyProfile>> call(AuthorizedClientCredentials clientCredentials) async {
    return _spotifyProfileService.getSpotifyProfile(clientCredentials);
  }
}
