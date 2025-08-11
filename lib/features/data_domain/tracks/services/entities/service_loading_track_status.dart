import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/core/utils/utils.dart';

sealed class ServiceLoadingTrackStatus extends Equatable {
  const ServiceLoadingTrackStatus({this.youTubeUrl});

  final String? youTubeUrl;

  @override
  List<Object?> get props => [youTubeUrl];
}

final class ServiceLoadingTrackStatusNotLoaded extends ServiceLoadingTrackStatus {
  const ServiceLoadingTrackStatusNotLoaded({super.youTubeUrl});

  @override
  List<Object?> get props => [youTubeUrl];
}

final class ServiceLoadingTrackStatusLoading extends ServiceLoadingTrackStatus {
  const ServiceLoadingTrackStatusLoading({this.percent, super.youTubeUrl});

  final double? percent;

  @override
  List<Object?> get props => [youTubeUrl, percent];
}

final class ServiceLoadingTrackStatusLoaded extends ServiceLoadingTrackStatus {
  const ServiceLoadingTrackStatusLoaded({required this.savePath, required super.youTubeUrl});

  final String savePath;

  @override
  List<Object?> get props => [youTubeUrl, savePath];
}

final class ServiceLoadingTrackStatusFailure extends ServiceLoadingTrackStatus {
  const ServiceLoadingTrackStatusFailure({this.failure, super.youTubeUrl});

  final Failure? failure;

  @override
  List<Object?> get props => [youTubeUrl, failure];
}
