import 'package:flutter/material.dart';
import 'package:graph_drawer/utils/utils.dart';

class CustomAlertDialogNodeName extends StatelessWidget {
  final String title;
  final String content;
  final String? text;
  final Function cancelAction;
  final Function confirmAction;

  const CustomAlertDialogNodeName({
    Key? key,
    required this.title,
    required this.content,
    this.text,
    required this.cancelAction,
    required this.confirmAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    controller.text = text ?? '';
    return AlertDialog(
      title: Text(title),
      content: Form(
        autovalidateMode: AutovalidateMode.always,
        child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: content,
            errorMaxLines: 2,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese una letra o un número.';
            }
            if (value.length > 1) {
              return 'Por favor ingrese una letra o un número.';
            }
            return null;
          },
          controller: controller,
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => cancelAction(),
        ),
        TextButton(
            child: const Text("Confirmar"),
            onPressed: () {
              if (controller.text.length == 1 && controller.text.isNotEmpty) {
                confirmAction(controller.text.toUpperCase());
                customScaffoldMessenger(
                  context: context,
                  text: text == null ? 'Nodo añadido' : 'Nodo editado.',
                );
              } else {
                customScaffoldMessenger(context: context, text: 'Por favor ingrese una letra o un número.');
              }
            }),
      ],
    );
  }
}
