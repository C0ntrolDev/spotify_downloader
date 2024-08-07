import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/save_mode.dart';

class DownloadTracksSettings extends Equatable {
  const DownloadTracksSettings({required this.savePath, required this.saveMode});

  final String savePath;
  final SaveMode saveMode;

  @override
  List<Object?> get props => [savePath, saveMode];
}
