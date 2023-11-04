import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';
import 'package:spotify_downloader/services/spotify_api_data_service/spotify_api_data_service.dart';
import 'package:spotify_downloader/services/spotify_autorization_service/spotify_autorization_service.dart';
import 'package:flutter/src/widgets/image.dart' as image;

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
  List<Track> tracks = List<Track>.empty(growable: true);
  SpotifyApiCredentials? credentials;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 100),
              child: ElevatedButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(200, 50))),
                onPressed: () async {
                    final playlist = await _spotifyApiDataService.getPlaylistByUrl('https://open.spotify.com/playlist/4uoPRLaoEtvHXuouIM387?si=6f3c6d3786e54c0e');
                    _spotifyApiDataService.getTrackCollectionByPlaylist(playlist: playlist!, saveCollection: tracks, updateCallback: () {setState(() {});});
                  },
                child: Text(
                  "Загрузить плейлист",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: 400,
              child: ListView.separated(
                itemCount: tracks.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.only(left: 3),
                  child: Row(
                    children: [
                      Text((index + 1).toString() ),
                      Builder(
                        builder: (context) {
                          try {
                            final url = tracks[index].album?.images?[0].url;
                            return image.Image.network(
                            url ?? "", 
                            height: 30,
                            width: 30,
                            alignment: Alignment.centerLeft,);
                          } catch (e) {
                            return Text('N', style: TextStyle(color: Colors.red),);
                          }                      
                        }
                      ),
                      Text(tracks[index].name ?? "")
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => Container(height: 10),
              ),
            ),
          ],
        ),
      )
    );
  }
}
