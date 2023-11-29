class AudioLoadingResult {
  const AudioLoadingResult.isCancelled() : isCancelled = true , savePath = null;
  const AudioLoadingResult.isLoaded(this.savePath) : isCancelled = false;

  final bool isCancelled;
  final String? savePath;
}