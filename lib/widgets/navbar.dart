

import 'dart:math';

import 'package:biblioteca_unimet/pages/crearPublicacionPage.dart';
import 'package:biblioteca_unimet/pages/misSolicitudespage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatefulWidget {
  final String role;
  const NavBar({super.key, required this.role});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  bool isAdmin(){
    return widget.role == "admin";
  }

  void _mostrarDialogoContribucion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Contribuir con SAMANET",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00235E),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tu aporte voluntario nos ayuda a mantener y mejorar esta plataforma colaborativa para reducir la brecha de acceso al material educativo en toda la comunidad Unimetana.",
                style: GoogleFonts.inter(fontSize: 16),
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Redirigiendo a la pasarela de pago (PayPal)...",
                        ),
                        backgroundColor: Color(0xFF0079C1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment),
                  label: Text(
                    "Donar con PayPal",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0079C1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cerrar",
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  final buttonColor = Color.fromARGB(255, 255, 255, 255);

  final TextStyle actionText = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(25)),
                child: Container(
                  height: 70,
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
                                  builder: (context) => CrearPublicacionPage(role: widget.role),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.add,
                              color: buttonColor,
                              size: 30,
                            ),
                            
                          ),
                          Text("Publicar", style: actionText,)
                        ]
                      ),
                      Container(width: 2, height: 60, color: Colors.white,),
                      Column(
                        spacing: 0,
                        children: [ 
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MisSolicitudesPage(role: widget.role),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.question_mark,
                              color: buttonColor,
                              size: 30,
                            ),
                            
                          ),
                          Text("Actividad", style: actionText,)
                        ]
                      ),
                      Container(width: 2, height: 60, color: Colors.white,),
                      Column(
                        spacing: 0,
                        children: [ 
                          IconButton(
                            onPressed: () => _mostrarDialogoContribucion(context),
                            icon: Icon(
                              Icons.handshake,
                              color: buttonColor,
                              size: 30,
                            ),
                            
                          ),
                          Text("Contribuir", style: actionText)
                        ]
                      ),
                    ]
                  ),
                )
              );
  }
}