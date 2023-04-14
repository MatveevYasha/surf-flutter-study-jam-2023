import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_app_bar.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_floating_action_button.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';
import 'package:surf_flutter_study_jam_2023/main.dart';

/// Экран “Хранения билетов”.
class TicketStoragePage extends StatefulWidget {
  const TicketStoragePage({Key? key}) : super(key: key);

  @override
  State<TicketStoragePage> createState() => _TicketStoragePageState();
}

class _TicketStoragePageState extends State<TicketStoragePage> {
  List<String> nameTickets = [];
  int currentFileSize = 0;
  double fileSize = 0;
  final textFieldController = TextEditingController();
  List<int> totalWeight = [];

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

// Метод для получения журнала
  Future<void> _getPdf(String url) async {
    final response = await dio.get(
      url,
      onReceiveProgress: (count, total) {
        int percentage = ((count / total) * 100).floor();
        setState(() {
// Здесь логика работы прогресс бара, которую надо бы поменять
          fileSize = total / 1024;
          totalWeight.add(total);
          currentFileSize = percentage;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // Апп бар в отдельном виджете
      appBar: CustomAppBar(colors: colors),
      body: (nameTickets.isEmpty)
          ? Center(
              child: Text(
                LocaleKeys.nothing_here.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          // Состояние, когда загружен хотя бы один журнал
          : ListView.builder(
              itemCount: nameTickets.length,
              itemBuilder: (context, index) {
                List<String> splited;
                splited = nameTickets[index].split('/');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.airplane_ticket_outlined),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          splited.last,
                          style: TextStyle(color: colors.primary),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: size.height * 0.003,
                              color: colors.inversePrimary,
                              width: size.width * 0.55,
                            ),
                            Container(
                              height: size.height * 0.003,
                              color: colors.primary,
                              width: size.width *
                                  0.55 *
                                  (currentFileSize.toDouble() / 100),
                            ),
                          ],
                        ),
                        Text(
                          (currentFileSize == 0)
                              ? LocaleKeys.waiting_download.tr()
                              : (currentFileSize == 100)
                                  ? LocaleKeys.file_ploaded.tr()
                                  : '${LocaleKeys.loading.tr()} ${double.parse((totalWeight[index] / (1024 * 1024)).toStringAsFixed(1))} ${LocaleKeys.megabytes.tr()}',
                          style: TextStyle(color: colors.secondary),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      color: colors.primary,
                      icon: (currentFileSize == 0)
                          ? const Icon(Icons.cloud_download_outlined)
                          : (currentFileSize == 100)
                              ? const Icon(Icons.cloud_download_rounded)
                              : const Icon(Icons.pause_circle_outline_outlined),
                      onPressed: () {
                        setState(() {
                          _getPdf(nameTickets[index]);
                        });
                      },
                    ),
                  ),
                );
              },
            ),

      // Кнопка и модалка вместе в отдельном файле
      floatingActionButton: CustomFloatingActionButton(
        size: size,
        colors: colors,
        textFieldController: textFieldController,
        nameTickets: nameTickets,
      ),
    );
  }
}
