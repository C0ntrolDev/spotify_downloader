import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/entities/spotify_profile.dart';

abstract class SpotifyProfileService {
    Future<Result<Failure, SpotifyProfile>> getSpotifyProfile();
}