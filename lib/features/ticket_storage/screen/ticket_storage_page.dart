import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/ticket_bloc.dart';
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

// https://journal-free.ru/download/dachnye-sekrety-11-noiabr-2019.pdf
// https://journal-free.ru/download/za-rulem-12-dekabr-2019-rossiia.pdf

class _TicketStoragePageState extends State<TicketStoragePage> {
  List<String> nameTickets = [];
  int currentFileSize = 0;
  int fileSize = 0;
  final textFieldController = TextEditingController();
  List<int> totalWeight = [];
  final StreamController<int> streamController = StreamController<int>();

  // @override
  // void initState() {
  //   streamController.add(1);
  //   super.initState();
  // }

  @override
  void dispose() {
    textFieldController.dispose();
    streamController.close();
    super.dispose();
  }

// Метод для получения журнала // определить переменные currentFileSize и 2ю тут а вверху поставить лейт
//   Future<void> _getPdf(String url) async {
//     final response = await dio.get(
//       url,
//       onReceiveProgress: (count, total) {
//         int percentage = ((count / total) * 100).floor();
//         streamController.sink.add(count);
//         print(count);
//         setState(() {
//           currentFileSize = count;
//           fileSize = total.toDouble();
//         });
// //         setState(() {
// // // Здесь логика работы прогресс бара, которую надо бы поменять
// //           fileSize = total / 1024;
// //           // totalWeight.add(total);
// //           currentFileSize = percentage;
// //         });
//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var size = MediaQuery.of(context).size;
    return BlocConsumer<TicketBloc, TicketState>(
      listener: (context, state) {
        if (state is LoadingTicketState) {
          print(state.currentFileSize);
          setState(() {
            fileSize = state.fileSize;
            currentFileSize = state.currentFileSize;
          });
        }
      },
      builder: (context, state) {
        if (state is AddedTicketState) {
          nameTickets.add(state.url);
        }
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
                            // Stack(
                            //   children: [
                            //     Container(
                            //       height: size.height * 0.003,
                            //       color: colors.inversePrimary,
                            //       width: size.width * 0.55,
                            //     ),
                            //     Container(
                            //       height: size.height * 0.003,
                            //       color: colors.primary,
                            //       width: size.width *
                            //           0.55 *
                            //           (currentFileSize.toDouble() / fileSize),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   children: [
                            //     StreamBuilder<int>(
                            //         initialData: 0,
                            //         stream: streamController.stream,
                            //         builder: (context, snapshot) {
                            //           if (currentFileSize == 0) {
                            //             return Text('Ожидает начала загрузки');
                            //           }
                            //           if (currentFileSize == fileSize) {
                            //             return Text('Файл загужен');
                            //           } else {
                            //             return Text(
                            //                 'Загружается ${(currentFileSize / (1024 * 1024)).toStringAsFixed(2)} из ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} Mb');
                            //           }
                            //         }),
                            //   ],
                            // ),
                            Text(
                                'Загружается ${(currentFileSize / (1024 * 1024)).toStringAsFixed(2)} из ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} Mb'),

                            // Text(
                            //   (currentFileSize == 0)
                            //       ? LocaleKeys.waiting_download.tr()
                            //       : (currentFileSize == 100)
                            //           ? LocaleKeys.file_ploaded.tr()
                            //           : '${LocaleKeys.loading.tr()} ${double.parse((totalWeight[index] / (1024 * 1024)).toStringAsFixed(1))} ${LocaleKeys.megabytes.tr()}',
                            //   style: TextStyle(color: colors.secondary),
                            // ),
                          ],
                        ),
                        trailing: IconButton(
                          color: colors.primary,
                          icon: (currentFileSize == 0)
                              ? const Icon(Icons.cloud_download_outlined)
                              : (currentFileSize == fileSize)
                                  ? const Icon(Icons.cloud_download_rounded)
                                  : const Icon(
                                      Icons.pause_circle_outline_outlined),
                          onPressed: () {
                            setState(() {
                              // _getPdf(nameTickets[index]);
                              context.read<TicketBloc>().add(LoadingTicketEvent(
                                  url: nameTickets[index], index: index));
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
      },
    );
  }
}
