import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function cancelAction;
  final Function confirmAction;

  const CustomAlertDialog({
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
              return 'Por favor ingrese una letra';
            }
            if (value.length > 1) {
              return 'Por favor ingrese una letra';
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
              if (controller.text.length == 1) {
                confirmAction(controller.text.toUpperCase());
                //Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Presione en el espacio para agregar el nodo'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor ingrese una letra'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }),
      ],
    );
  }
}
