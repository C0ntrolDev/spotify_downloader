import 'package:equatable/equatable.dart';

class TrackId extends Equatable {
  const TrackId({required this.spotifyId});

  final String spotifyId;

  @override
  List<Object> get props => [spotifyId];
}
