import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

Color getIntermediateColor(Color color1, Color color2, double ratio) {
  return Color.fromARGB(
      (color1.alpha - (color1.alpha - backgroundColor.alpha) * ratio).round(),
      (color1.red - (color1.red - color2.red) * ratio).round(),
      (color1.green - (color1.green - color2.green) * ratio).round(),
      (color1.blue - (color1.blue - backgroundColor.blue) * ratio).round());
}

Future<Result<Failure, T>> handleSpotifyClientExceptions<T>(Future<Result<Failure, T>> Function() function) async {
  try {
    final result = await function.call();
    return result;
  } on SpotifyException catch (e) {
    if (e.status == 404) {
      return Result.notSuccessful(NotFoundFailure(message: e));
    }

    if (e.status == 401) {
      return Result.notSuccessful(NotAuthorizedFailure(message: e));
    }

    if (e.status == 403) {
      return Result.notSuccessful(NotAuthorizedFailure(message: e));
    }

    return Result.notSuccessful(Failure(message: e));
  } on ClientException catch (e) {
    return Result.notSuccessful(NetworkFailure(message: e));
  } on AuthorizationException catch (e) {
    return Result.notSuccessful(InvalidClientCredentialsFailure(message: e));
  } on SocketException catch (e) {
    return Result.notSuccessful(NetworkFailure(message: e));
  } catch (e) {
    return Result.notSuccessful(Failure(message: e));
  }
}
