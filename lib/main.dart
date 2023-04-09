import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/screen/ticket_storage_page.dart';
import 'package:surf_flutter_study_jam_2023/generated/codegen_loader.g.dart';

void main() async {
  // Асинхронное выполнение из за локализации
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
    return MaterialApp(
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
    );
  }
}
