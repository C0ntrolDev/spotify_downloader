import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/search_text_field.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class DownloadTracksCollectionManageBar extends StatelessWidget {
  const DownloadTracksCollectionManageBar({
    super.key,
    required this.onFilterQueryChanged,
    required this.onDownloadAllButtonClicked,
  });

  final void Function(String newQuery) onFilterQueryChanged;
  final void Function() onDownloadAllButtonClicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.only(top: 30),
      sliver: SliverToBoxAdapter(
          child: Row(
        children: [
          Expanded(
            child: SearchTextField(
              theme: theme,
              onChanged: onFilterQueryChanged,
              height: 35,
              cornerRadius: 5,
              hintText: S.of(context).searchByName,
              textStyle: theme.textTheme.bodySmall?.copyWith(color: onPrimaryColor),
              hintStyle: theme.textTheme.bodySmall?.copyWith(color: searchFieldHintColor, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: ElevatedButton(
              onPressed: () => onDownloadAllButtonClicked,
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
              child: Text(S.of(context).downloadAll,
                  style: theme.textTheme.bodySmall!.copyWith(color: onPrimaryColor, fontWeight: FontWeight.w700)),
            ),
          )
        ],
      )),
    );
  }
}
