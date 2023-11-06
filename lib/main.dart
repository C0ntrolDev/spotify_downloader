import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/models/db/local/local_playlist.dart';
import 'package:spotify_downloader/models/db/local/local_track.dart';
import 'package:spotify_downloader/repositories/spotify_api_repository.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_data_service.dart';
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
  GetIt.I.registerSingletonAsync<SpotifyLocalDataService>(() => SpotifyLocalDataService.create());

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
  String? url;
  List<LocalPlaylist>? localPlaylists;
  List<LocalTrack>? localTracks;
  SpotifyApiRepository? spotifyApiRepository;
  SpotifyLocalDataService? spotifyLocalDataService;
  List<TrackSaved> tracks = List<TrackSaved>.empty(growable: true);
  SpotifyApiCredentials? credentials;

  _MyHomePageState() {
    Future(() async {
      spotifyApiRepository = await GetIt.I.getAsync<SpotifyApiRepository>();
      spotifyLocalDataService = await GetIt.I.getAsync<SpotifyLocalDataService>();
      localPlaylists = await spotifyLocalDataService?.getPlaylistsHistory();
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(spotifyApiRepository?.isAccountAutorized.toString() ?? 'NotLoaded'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: TextField( 
                  onChanged: (value) => url = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: ElevatedButton(onPressed: () async {
                  final playlist = await spotifyApiRepository?.getPlaylistByUrl(url!);
                  await spotifyLocalDataService?.addPlaylistToHistory(await LocalPlaylist.createUsingUrl(spotifyId: playlist!.id!, name: playlist!.name!,imageUrl: playlist.images?[0].url ?? '', openDate: DateTime.now()));
                  localPlaylists = await spotifyLocalDataService?.getPlaylistsHistory();
                  setState(() {});
                }, child: Text('загрузить плейлист в бд')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: ElevatedButton(onPressed: () async {
                  spotifyLocalDataService?.deleteDb();
                  setState(() {});
                }, child: Text('удалить бд')),
              ),
              Container(
                padding: EdgeInsets.only(top: 400),
                height: 300,
                child: ListView.builder(
                  semanticChildCount: localPlaylists?.length,
                  itemBuilder: (context, index) => InkWell(
                    splashFactory: InkRipple.splashFactory,
                    child: Row(
                      children: [
                        image.Image.memory(localPlaylists![index].image!),
                        Text(localPlaylists![index].name),
                      ],
                    ),
                    onTap: () async {
                      localTracks =
                          await spotifyLocalDataService?.getTracksByPlaylistId(localPlaylists![index].spotifyId);
                      setState(() {});
                    },
                  ),
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  semanticChildCount: localTracks?.length,
                  itemBuilder:(context, index) =>  Row(children: [
                  Text(localTracks![index].spotifyId),
                ]
                ),),
              )
            ],
          ),
        ));
  }
  }
