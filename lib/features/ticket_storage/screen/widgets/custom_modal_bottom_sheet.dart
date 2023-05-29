import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/ticket_bloc.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';

final _formKey = GlobalKey<FormState>();

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    super.key,
    required this.size,
    required this.colors,
    required this.textFieldController,
  });

  final Size size;
  final ColorScheme colors;
  final TextEditingController textFieldController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
          _TextField(textFieldController: textFieldController),
          // Кнопка "Добавить" внутри модалки
          _Button(textFieldController: textFieldController),
          SizedBox(height: size.height * 0.015)
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    super.key,
    required this.textFieldController,
  });

  final TextEditingController textFieldController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            // Проверка пустого значения
            if (value == null || value.isEmpty) {
              return LocaleKeys.enter_url.tr();
            }
            // Проверка чтобы было разрешение файла PDF
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    super.key,
    required this.textFieldController,
  });

  final TextEditingController textFieldController;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        // Если валидация прошла
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 750),
              content: Text(LocaleKeys.magazine_added_successfully.tr()),
            ),
          );
          context
              .read<TicketBloc>()
              .add(AddTicketEvent(url: textFieldController.text));
          textFieldController.clear();
          Navigator.of(context).pop();
        }
      },
      child: Text(LocaleKeys.add.tr()),
    );
  }
}
