import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/generated/locale_keys.g.dart';

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
        bool isValid = false;
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
                child: TextField(
                  onChanged: (value) {
                    if (value.contains('.pdf') == true) {
                      isValid = true;
                    }
                  },
                  controller: widget.textFieldController,
                  keyboardType: TextInputType.url,
                  enabled: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.enter_url.tr(),
                    errorText:
                        isValid ? LocaleKeys.enter_correct_url.tr() : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (isValid == true) {
                    setState(() {
                      widget.nameTickets.add(widget.textFieldController.text);
                      widget.textFieldController.clear();
                      isValid = false;
                    });
                  }
                },
                child: Text(LocaleKeys.add.tr()),
              ),
              const SizedBox(height: 15)
            ],
          ),
        );
      },
    );
  }
}
