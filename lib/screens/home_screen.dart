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
  List<NodeModel> nodes = [];
  List<int> selectedNodes = [];
  List<ConnectionModel> connections = [];
  List<ConnectionModel> connectionsToDraw = [];

  int elementIndex = -1;
  double radius = 40;
  bool allowEditNode = false;
  bool allowEditConnection = false;
  bool allowDrag = false;
  int state = 0;
  Random random = Random();

  List<String> messages = [
    'Selecione un botón',
    'Modo Agregar Nodo',
    'Modo Agregar Nodo',
    'Modo Edición Nodo o Conexión',
    'Modo Edición Nodo o Conexión',
    'Modo Mover Nodo',
    'Modo Eliminar Nodo',
    'Modo Sumar Distancia',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(messages[state]),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: [
          ...connections,
          ...connectionsToDraw,
          ...nodes,
          if (state == 1)
            GestureDetector(
              onTapDown: (position) {
                setState(
                  () {
                    if (isInsideScreen(position.localPosition.dx, position.localPosition.dy)) {
                      state = 2;
                      nodes.add(NodeModel(
                        x: position.localPosition.dx,
                        y: position.localPosition.dy,
                        color: Colors.indigo,
                        radius: radius,
                        text: '',
                      ));
                      addConnections();
                    }
                  },
                );
              },
            ),
          if (state == 2)
            CustomAlertDialogNodeName(
                title: 'Agregar Nodo',
                content: 'Nombre del Nodo',
                cancelAction: () {
                  setState(() {
                    state = 0;
                    deleteConnections(nodes.length - 1);
                    nodes.removeLast();
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    nodes.last = nodes.last.copyWith(text: value);
                    state = 1;
                  });
                }),
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
                if (state != 4) state = 3;
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
                    state = 3;
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    nodes[elementIndex] = nodes[elementIndex].copyWith(text: value);
                    elementIndex = -1;
                    allowEditNode = false;
                    state = 3;
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
                    state = 3;
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    connections[elementIndex] = connections[elementIndex].copyWith(text: value);
                    elementIndex = -1;
                    allowEditConnection = false;
                    state = 3;
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
                  if (allowDrag && isInsideScreen(position.localPosition.dx, position.localPosition.dy)) {
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
                  state = 5;
                });
              },
            ),
          if (state == 6)
            GestureDetector(
              onTapDown: (position) {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                      nodes.removeAt(i);
                      deleteConnections(i);
                      state = nodes.isEmpty ? 0 : 6;
                      customScaffoldMessenger(context: context, text: 'Nodo eliminado.');
                      break;
                    }
                  }
                });
              },
            ),
          if (state == 7)
            GestureDetector(
              onTapDown: (position) {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                      selectedNodes.add(i);
                      nodes[i] =
                          nodes[i].copyWith(color: Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1));
                      break;
                    }
                  }
                  drawConnections();
                });
              },
            ),
          if (state == 7)
            Container(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    sumConnectionsWeigth().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (value) {
          switch (value) {
            case 0:
              customScaffoldMessenger(context: context, text: 'Presione en la pantalla para agregar el nodo.');
              setState(() {
                state = 1;
              });
              break;
            case 1:
              customScaffoldMessenger(
                  context: context,
                  text: nodes.isNotEmpty
                      ? 'Presione en el peso de la conexión o en el nodo para editar.'
                      : 'Primero debe agregar nodos.');
              setState(() {
                state = nodes.isNotEmpty ? 3 : 0;
              });
              break;
            case 2:
              customScaffoldMessenger(
                  context: context, text: nodes.isNotEmpty ? 'Presione en un nodo para moverlo.' : 'Primero debe agregar nodos.');
              setState(() {
                state = nodes.isNotEmpty ? 5 : 0;
              });
              break;
            case 3:
              customScaffoldMessenger(
                  context: context, text: nodes.isNotEmpty ? 'Presione en un nodo para eliminarlo.' : 'Primero debe agregar nodos.');
              setState(() {
                state = nodes.isNotEmpty ? 6 : 0;
              });
              break;
            case 4:
              customScaffoldMessenger(
                  context: context,
                  text: connections.isNotEmpty ? 'Presione en un nodos para sumar la distancia' : 'Primero debe agregar dos nodos.');
              setState(() {
                state = connections.isNotEmpty ? 7 : 0;
              });
          }
        },
      ),
    );
  }

  void addConnections() {
    for (int i = 0; i < nodes.length - 1; i++) {
      connections.add(ConnectionModel(
        x1: nodes[i].x,
        y1: nodes[i].y,
        x2: nodes.last.x,
        y2: nodes.last.y,
        text: '1',
        start: i,
        end: nodes.length - 1,
        color: Colors.indigo,
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
    for (int i = 0; i < connections.length; i++) {
      if (connections[i].start == index || connections[i].end == index) {
        connections.removeAt(i);
        i--;
      } else {
        if (connections[i].start > index) connections[i] = connections[i].copyWith(start: connections[i].start - 1);
        if (connections[i].end > index) connections[i] = connections[i].copyWith(end: connections[i].end - 1);
      }
    }
  }

  bool isInsideScreen(double x, double y) {
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;
    final bottomPadding = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;
    if (x - radius > 0 &&
        x + radius < MediaQuery.of(context).size.width &&
        y - radius > 0 &&
        y + radius < MediaQuery.of(context).size.height - topPadding - bottomPadding - radius / 2) {
      return true;
    }
    return false;
  }

  int sumConnectionsWeigth() {
    int sum = 0;
    for (int i = 0; i < connectionsToDraw.length; i++) {
      sum += int.parse(connectionsToDraw[i].text);
      connectionsToDraw[i] = connectionsToDraw[i].copyWith(color: Colors.amber);
    }
    return sum;
  }

  void drawConnections() {
    connectionsToDraw.clear();
    for (int i = 0; i < selectedNodes.length - 1; i++) {
      for (int j = 0; j < connections.length; j++) {
        if (connections[j].start == selectedNodes[i] && connections[j].end == selectedNodes[i + 1]) {
          connectionsToDraw.add(connections[j]);
        }
      }
    }
    for (int i = 0; i < connectionsToDraw.length; i++) {
      connectionsToDraw[i] = connectionsToDraw[i].copyWith(color: Colors.red);
    }
  }
}
