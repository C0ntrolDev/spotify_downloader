<div align="center">
<img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/dev-1.1/github_images/app_icon.png" width="100"/>
</div>
<h1 id="header" align="center">
Spotify Downloader
</h1>
<div id="header" align="center">
App that allows you to download your favorite playlists at the touch of just one button!
</div>

## Screenshots

<img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/dev-1.1/github_images/main_screen.png" width="200" /> <img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/dev-1.1/github_images/download_screen.png" width="200" /> <img src="https://raw.githubusercontent.com/C0ntrolDev/spotify_downloader/dev-1.1/github_images/change_source_screen.png" width="200" />

## About App

## How to download

You can download this apk if you don't know what kind of architecture you have.
- [spotify_downloader.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.0.3/spotify_downloader.apk)

If you know what architecture you have, then download one of the apk listed below.
- [spotify_downloader_armeabi-v7a.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.0.3/spotify_downloader_armeabi-v7a.apk)
- [spotify_downloader_arm64-v8a.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.0.3/spotify_downloader_arm64-v8a.apk)
- [spotify_downloader_x86_64.apk](https://github.com/C0ntrolDev/spotify_downloader/releases/download/v1.0.3/spotify_downloader_x86_64.apk)

## How to use

After you have downloaded the application, you must grant it the permissions it will ask for.   
Then you can use the app. Just paste the link to the playlist and click the search button.

But in this case, your favorite tracks will not be available for download, as well as playlists that are created "only for you" may not match those that you expect

## How to download liked tracks

To do this, you will need to create your own spotify app.
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

## About app
- Supported platforms: Android, IOS
- Background download: supported

## For developers
1. Developed on Flutter
2. When developing the application, I used a "Clean Architecture". I don't think this application is an ideal representative of this approach. But if you want, you can use it as an example project.
