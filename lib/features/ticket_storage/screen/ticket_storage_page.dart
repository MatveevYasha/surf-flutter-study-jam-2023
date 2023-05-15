import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/ticket_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_app_bar.dart';
// import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/widgets/custom_floating_action_button.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

final _formKey = GlobalKey<FormState>();

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
    if (clipboardData!.text!.contains('.pdf')) {
      textFieldController.text = clipboardData.text!;
    }
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
                                      : (currentFileSize[index] /
                                          fileSize[index]),
                                ),
                                Text((currentFileSize[index] == 0)
                                    ? 'Ожидает загрузки'
                                    : (currentFileSize[index] ==
                                            fileSize[index])
                                        ? 'Файл загружен'
                                        : 'Загружается ${(currentFileSize[index] / (1024 * 1024)).toStringAsFixed(2)} из ${(fileSize[index] / (1024 * 1024)).toStringAsFixed(2)} Mb'),
                              ],
                            ),
                            // сделать здесь переключение из нового дарт 3
                            trailing: IconButton(
                              color: colors.primary,
                              icon: (currentFileSize[index] == 0)
                                  ? const Icon(Icons.cloud_download_outlined)
                                  : (currentFileSize[index] == fileSize[index])
                                      ? const Icon(Icons.cloud_download_rounded)
                                      : const Icon(
                                          Icons.pause_circle_outline_outlined),
                              onPressed: () {
                                context.read<TicketBloc>().add(
                                    LoadingTicketEvent(
                                        url: nameTickets[index], index: index));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          // Кнопка и модалка вместе в отдельном файле
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

  Future<void> showBottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colors = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          height: size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: size.height * 0.005,
                width: size.width * 0.1,
                decoration: BoxDecoration(
                  color: colors.secondary,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    // initialValue: 'fsdf',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.contains('.pdf') == false) {
                        return LocaleKeys.enter_correct_url.tr();
                      }
                      return null;
                    },
                    controller: textFieldController,
                    keyboardType: TextInputType.url,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.enter_url.tr(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Журнал успешно добавлен')),
                    );
                    context
                        .read<TicketBloc>()
                        .add(AddTicketEvent(url: textFieldController.text));
                    textFieldController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text(LocaleKeys.add.tr()),
              ),
              SizedBox(height: size.height * 0.015)
            ],
          ),
        );
      },
    );
  }
}
