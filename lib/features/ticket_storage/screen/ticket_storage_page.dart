// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/ticket_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/pdf_detail_screen/pdf_screen.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_app_bar.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_modal_bottom_sheet.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/ticket_card.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';

/// Экран “Хранения билетов”.
class TicketStoragePage extends StatefulWidget {
  const TicketStoragePage({Key? key}) : super(key: key);

  @override
  State<TicketStoragePage> createState() => _TicketStoragePageState();
}

// Файл pdf для примера
// https://journal-free.ru/download/dachnye-sekrety-11-noiabr-2019.pdf

class _TicketStoragePageState extends State<TicketStoragePage> {
  List<String> nameTickets = [];
  List<double> currentFileSize = [];
  List<String> localFile = [];
  List<int> fileSize = [];
  final textFieldController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void dispose() {
    textFieldController.dispose();
    scrollController.dispose();
    super.dispose();
  }

// Получение значения из буфера обмена
  Future<void> _getTextBuffer() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text == null) {
      textFieldController.text = '';
    } else {
      if (clipboardData!.text!.contains('.pdf')) {
        textFieldController.text = clipboardData.text!;
      }
    }
  }

// Загрузка файла PDF
  Future<File> createFileOfPdfUrl(String url) async {
    Completer<File> completer = Completer();
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return BlocConsumer<TicketBloc, TicketState>(
      listener: (context, state) {
        if (state is LoadingTicketState) {
          currentFileSize[state.index] = state.currentFileSize;
          fileSize[state.index] = state.fileSize;
        }
      },
      builder: (context, state) {
        if (state is AddedTicketState) {
          nameTickets.add(state.url);
          currentFileSize.add(0);
          fileSize.add(0);
          localFile.add('');
        }
        if (state is DeleteTicketState) {
          nameTickets.removeAt(state.index);
          currentFileSize.removeAt(state.index);
          fileSize.removeAt(state.index);
        }
        return Scaffold(
          // Апп бар в отдельном виджете
          appBar: CustomAppBar(colors: colors),
          body: (nameTickets.isEmpty)
              // Состояние, когда ни загружен ни один журнал
              ? Center(
                  child: Text(
                    LocaleKeys.nothing_here.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              // Состояние, когда загружен хотя бы один журнал
              : Scrollbar(
                  controller: scrollController,
                  trackVisibility: true,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: nameTickets.length,
                    itemBuilder: (context, index) {
                      List<String> splited;
                      splited = nameTickets[index].split('/');
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        // Удаление тикета
                        child: Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            context
                                .read<TicketBloc>()
                                .add(DeleteTicketEvent(index: index));
                          },
                          background: Container(
                            padding: const EdgeInsets.only(right: 10),
                            color: colors.error.withRed(220),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete_sweep_outlined,
                                size: 32,
                                color: colors.onPrimary,
                              ),
                            ),
                          ),
                          // Карточка журнала
                          child: TicketCard(
                            // Если нажать на описание журанала
                            centerTab: () {
                              if (localFile[index] == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(LocaleKeys.need_to_download.tr()),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PDFScreen(
                                            path: localFile[index],
                                          )),
                                );
                              }
                            },
                            // Если нажать на загрузку
                            endTab: () {
                              createFileOfPdfUrl(nameTickets[index]).then((f) {
                                setState(() {
                                  localFile[index] = f.path;
                                });
                              });
                              context.read<TicketBloc>().add(LoadingTicketEvent(
                                  url: nameTickets[index], index: index));
                            },
                            splited: splited,
                            colors: colors,
                            currentFileSize: currentFileSize,
                            fileSize: fileSize,
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _getTextBuffer();
              showBottomSheet(context);
            },
            label: Text(
              LocaleKeys.add.tr(),
            ),
            backgroundColor: colors.inversePrimary,
          ),
        );
      },
    );
  }

// Модалка
  Future<void> showBottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colors = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return CustomModalBottomSheet(
            size: size,
            colors: colors,
            textFieldController: textFieldController);
      },
    );
  }
}
