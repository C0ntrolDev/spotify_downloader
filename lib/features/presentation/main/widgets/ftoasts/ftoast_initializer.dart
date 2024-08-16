import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/ftoasts/ftoast_acessor.dart';

class FtoastInitializer extends StatelessWidget {
  const FtoastInitializer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(initialEntries: <OverlayEntry>[
      OverlayEntry(
        builder: (BuildContext context) {
          final ftoast = FToast().init(context);
          return FtoastAccessor(fToast: ftoast, child: child);
        },
      ),
    ]);
  }
}
