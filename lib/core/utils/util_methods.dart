import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/utils/utils.dart';

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
  } on SpotifyException catch (e, s) {
    if (e.status == 404) {
      return Result.notSuccessful(NotFoundFailure(message: e, stackTrace: s));
    }
    if (e.status == 401) {
      return Result.notSuccessful(NotAuthorizedFailure(message: e, stackTrace: s));
    }

    if (e.status == 403) {
      return Result.notSuccessful(ForbiddenFailure(message: e, stackTrace: s));
    }

    return Result.notSuccessful(Failure(message: e, stackTrace: s));
  } on ClientException catch (e, s) {
    return Result.notSuccessful(NetworkFailure(message: e, stackTrace: s));
  } on AuthorizationException catch (e, s) {
    return Result.notSuccessful(InvalidClientCredentialsFailure(message: e, stackTrace: s));
  } on SocketException catch (e, s) {
    return Result.notSuccessful(NetworkFailure(message: e, stackTrace: s));
  } catch (e, s) {
    return Result.notSuccessful(Failure(message: e, stackTrace: s));
  }
}

String? formatStringToFileFormat(String? string) {
  final forbiddenChars = ['/', '\\', ':', '*', '?', '<', '>', '|'];

  String? formattedString = string;
  for (var char in forbiddenChars) {
    formattedString = formattedString?.replaceAll(char, '');
  }

  return formattedString;
}

double normalize(double value, double min, double max) {
  if (min >= max) {
    throw ArgumentError('Min must be less than max');
  }

  return (value - min) / (max - min);
}

double closest(double value, double num1, double num2) {
  double diff1 = (value - num1).abs();
  double diff2 = (value - num2).abs();

  return (diff1 < diff2) ? num1 : num2;
}
