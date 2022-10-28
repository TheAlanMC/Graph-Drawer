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
          BottomNavigationBarItem(icon: Icon(Icons.add_outlined, size: 45), label: 'Añadir nuevo Nodo'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_outlined, size: 45), label: 'Distancia entre Nodos'),
          BottomNavigationBarItem(icon: Icon(Icons.move_down_outlined, size: 45), label: 'Modificar Nodo'),
          BottomNavigationBarItem(icon: Icon(Icons.delete_outlined, size: 45), label: 'Eliminar Nodo'),
        ],
        onTap: ((value) => onTap(value)));
  }
}
