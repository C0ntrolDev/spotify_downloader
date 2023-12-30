import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/entities/spotify_profile.dart';

abstract class SpotifyProfileService {
    Future<Result<Failure, SpotifyProfile>> getSpotifyProfile(AuthorizedClientCredentials clientCredentials);
}