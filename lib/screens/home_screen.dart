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
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  switch (state) {
                    case 0:
                      nodes.add(Node(color: Colors.indigo, x: details.localPosition.dx, y: details.localPosition.dy));
                      break;
                    case 1:
                      nodes.add(Node(color: Colors.indigo, x: details.localPosition.dx, y: details.localPosition.dy));
                      break;
                    case 2:
                      nodes.add(Node(color: Colors.indigo, x: details.localPosition.dx, y: details.localPosition.dy));
                      break;
                    case 3:
                      nodes.add(Node(color: Colors.indigo, x: details.localPosition.dx, y: details.localPosition.dy));
                      break;
                  }
                });
              },
            )
          ],
        ),
        bottomNavigationBar: _customBottomNavigation());
  }

  BottomNavigationBar _customBottomNavigation() {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.indigo,
      backgroundColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.add, size: 45), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.edit, size: 45), label: 'Distancia entre Nodos'),
        BottomNavigationBarItem(icon: Icon(Icons.move_down, size: 45), label: 'Modificar Nodo'),
        BottomNavigationBarItem(icon: Icon(Icons.delete, size: 45), label: 'Eliminar Nodo'),
      ],
      onTap: (index) {
        switch (index) {
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
            break;
        }
      },
    );
  }
}
