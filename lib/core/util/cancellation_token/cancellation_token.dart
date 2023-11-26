import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token_source.dart';

class CancellationToken {
  CancellationToken({required this.source});

  CancellationTokenSource source;
  bool get isCancelled => source.isCancelled;

  @override
  int get hashCode => source.hashCode;

  @override
  bool operator ==(Object other) => other is CancellationToken && other.source == source;
}
