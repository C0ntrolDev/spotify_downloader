import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';
import 'package:spotify_downloader/services/spotify_api_data_service/spotify_api_data_service.dart';
import 'package:spotify_downloader/services/spotify_autorization_service/spotify_autorization_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 21, 255, 0)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title}) {}

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpotifyApiCredentials? credentials;
  String? debugText;

  _MyHomePageState() {
    _spotifyApiDataService = SpotifyApiDataService(
        clientId: '6bbc592f2e4f4030b827563640609dbc',
        clientSecret: '3b1a82e64eb44bcda2a80afc879ed6a8',
        spotifyLocalCredentialsService: _spotifyLocalCredentialsService);
  }

  final SpotifyAutorizationService _spotifyAutorizationService = SpotifyAutorizationService(
      clientId: '6bbc592f2e4f4030b827563640609dbc', clientSecret: '3b1a82e64eb44bcda2a80afc879ed6a8');
  final SpotifyLocalCredentialsService _spotifyLocalCredentialsService = SpotifyLocalCredentialsService();
  late final SpotifyApiDataService _spotifyApiDataService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('test'),
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () async => await _spotifyAutorizationService.authorizeAccount().then((value) {
                  credentials = value;
                  _spotifyApiDataService.spotifyCredentials = credentials;
                }),
            child: Text('Войти в spotify')),
        Text(credentials?.accessToken ?? 'нет данных'),
        ElevatedButton(
            onPressed: () async => await _spotifyLocalCredentialsService.saveSpotifyApiCredentials(credentials!),
            child: Text('сохранить данные')),
        ElevatedButton(
            onPressed: () async {
              credentials = await _spotifyLocalCredentialsService.loadSpotifyApiCredentials();
              _spotifyApiDataService.spotifyCredentials = credentials;
              setState(() {});
            },
            child: Text('загрузить')),
        ElevatedButton(
            onPressed: () async {
              debugText = (await _spotifyApiDataService.getPlaylistByUrl('https://open.spotify.com/playlist/37i9dQZF1E8KSuYNloCGgq?si=a59402ceee3a4c2f')).tracks.;
              setState(() {});
            },
            child: Text('Получить плейлист ???')),
        Text(debugText ?? '')
      ]),
    );
  }
}
