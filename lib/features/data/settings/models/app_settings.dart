class AppSettings {
  AppSettings({required this.savePath, required this.language, required this.saveMode});

  final String savePath;
  final int saveMode;
  final String language;

  static AppSettings deffault = AppSettings(
    savePath: '/storage/emulated/0/Download/', 
    saveMode: 0,
    language: 'en');
}
