import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/repositories/spotify_api_repository.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';
import 'package:spotify_downloader/services/spotify_api_data_service/spotify_api_data_service.dart';
import 'package:spotify_downloader/services/spotify_autorization_service/spotify_autorization_service.dart';
import 'package:flutter/src/widgets/image.dart' as image;

void main() {
  const clientId = '6bbc592f2e4f4030b827563640609dbc';
  const clientSecret = '3b1a82e64eb44bcda2a80afc879ed6a8';

  GetIt.I.registerSingleton<SpotifyAutorizationService>(
      SpotifyAutorizationService(clientId: clientId, clientSecret: clientSecret));
  GetIt.I.registerSingleton<SpotifyLocalCredentialsService>(SpotifyLocalCredentialsService());
  GetIt.I.registerSingleton<SpotifyApiDataService>(SpotifyApiDataService(
      clientId: clientId,
      clientSecret: clientSecret,
      spotifyLocalCredentialsService: GetIt.I<SpotifyLocalCredentialsService>()));
  GetIt.I.registerSingletonAsync<SpotifyApiRepository>(() => SpotifyApiRepository.create(
      spotifyAutorizationService: GetIt.I<SpotifyAutorizationService>(),
      spotifyApiDataService: GetIt.I<SpotifyApiDataService>(),
      spotifyLocalCredentialsService: GetIt.I<SpotifyLocalCredentialsService>()));

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
  SpotifyApiRepository? spotifyApiRepository;
  List<TrackSaved> tracks = List<TrackSaved>.empty(growable: true);
  SpotifyApiCredentials? credentials;

  _MyHomePageState() {
    Future(() async {
      spotifyApiRepository = await GetIt.I.getAsync<SpotifyApiRepository>();
      setState(() {});
    });
    
  }
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
              Text(spotifyApiRepository?.isAccountAutorized.toString() ?? 'NotLoaded'),
              Container(
                padding: EdgeInsets.only(top: 100),
                child: ElevatedButton(
                  style: ButtonStyle(fixedSize: MaterialStateProperty.all(Size(200, 50))),
                  onPressed: () async {
                    await spotifyApiRepository?.tryAutorizeAccount();
                  },
                  child: Text(
                    "Авторизоваться",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 100),
                child: ElevatedButton(
                  style: ButtonStyle(fixedSize: MaterialStateProperty.all(Size(200, 50))),
                  onPressed: () async {
                    spotifyApiRepository?.getLikedTracks(
                        saveCollection: tracks,
                        updateCallback: () {
                          setState(() {});
                        });
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
                        Text((index + 1).toString()),
                        Builder(builder: (context) {
                          try {
                            final url = tracks[index].track?.album?.images?[0].url;
                            return image.Image.network(
                              url ?? "",
                              height: 30,
                              width: 30,
                              alignment: Alignment.centerLeft,
                            );
                          } catch (e) {
                            return Text(
                              'N',
                              style: TextStyle(color: Colors.red),
                            );
                          }
                        }),
                        Text(tracks[index].track?.name ?? "")
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) => Container(height: 10),
                ),
              ),
            ],
          ),
        ));
  }
}
