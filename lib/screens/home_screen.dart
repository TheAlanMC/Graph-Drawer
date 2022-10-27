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
  String name = '';
  double radius = 40;

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
          ...nodes,
          ...connections,
          if (state == 1)
            CustomAlertDialog(
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
              onTapDown: (details) {
                setState(
                  () {
                    state = 0;
                    nodes.add(Node(
                      x: details.localPosition.dx,
                      y: details.localPosition.dy,
                      color: Colors.indigo,
                      radius: radius,
                      text: name,
                    ));
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
              break;
            case 2:
              break;
            case 3:
              setState(() {
                if (nodes.isNotEmpty) {
                  nodes.removeLast();
                }
              });
              break;
          }
        },
      ),
    );
  }
}
