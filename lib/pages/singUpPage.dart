
import 'package:biblioteca_unimet/widgets/barraSuperior.dart';
import 'package:biblioteca_unimet/widgets/signUpForm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BarraSuperiorMovil(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/images/biblioteca.png"),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text(
                "Crear Cuenta",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              Center(child: SignUpForm()),
              Column(

                children: [
                  Text("Copyright © 2026 - Universidad Metropolitana.", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800)),
                  Text("Todos los derechos reservados", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800))
                ],
              ),
          ]))
        ],
      ),
    );
  }
}