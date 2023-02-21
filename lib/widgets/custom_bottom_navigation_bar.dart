import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function onTap;
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: (currentIndex < 0) ? 0 : currentIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.grey.shade400,
        items: [
          BottomNavigationBarItem(icon: customIcon(0, 'assets/add.png'), label: 'Añadir vertice'),
          BottomNavigationBarItem(icon: customIcon(1, 'assets/edge.png'), label: 'Añadir arista'),
          BottomNavigationBarItem(icon: customIcon(2, 'assets/delete.png'), label: 'Eliminar'),
          BottomNavigationBarItem(icon: customIcon(3, 'assets/hand.png'), label: 'Mover vertice'),
          BottomNavigationBarItem(icon: customIcon(4, 'assets/matrix.png'), label: 'Generar matriz de adyacencia'),
        ],
        onTap: ((value) => onTap(value)));
  }

  Widget customIcon(int index, String iconPath) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: currentIndex == index ? const Color.fromRGBO(2, 181, 82, 1) : Colors.indigo,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ImageIcon(
          AssetImage(iconPath),
          size: 40,
        ),
      ),
    );
  }
}
