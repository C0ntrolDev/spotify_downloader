import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/presentation/permissions_dialog/widgets/permission_tile.dart';

showPermissonsDialog(BuildContext context, FutureOr<bool> Function() onRequestButtonClicked) {
  final theme = Theme.of(context);
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: surfaceColor,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Предоставьте разрешения',
            style: theme.textTheme.titleMedium,
            maxLines: 2,
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 16),
          children: [
            const PermissionTile(
              icon: Icons.folder,
              text: 'Для сохранения музыки в любое место на вашем телефоне, приложению нужно разрешение на работу с хранилищем',
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: PermissionTile(
                icon: Icons.notifications,
                text: 'Для уведомления вас о загрузки, приложению нужен доступ к отправке уведомлений',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final isPermissionsGranted = await onRequestButtonClicked.call();
                        if (isPermissionsGranted && context.mounted) {
                          AutoRouter.of(context).pop();
                        }
                      },
                      child: Text(
                        'Предоставить доступ',
                        style: theme.textTheme.bodySmall?.copyWith(color: onPrimaryColor),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: errorPrimaryColor),
                      onPressed: () {
                        AutoRouter.of(context).pop();
                      },
                      child: Text(
                        'Отказать',
                        style: theme.textTheme.bodySmall?.copyWith(color: onPrimaryColor),
                      ))
                ],
              ),
            ),
          ],
        );
      });
}
