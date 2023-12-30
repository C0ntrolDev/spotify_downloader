import 'package:equatable/equatable.dart';

class SpotifyProfile extends Equatable {
  const SpotifyProfile({required this.name, required this.pictureUrl});

  final String name;
  final String pictureUrl;

  @override
  List<Object?> get props => [name, pictureUrl];
}


