import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarraSuperior extends StatelessWidget {
  const BarraSuperior({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        title: Text("SAMANET.",
        selectionColor: Colors.deepOrange.shade400,
        textAlign: TextAlign.left,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
      );
  }
}