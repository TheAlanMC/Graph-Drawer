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
  List<String> nodesNames = [];
  List<EdgeModel> edges = [];
  List<EdgeConnection> edgesConnections = [];
  NodeModel? sourceNode;
  NodeModel? targetNode;
  int elementIndex = -1;
  double radius = 30;
  bool allowEditConnection = false;
  bool allowDrag = false;
  int state = 0;
  int currentSelectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generación de Grafos'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: [
          ...nodes,
          ...edges,
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
                    }
                  },
                );
              },
            ),
          if (state == 2)
            CustomAlertDialogNodeName(
                title: 'Añadir vértice',
                content: 'Nombre del vértice:',
                cancelAction: () {
                  setState(() {
                    state = 1;
                    nodes.removeLast();
                  });
                },
                confirmAction: (value) {
                  setState(() {
                    nodesNames.add(value);
                    nodes.last = nodes.last.copyWith(text: value);
                    state = 1;
                  });
                },
                nodes: nodesNames),
          if (state == 3)
            GestureDetector(
              onTapDown: (position) {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                      sourceNode = nodes[i];
                      break;
                    }
                  }
                  state = 4;
                });
              },
            ),
          if (state == 4)
            GestureDetector(
              onTapDown: (position) {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
                      targetNode = nodes[i];
                      break;
                    }
                  }
                  state = 5;
                  edges.add(EdgeModel(
                    x1: sourceNode!.x,
                    y1: sourceNode!.y,
                    x2: targetNode!.x,
                    y2: targetNode!.y,
                    text: '',
                    radius: radius,
                  ));
                });
              },
            ),
          if (state == 5)
            CustomAlertDialogEdgeCost(
              title: 'Añadir arista',
              content: 'Costo de la arista:',
              cancelAction: () {
                setState(() {
                  state = 3;
                  edges.removeLast();
                  sourceNode = null;
                  targetNode = null;
                });
              },
              confirmAction: (value) {
                setState(() {
                  edgesConnections.add(EdgeConnection(
                    source: sourceNode!.text,
                    target: targetNode!.text,
                    cost: int.parse(value),
                  ));
                  bool duplicate = false;
                  for (int i = 0; i < edgesConnections.length - 1; i++) {
                    if (edgesConnections[i].source == edgesConnections.last.source && edgesConnections[i].target == edgesConnections.last.target) {
                      edgesConnections.removeLast();
                      edges.removeLast();
                      edges[i] = edges[i].copyWith(text: value.toString());
                      duplicate = true;
                      break;
                    }
                  }
                  if (!duplicate) {
                    edges.last = edges.last.copyWith(text: value);
                  }
                  sourceNode = null;
                  targetNode = null;
                  state = 3;
                });
              },
            )
          // if (state == 3)
          // if (state == 5)
          //   GestureDetector(
          //     onPanDown: (position) {
          //       setState(() {
          //         for (int i = 0; i < nodes.length; i++) {
          //           if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
          //             elementIndex = i;
          //             break;
          //           }
          //         }
          //         for (int i = 0; i < edges.length; i++) {
          //           if (edges[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
          //             elementIndex = i;
          //             allowEditConnection = true;
          //             break;
          //           }
          //         }
          //       });
          //     },
          //   ),
          // if (state == 4)
          //   CustomAlertDialogNodeName(
          //       title: 'Editar Nodo',
          //       content: 'Nombre del Nodo',
          //       cancelAction: () {
          //         setState(() {
          //           elementIndex = -1;
          //           state = 3;
          //         });
          //       },
          //       confirmAction: (value) {
          //         setState(() {
          //           nodes[elementIndex] = nodes[elementIndex].copyWith(text: value);
          //           elementIndex = -1;
          //           state = 3;
          //         });
          //       },
          //       text: nodes[elementIndex].text),
          // if (state == 4 && allowEditConnection)
          //   CustomAlertDialogNodeName(
          //       title: 'Editar Conexion',
          //       content: 'Peso de la Conexion',
          //       cancelAction: () {
          //         setState(() {
          //           elementIndex = -1;
          //           allowEditConnection = false;
          //           state = 3;
          //         });
          //       },
          //       confirmAction: (value) {
          //         setState(() {
          //           edges[elementIndex] = edges[elementIndex].copyWith(text: value);
          //           elementIndex = -1;
          //           allowEditConnection = false;
          //           state = 3;
          //         });
          //       },
          //       text: edges[elementIndex].text),
          // if (state == 5)
          //   GestureDetector(
          //     onPanDown: (position) {
          //       setState(() {
          //         for (int i = 0; i < nodes.length; i++) {
          //           if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
          //             elementIndex = i;
          //             allowDrag = true;
          //             break;
          //           }
          //         }
          //       });
          //     },
          //     onPanUpdate: (position) {
          //       setState(() {
          //         if (allowDrag && isInsideScreen(position.localPosition.dx, position.localPosition.dy)) {
          //           nodes[elementIndex] = nodes[elementIndex].copyWith(
          //             x: position.localPosition.dx,
          //             y: position.localPosition.dy,
          //           );
          //           editConnections();
          //         }
          //       });
          //     },
          //     onPanEnd: (position) {
          //       customScaffoldMessenger(context: context, text: 'Nodo movido.');
          //       setState(() {
          //         allowDrag = false;
          //         elementIndex = -1;
          //         state = 5;
          //       });
          //     },
          //   ),
          // if (state == 6)
          //   GestureDetector(
          //     onTapDown: (position) {
          //       setState(() {
          //         for (int i = 0; i < nodes.length; i++) {
          //           if (nodes[i].isInside(position.localPosition.dx, position.localPosition.dy)) {
          //             nodes.removeAt(i);
          //             state = nodes.isEmpty ? 0 : 6;
          //             customScaffoldMessenger(context: context, text: 'Nodo eliminado.');
          //             break;
          //           }
          //         }
          //       });
          //     },
          //   ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                state = 1;
              });
              currentSelectedIndex = 0;
              break;
            case 1:
              setState(() {
                state = 3;
                sourceNode = null;
                targetNode = null;
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
