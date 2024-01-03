import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class PermissionTile extends StatelessWidget {
  const PermissionTile({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 30, color: onSurfaceSecondaryColor),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            text,
            maxLines: 5,
            style: theme.textTheme.labelMedium?.copyWith(color: onSurfacePrimaryColor),
          ),
        ))
      ],
    );
  }
}
