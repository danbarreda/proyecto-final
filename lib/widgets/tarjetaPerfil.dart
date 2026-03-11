import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TarjetaPerfil extends StatelessWidget {
  final String nombre;
  final String cedula;
  final String correo;

  const TarjetaPerfil({
    super.key,
    required this.nombre,
    required this.cedula,
    required this.correo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      constraints: const BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MI PERFIL",
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 15),
                _buildDato("Nombre y Apellido:", nombre),
                _buildDato("Cédula:", cedula),
                _buildDato("Correo:", correo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            etiqueta,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 10),
          Text(
            valor,
            style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
