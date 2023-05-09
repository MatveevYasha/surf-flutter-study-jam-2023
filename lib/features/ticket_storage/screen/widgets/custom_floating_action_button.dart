import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';

final _formKey = GlobalKey<FormState>();

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.size,
    required this.colors,
    required this.textFieldController,
    required this.nameTickets,
  });

  final Size size;
  final ColorScheme colors;
  final TextEditingController textFieldController;
  final List<String> nameTickets;

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

// Сама кнопка
class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showBottomSheet(context);
      },
      label: Text(
        LocaleKeys.add.tr(),
      ),
      backgroundColor: widget.colors.inversePrimary,
    );
  }

// Модалка
  Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          height: widget.size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: widget.size.height * 0.005,
                width: widget.size.width * 0.1,
                decoration: BoxDecoration(
                  color: widget.colors.secondary,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.contains('.pdf') == false) {
                        return LocaleKeys.enter_correct_url.tr();
                      }
                      return null;
                    },
                    controller: widget.textFieldController,
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
                      const SnackBar(content: Text('Processing Data')),
                    );
                    setState(() {
                      widget.nameTickets.add(widget.textFieldController.text);
                      widget.textFieldController.clear();
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text(LocaleKeys.add.tr()),
              ),
              SizedBox(height: widget.size.height * 0.015)
            ],
          ),
        );
      },
    );
  }
}
