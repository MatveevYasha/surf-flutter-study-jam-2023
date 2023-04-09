// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ru = {
  "ticket_storage": "Хранение билетов",
  "nothing_here": "Здесь пока ничего нет",
  "waiting_download": "Ожидает начала загрузки",
  "file_ploaded": "Файл загружен",
  "loading": "Идет загрузка...",
  "megabytes": "Мб",
  "enter_url": "Введите URL",
  "enter_correct_url": "Введите корректный URL",
  "add": "Добавить"
};
static const Map<String,dynamic> en = {
  "ticket_storage": "Ticket storage",
  "nothing_here": "There's nothing here yet",
  "waiting_download": "Waiting for the download to start",
  "file_ploaded": "File uploaded",
  "loading": "Loading...",
  "megabytes": "Mb",
  "enter_url": "Enter URL",
  "enter_correct_url": "Enter the correct URL",
  "add": "Add"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ru": ru, "en": en};
}
