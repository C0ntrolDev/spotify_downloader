import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';

class HistoryTracksCollection extends Equatable {
  const HistoryTracksCollection({
    required this.spotifyId,
    required this.type,
    required this.name,
    this.openDate,
    this.image,
  });

  final String spotifyId;
  final TracksCollectionType type;
  final DateTime? openDate;
  final String name;
  final Uint8List? image;

  @override
  List<Object?> get props => [spotifyId, name, type, image, openDate];
}