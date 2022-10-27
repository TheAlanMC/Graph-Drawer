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
      content: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: content,
        ),
        controller: controller,
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => cancelAction(),
        ),
        TextButton(
          child: const Text("Continuar"),
          onPressed: () => confirmAction(),
        ),
      ],
    );
  }
}
