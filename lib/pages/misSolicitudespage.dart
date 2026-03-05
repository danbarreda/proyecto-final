import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/barraSuperior.dart';
import '../widgets/tarjetaPerfil.dart';
import '../widgets/tarjetaLibroActividad.dart';

class MisSolicitudesPage extends StatelessWidget {
  MisSolicitudesPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraSuperiorDesktop(), 
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/biblioteca.png"), 
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Text(
                "Mi Actividad",
                style: GoogleFonts.montserrat(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              const TarjetaPerfil(
                nombre: "Daniela Urdaneta",
                cedula: "31984863",
                correo: "urdaneta.daniela@correo.unimet.edu.ve",
              ), 

              const SizedBox(height: 30),
              TarjetaLibroActividad(
                titulo: "Don Quijote de la Mancha",
                estado: "Disponible",
                colorEstado: Color(0xFF66BB6A), 
                subtexto: "Disponible para retirar",
                imagenRuta: "assets/images/quijote.jpg",
              ),
              TarjetaLibroActividad(
                titulo: "Creatividad y desarrollo personal",
                estado: "Entregado",
                colorEstado: Color(0xFF81D4FA), 
                subtexto: "Entregado: 29 de enero\nVence: 5 de febrero",
                imagenRuta: "assets/images/creatividad.jpg",
              ),
              TarjetaLibroActividad(
                titulo: "Historia de la Física del Universo",
                estado: "Vencido",
                colorEstado: Color(0xFFEF5350), 
                subtexto: "Vencido desde: 15 de enero",
                imagenRuta: "assets/images/fisica.jpg",
              ),
              TarjetaLibroActividad(
                titulo: "Cálculo II",
                estado: "Solicitado",
                colorEstado: Color(0xFFFDD835), 
                subtexto: "Se notificará cuando esté disponible para retirar",
                imagenRuta: "assets/images/calculo.jpg",
              ),
              
              SizedBox(height: 50),
              Text(
                "Copyright © 2026 - Universidad Metropolitana.",
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}