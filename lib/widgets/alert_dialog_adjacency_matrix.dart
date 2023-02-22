import 'package:flutter/material.dart';

class CustomAlertDialogAdjacencyMatrix extends StatelessWidget {
  final String title;
  final List<List<int>> matrix;
  final List<String> labels;
  final Function cancelAction;

  const CustomAlertDialogAdjacencyMatrix({super.key, required this.title, required this.matrix, required this.labels, required this.cancelAction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.black, width: 2.0, style: BorderStyle.solid),
        children: _buildTableRows(),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Aceptar"),
              onPressed: () {
                cancelAction();
              },
            ),
          ],
        ),
      ],
    );
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [];
    List<String> labelsCopy = labels.toList();
    labelsCopy.add('∑');
    List<Widget> headerRow = [Container(color: Colors.grey.shade400, padding: const EdgeInsets.all(8.0), child: const Text(''))];
    for (String label in labelsCopy) {
      headerRow.add(
        Container(
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
    }
    rows.add(TableRow(children: headerRow));

    for (int i = 0; i < matrix.length; i++) {
      List<Widget> row = [
        Container(
          color: Colors.grey.shade400,
          padding: const EdgeInsets.all(8.0),
          child: Text(labelsCopy[i], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        )
      ];
      for (int j = 0; j < matrix[i].length; j++) {
        if (i == matrix.length - 1 && j == matrix[i].length - 1) {
          row.add(
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(''),
            ),
          );
          continue;
        }
        row.add(
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(matrix[i][j].toString(), textAlign: TextAlign.center),
          ),
        );
      }
      rows.add(TableRow(children: row));
    }

    return rows;
  }
}
