import 'dart:math';

import 'package:biblioteca_unimet/pages/crearPublicacionPage.dart';
import 'package:biblioteca_unimet/pages/misSolicitudespage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/contribucionPage.dart';

class NavBar extends StatefulWidget {
  final String role;
  const NavBar({super.key, required this.role});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isAdmin() {
    return widget.role == "admin";
  }

  void _mostrarDialogoContribucion(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContribucionPage(role: widget.role),
      ),
    );
  }

  final buttonColor = Color.fromARGB(255, 255, 255, 255);

  final TextStyle actionText = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = 20;
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.all(Radius.circular(17.5)),
      child: Container(
        height: 60,
        width: max(screenWidth - 200, 300),
        color: Color.fromARGB(255, 0, 7, 47),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              spacing: 0,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CrearPublicacionPage(role: widget.role),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, color: buttonColor, size: iconSize),
                ),
                Text("Publicar", style: actionText),
              ],
            ),
            Container(
              width: 2,
              height: 45,
              color: const Color.fromARGB(255, 112, 112, 112),
            ),
            Column(
              spacing: 0,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MisSolicitudesPage(role: widget.role),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.question_mark,
                    color: buttonColor,
                    size: iconSize,
                  ),
                ),
                Text("Actividad", style: actionText),
              ],
            ),
            Container(
              width: 2,
              height: 45,
              color: const Color.fromARGB(255, 112, 112, 112),
            ),
            Column(
              spacing: 0,
              children: [
                IconButton(
                  onPressed: () => _mostrarDialogoContribucion(context),
                  icon: Icon(
                    Icons.handshake,
                    color: buttonColor,
                    size: iconSize,
                  ),
                ),
                Text("Contribuir", style: actionText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
