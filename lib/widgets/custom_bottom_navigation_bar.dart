import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function onTap;

  const CustomBottomNavigationBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.indigo,
        backgroundColor: Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add, size: 45), label: 'Añadir nuevo Nodo'),
          BottomNavigationBarItem(icon: Icon(Icons.edit, size: 45), label: 'Distancia entre Nodos'),
          BottomNavigationBarItem(icon: Icon(Icons.move_down, size: 45), label: 'Modificar Nodo'),
          BottomNavigationBarItem(icon: Icon(Icons.delete, size: 45), label: 'Eliminar Nodo'),
        ],
        onTap: ((value) => onTap(value)));
  }
}
