import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graph_drawer/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Node> nodes = [];
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
                    state = 0;
                    nodes.add(Node(
                      x: position.localPosition.dx,
                      y: position.localPosition.dy,
                      color: Colors.indigo,
                      radius: radius,
                      text: name,
                    ));
                    updateConnections();
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
                    state = 0;
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    nodes[elementIndex] = nodes[elementIndex].copyWith(text: value);
                    state = 0;
                  });
                },
                text: nodes[elementIndex].text),
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
                  if (allowDrag) {
                    Node tempNode = nodes[elementIndex].copyWith(x: position.localPosition.dx, y: position.localPosition.dy);
                    nodes[elementIndex] = tempNode;
                    updateConnections();
                  }
                });
              },
              onPanEnd: (position) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nodo movido.'),
                    duration: Duration(seconds: 2),
                  ),
                );
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
                        state = 0;
                        updateConnections();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nodo eliminado.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Presione en el peso de la conexión o en el nodo para editar.'),
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {
                state = 3;
              });
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Presione en un nodo para moverlo.'),
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {
                state = 5;
              });
              break;
            case 3:
              state = 6;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Presione en un nodo para eliminarlo.'),
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {
                state = 6;
              });
              break;
          }
        },
      ),
    );
  }

  void updateConnections() {
    connections.clear();
    for (int i = 0; i < nodes.length - 1; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        connections.add(Connection(
          x1: nodes[i].x,
          y1: nodes[i].y,
          x2: nodes[j].x,
          y2: nodes[j].y,
          text: '1',
        ));
      }
    }
  }
}
