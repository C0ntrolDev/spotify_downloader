<div align="center">
<img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/main/github_images/app_icon.png" width="100"/>
</div>
<h1 align="center">
Spotify Downloader
</h1>
<div align="center">
App that allows you to download your favorite playlists at the touch of just one button!
</div>

## Screenshots

<img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/main/github_images/main_screen.png" width="200" /> <img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/main/github_images/download_screen.png" width="200" /> <img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/main/github_images/change_source_screen.png" width="200" />

## About App

- 📱 🍎 Supported platforms: Android, IOS
- 🇺🇸 🇷🇺 Languages: English, Russian
- 🎥 Download audio from YouTube using SpotifyAPI

## Features 

- 📥 Download the entire playlist with one click
- ❤️ Download favorite tracks
- 🔄 Change the download source if you didn't like the automatic choice
- 🔔 Track downloads in notifications or on the main page
- 💤 Background download (Android only)

## How to download

### Android

You can download this apk if you don't know what kind of architecture you have.
- [spotify_downloader.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.1.2/spotify_downloader.apk)

If you know what architecture you have, then download one of the apk listed below.
- [spotify_downloader_armeabi-v7a.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.1.2/spotify_downloader_armeabi-v7a.apk)
- [spotify_downloader_arm64-v8a.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.1.2/spotify_downloader_arm64-v8a.apk)
- [spotify_downloader_x86_64.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.1.2/spotify_downloader_x86_64.apk)

### IOS

You can download ipa there.
- [spotify_downloader.ipa](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.1.2/spotify_downloader.ipa)

## How to use

After you have downloaded the app, you must grant it the permissions it will ask for.   
Then you can use the app. Just paste the link to the playlist and click the search button.

If you want to download your favorite tracks, and also download playlists "only for you", you must create Spotify Service App

## How create Spotify Service App and use it

1. Follow this link and login - https://developer.spotify.com/
2. Follow this link and create your own app - https://developer.spotify.com/dashboard/create  
   - __App name__ - whatever you want
   - __App description__ - whatever you want
   - __Website__ - unessentially
   - __Redirect URI__ - com.cdev.spotifydownloader://callback
3. Go to the application settings and copy the __clientId__ and __clientSecret__
4. Open the settings in Spotify Downloader and paste the __clientId__ and __clientSecret__ into the fields specified for them (first delete the default values)
5. Click on the log in button

__After logging in, you can download your favorite tracks, as well as playlists "only for you"__



## Additional information
- ⭐ I would appreciate it if you **star this repository!**

## For developers
1. Developed on Flutter
2. When developing the application, I used a "Clean Architecture". I don't think this application is an ideal representative of this approach. But if you want, you can use it as an example project.

### Version 2.0

If you're interested in contributing to this project, there are some key tasks I'd like to get done:

- [ ] Implement logging (probably using [talker](https://github.com/Frezyx/talker))
- [ ] Implement caching for the most recently loaded pages
- [ ] Remake the system for getting tracks from SpotifyAPI (make it so that the collection is fetched in parts, prioritizing loading parts that are visible)
- [ ] Implement various sources of tracks/audio
- [ ] Implement tracks mp3s creation time ordering (for ordered view in mp3 players (like in Spotify)). For example first track in playlist created at 00:01, second track in playlist created at 00:02
- [ ] Improve perfomance in big playlists, when downloading all
- [ ] Use drift instead of sqflite

<h3 align="center">
^_^
</h3>
