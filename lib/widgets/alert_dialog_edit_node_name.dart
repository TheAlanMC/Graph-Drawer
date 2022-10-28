import 'package:flutter/material.dart';

class CustomAlertDialogEditNodeName extends StatelessWidget {
  final String title;
  final String content;
  final Function cancelAction;
  final Function confirmAction;

  const CustomAlertDialogEditNodeName({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelAction,
    required this.confirmAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: Text(title),
      content: Form(
        autovalidateMode: AutovalidateMode.always,
        child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: content,
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
            child: const Text("Continuar"),
            onPressed: () {
              if (controller.text.length == 1 && controller.text.isNotEmpty) {
                confirmAction(controller.text.toUpperCase());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Presione en la pantalla para agregar el nodo.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor ingrese una letra o un número.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }),
      ],
    );
  }
}
