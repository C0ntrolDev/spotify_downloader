import 'package:flutter/widgets.dart';

class LoadingTracksCollectionTile extends StatefulWidget {
  const LoadingTracksCollectionTile({
    super.key, 
    this.onLoaded});

  final void Function()? onLoaded;

  @override
  State<LoadingTracksCollectionTile> createState() => _LoadingTracksCollectionTileState();
}

class _LoadingTracksCollectionTileState extends State<LoadingTracksCollectionTile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

