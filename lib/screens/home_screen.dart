import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graph_drawer/widgets/widgets.dart';
import 'package:graph_drawer/models/models.dart';
import 'package:graph_drawer/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GraphModel> nodes = [];
  List<Connection> connections = [];

  int elementIndex = -1;

  String name = '';
  double radius = 40;

  bool allowEditNode = false;

  bool allowEditConnection = false;

  bool allowDrag = false;

  Random random = Random();
  int state = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Drawer'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: [
          ...connections,
          ...nodes,
          if (state == 1)
            CustomAlertDialogNodeName(
                title: 'Agregar Nodo',
                content: 'Nombre del Nodo',
                cancelAction: () {
                  setState(() {
                    state = 0;
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    name = value;
                    state = 2;
                  });
                }),
          if (state == 2)
            GestureDetector(
              onTapDown: (position) {
                setState(
                  () {
                    if (position.localPosition.dx - radius > 0 && position.localPosition.dy - radius > 0) {
                      state = 0;
                      nodes.add(GraphModel(
                        x: position.localPosition.dx,
                        y: position.localPosition.dy,
                        color: Colors.indigo,
                        radius: radius,
                        text: name,
                      ));
                      addConnections();
                    }
                  },
                );
              },
            ),
          if (state == 3)
            GestureDetector(
              onPanDown: (position) {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                      elementIndex = i;
                      allowEditNode = true;
                      state = 4;
                      break;
                    }
                  }
                  for (int i = 0; i < connections.length; i++) {
                    if (connections[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                      elementIndex = i;
                      allowEditConnection = true;
                      state = 4;
                      break;
                    }
                  }
                });
                if (state != 4) state = 0;
              },
            ),
          if (state == 4 && allowEditNode)
            CustomAlertDialogNodeName(
                title: 'Editar Nodo',
                content: 'Nombre del Nodo',
                cancelAction: () {
                  setState(() {
                    elementIndex = -1;
                    allowEditNode = false;
                    state = 0;
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    nodes[elementIndex] = nodes[elementIndex].copyWith(text: value);
                    elementIndex = -1;
                    allowEditNode = false;
                    state = 0;
                  });
                },
                text: nodes[elementIndex].text),
          if (state == 4 && allowEditConnection)
            CustomAlertDialogNodeName(
                title: 'Editar Conexion',
                content: 'Peso de la Conexion',
                cancelAction: () {
                  setState(() {
                    elementIndex = -1;
                    allowEditConnection = false;
                    state = 0;
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    connections[elementIndex] = connections[elementIndex].copyWith(text: value);
                    elementIndex = -1;
                    allowEditConnection = false;
                    state = 0;
                  });
                },
                text: connections[elementIndex].text),
          if (state == 5)
            GestureDetector(
              onPanDown: (position) {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                      elementIndex = i;
                      allowDrag = true;
                      break;
                    }
                  }
                });
              },
              onPanUpdate: (position) {
                setState(() {
                  if (allowDrag && position.localPosition.dx - radius > 0 && position.localPosition.dy - radius > 0) {
                    nodes[elementIndex] = nodes[elementIndex].copyWith(
                      x: position.localPosition.dx,
                      y: position.localPosition.dy,
                    );
                    editConnections();
                  }
                });
              },
              onPanEnd: (position) {
                customScaffoldMessenger(context: context, text: 'Nodo movido.');
                setState(() {
                  allowDrag = false;
                  elementIndex = -1;
                  state = 0;
                });
              },
            ),
          if (state == 6)
            GestureDetector(
              onTapDown: (position) {
                setState(
                  () {
                    for (int i = 0; i < nodes.length; i++) {
                      if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                        nodes.removeAt(i);
                        deleteConnections(i);
                        state = 0;
                        customScaffoldMessenger(context: context, text: 'Nodo eliminado.');
                        break;
                      }
                    }
                  },
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                state = 1;
              });
              break;
            case 1:
              customScaffoldMessenger(context: context, text: 'Presione en el peso de la conexión o en el nodo para editar.');
              setState(() {
                state = 3;
              });
              break;
            case 2:
              customScaffoldMessenger(context: context, text: 'Presione en un nodo para moverlo.');
              setState(() {
                state = 5;
              });
              break;
            case 3:
              state = 6;
              customScaffoldMessenger(context: context, text: 'Presione en un nodo para eliminarlo.');
              setState(() {
                state = 6;
              });
              break;
          }
        },
      ),
    );
  }

  void addConnections() {
    for (int i = 0; i < nodes.length - 1; i++) {
      connections.add(Connection(
        x1: nodes[i].x,
        y1: nodes[i].y,
        x2: nodes[nodes.length - 1].x,
        y2: nodes[nodes.length - 1].y,
        text: '1',
        start: i,
        end: nodes.length - 1,
      ));
    }
  }

  void editConnections() {
    for (int i = 0; i < connections.length; i++) {
      if (connections[i].start == elementIndex) {
        connections[i] = connections[i].copyWith(
          x1: nodes[elementIndex].x,
          y1: nodes[elementIndex].y,
        );
      }
      if (connections[i].end == elementIndex) {
        connections[i] = connections[i].copyWith(
          x2: nodes[elementIndex].x,
          y2: nodes[elementIndex].y,
        );
      }
    }
  }

  void deleteConnections(int index) {
    List<int> indexes = [];
    for (int i = 0; i < connections.length; i++) {
      if (connections[i].start == index || connections[i].end == index) {
        indexes.add(i);
      }
    }
    for (int i = indexes.length - 1; i >= 0; i--) {
      connections.removeAt(indexes[i]);
    }
  }
}
