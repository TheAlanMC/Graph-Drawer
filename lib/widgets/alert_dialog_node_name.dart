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
    final focus = FocusNode();
    final controller = TextEditingController();
    controller.text = text ?? '';

    return WillPopScope(
      onWillPop: () async {
        cancelAction();
        return false;
      },
      child: AlertDialog(
        title: Text(title),
        content: Form(
          autovalidateMode: AutovalidateMode.always,
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: content,
              errorMaxLines: 2,
            ),
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty || int.tryParse(value) != null) {
                return 'Ingrese un nombre válido.';
              }
              return null;
            },
            controller: controller,
            focusNode: focus,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              controller.text = controller.text.trim();
              if (controller.text.isNotEmpty && int.tryParse(controller.text) == null) {
                confirmAction(controller.text.toUpperCase());
              } else {
                customScaffoldMessenger(context: context, text: 'Ingrese un nombre válido.');
              }
            },
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    controller.text = controller.text.trim();
                    if (controller.text.isNotEmpty && int.tryParse(controller.text) == null) {
                      confirmAction(controller.text.toUpperCase());
                    } else {
                      customScaffoldMessenger(context: context, text: 'Ingrese un nombre válido.');
                    }
                  },
                  child: const Text('Aceptar')),
              const SizedBox(width: 25),
              ElevatedButton(
                child: const Text("Cancelar"),
                onPressed: () => cancelAction(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
