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
  List<EdgeModel> edges = [];
  int elementIndex = -1;
  double radius = 40;
  bool allowEditNode = false;
  bool allowEditConnection = false;
  bool allowDrag = false;
  int state = 0;

  List<String> messages = [
    'Selecione un botón',
    'Modo Agregar Nodo',
    'Modo Agregar Nodo',
    'Modo Edición Nodo o Conexión',
    'Modo Edición Nodo o Conexión',
    'Modo Mover Nodo',
    'Modo Eliminar Nodo',
  ];

  int currentSelectedIndex = -1;

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
          ...edges,
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
                  for (int i = 0; i < edges.length; i++) {
                    if (edges[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
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
                    edges[elementIndex] = edges[elementIndex].copyWith(text: value);
                    elementIndex = -1;
                    allowEditConnection = false;
                    state = 3;
                  });
                },
                text: edges[elementIndex].text),
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
              currentSelectedIndex = 0;
              break;
            case 1:
              customScaffoldMessenger(
                  context: context,
                  text: nodes.isNotEmpty ? 'Presione en el peso de la conexión o en el nodo para editar.' : 'Primero debe agregar nodos.');
              setState(() {
                state = nodes.isNotEmpty ? 3 : 0;
              });
              currentSelectedIndex = 1;
              break;
            case 2:
              customScaffoldMessenger(context: context, text: nodes.isNotEmpty ? 'Presione en un nodo para moverlo.' : 'Primero debe agregar nodos.');
              setState(() {
                state = nodes.isNotEmpty ? 5 : 0;
              });
              currentSelectedIndex = 2;
              break;
            case 3:
              customScaffoldMessenger(
                  context: context, text: nodes.isNotEmpty ? 'Presione en un nodo para eliminarlo.' : 'Primero debe agregar nodos.');
              setState(() {
                state = nodes.isNotEmpty ? 6 : 0;
              });
              currentSelectedIndex = 3;
              break;
          }
        },
        currentIndex: currentSelectedIndex,
      ),
    );
  }

  void addConnections() {
    for (int i = 0; i < nodes.length - 1; i++) {
      edges.add(EdgeModel(
        x1: nodes[i].x,
        y1: nodes[i].y,
        x2: nodes.last.x,
        y2: nodes.last.y,
        text: '1',
        start: i,
        end: nodes.length - 1,
        radius: radius,
      ));
    }
  }

  void editConnections() {
    for (int i = 0; i < edges.length; i++) {
      if (edges[i].start == elementIndex) {
        edges[i] = edges[i].copyWith(
          x1: nodes[elementIndex].x,
          y1: nodes[elementIndex].y,
        );
      }
      if (edges[i].end == elementIndex) {
        edges[i] = edges[i].copyWith(
          x2: nodes[elementIndex].x,
          y2: nodes[elementIndex].y,
        );
      }
    }
  }

  void deleteConnections(int index) {
    for (int i = 0; i < edges.length; i++) {
      if (edges[i].start == index || edges[i].end == index) {
        edges.removeAt(i);
        i--;
      } else {
        if (edges[i].start > index) edges[i] = edges[i].copyWith(start: edges[i].start - 1);
        if (edges[i].end > index) edges[i] = edges[i].copyWith(end: edges[i].end - 1);
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
}
