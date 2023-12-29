  import 'dart:ui';

import 'package:spotify_downloader/core/app/colors/colors.dart';

Color getIntermediateColor(Color color1, Color color2, double ratio) {
    return Color.fromARGB(
        (color1.alpha - (color1.alpha - backgroundColor.alpha) * ratio).round(),
        (color1.red - (color1.red - color2.red) * ratio).round(),
        (color1.green - (color1.green - color2.green) * ratio).round(),
        (color1.blue - (color1.blue - backgroundColor.blue) * ratio).round());
}