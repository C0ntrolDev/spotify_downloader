import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/converters/spotify_requests_converter.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/spotify_profile.dart';

class SpotifyProfileRepositoryImpl implements SpotifyProfileRepository {
  SpotifyProfileRepositoryImpl({required SpotifyProfileDataSource dataSource}) : _dataSource = dataSource;

  final SpotifyProfileDataSource _dataSource;
  final SpotifyRequestsConverter _requestsConverter = SpotifyRequestsConverter();

  @override
  Future<Result<Failure, SpotifyProfile>> getSpotifyProfile(SpotifyRepositoryRequest repositoryRequest) async {
    final userResult = await _dataSource.getSpotifyProfile(_requestsConverter.convert(repositoryRequest));
    if (userResult.isSuccessful) {
      return Result.isSuccessful(SpotifyProfile(
          name: userResult.result?.displayName ?? 'no name', pictureUrl: userResult.result?.images?.first.url ?? ''));
    }
    return Result.notSuccessful(userResult.failure);
  }
}
