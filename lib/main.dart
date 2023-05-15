import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/ticket_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/data/boxes/boxes.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/data/models/ticket.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/ticket_storage_page.dart';
import 'package:surf_flutter_study_jam_2023/generated/codegen_loader.g.dart';

void main() async {
  // Асинхронное выполнение из за локализации и Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TicketAdapter());
  ticketBox = await Hive.openBox<Ticket>('ticketBox');
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        assetLoader: const CodegenLoader(),
        supportedLocales: const [Locale('en'), Locale('ru')],
        path: 'assets/translations', // Путь к папке с переводом
        fallbackLocale: const Locale('ru'),
        child: const MyApp()),
  );
}

final dio = Dio();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketBloc(),
      child: MaterialApp(
        title: 'Surf Flutter Study Jam 2023',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const TicketStoragePage(),
      ),
    );
  }
}
