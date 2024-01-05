import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/shared/converters/spotify_requests_converter.dart';
import 'package:spotify_downloader/features/data/spotify_profile/data_source/spotify_profile_data_source.dart';
import 'package:spotify_downloader/features/domain/shared/spotify_repository_request.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/entities/spotify_profile.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/repository/spotify_profile_repostitory.dart';

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
