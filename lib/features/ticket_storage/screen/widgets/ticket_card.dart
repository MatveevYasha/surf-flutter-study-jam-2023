import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';

// ignore: must_be_immutable
class TicketCard extends StatelessWidget {
  final int index;
  void Function()? centerTab;
  void Function()? endTab;

  TicketCard({
    Key? key,
    required this.index,
    this.centerTab,
    this.endTab,
    required this.splited,
    required this.colors,
    required this.currentFileSize,
    required this.fileSize,
  }) : super(key: key);

  final List<String> splited;
  final ColorScheme colors;
  final List<double> currentFileSize;
  final List<int> fileSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: centerTab,
      leading: const Icon(Icons.airplane_ticket_outlined),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            splited.last,
            style: TextStyle(color: colors.primary),
          ),
          LinearProgressIndicator(
            value: (currentFileSize[index] == 0)
                ? 0
                : (currentFileSize[index] / fileSize[index]),
          ),
          Text((currentFileSize[index] == 0)
              // Ожидание загрузки
              ? LocaleKeys.waiting_download.tr()
              : (currentFileSize[index] == fileSize[index])
                  // Загрузка завершена
                  ? LocaleKeys.file_ploaded.tr()
                  // Файл загружается
                  : '${LocaleKeys.loading.tr()} ${(currentFileSize[index] / (1024 * 1024)).toStringAsFixed(2)} ${LocaleKeys.from.tr()} ${(fileSize[index] / (1024 * 1024)).toStringAsFixed(2)} Mb'),
        ],
      ),
      trailing: IconButton(
        color: colors.primary,
        icon: (currentFileSize[index] == 0)
            // Ожидание загрузки
            ? const Icon(Icons.cloud_download_outlined)
            : (currentFileSize[index] == fileSize[index])
                // Загрузка завершена
                ? const Icon(Icons.cloud_download_rounded)
                // Файл загружается
                : const Icon(Icons.pause_circle_outline_outlined),
        onPressed: endTab,
      ),
    );
  }
}
