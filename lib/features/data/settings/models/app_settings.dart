class AppSettings {
  AppSettings({required this.savePath, required this.saveMode});

  final String savePath;
  final int saveMode;

  static AppSettings deffault = AppSettings(
    savePath: '/storage/emulated/0/Download/', 
    saveMode: 0);
}
