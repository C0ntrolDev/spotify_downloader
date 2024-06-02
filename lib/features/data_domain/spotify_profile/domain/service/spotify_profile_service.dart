import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/domain.dart';

abstract class SpotifyProfileService {
    Future<Result<Failure, SpotifyProfile>> getSpotifyProfile();
}