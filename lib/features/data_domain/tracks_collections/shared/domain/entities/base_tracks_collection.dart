import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';

class BaseTracksCollection extends Equatable {
  const BaseTracksCollection({required this.id, required this.name, this.imageUrl});

  final TracksCollectionId id;
  final String name;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, imageUrl];
}
