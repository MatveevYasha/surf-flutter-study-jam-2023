import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.colors,
  });

  final ColorScheme colors;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      actions: [
        IconButton(
          color: colors.primary,
          icon: const Icon(
            Icons.language,
          ),
          onPressed: () {
            // Для генерации перевода необходимо выполнить команды из файла Readme
            if (context.locale == const Locale('ru')) {
              context.setLocale(const Locale('en'));
            } else {
              context.setLocale(const Locale('ru'));
            }
          },
        ),
      ],
      backgroundColor: colors.background,
      title: Text(
        LocaleKeys.ticket_storage.tr(),
      ),
    );
  }
}
