import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/ticket_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_app_bar.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_floating_action_button.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';

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
  List<double> currentFileSize = [];
  List<int> fileSize = [];
  final textFieldController = TextEditingController();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var size = MediaQuery.of(context).size;
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
                            LinearProgressIndicator(
                              value: (currentFileSize[index] == 0)
                                  ? 0
                                  : (currentFileSize[index] / fileSize[index]),
                            ),
                            Text((currentFileSize[index] == 0)
                                ? 'Ожидает загрузки'
                                : (currentFileSize[index] == fileSize[index])
                                    ? 'Файл загружен'
                                    : 'Загружается ${(currentFileSize[index] / (1024 * 1024)).toStringAsFixed(2)} из ${(fileSize[index] / (1024 * 1024)).toStringAsFixed(2)} Mb'),
                          ],
                        ),
                        trailing: IconButton(
                          color: colors.primary,
                          icon: (currentFileSize[index] == 0)
                              ? const Icon(Icons.cloud_download_outlined)
                              : (currentFileSize[index] == fileSize[index])
                                  ? const Icon(Icons.cloud_download_rounded)
                                  : const Icon(
                                      Icons.pause_circle_outline_outlined),
                          onPressed: () {
                            context.read<TicketBloc>().add(LoadingTicketEvent(
                                url: nameTickets[index], index: index));
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
