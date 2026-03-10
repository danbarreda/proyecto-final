import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/barraSuperior.dart';
import '../widgets/tarjetaPerfil.dart';
import '../widgets/tarjetaLibroActividad.dart';

class MisSolicitudesPage extends StatelessWidget {
  MisSolicitudesPage({super.key});

  Color _obtenerColorPorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
      case 'aceptado':
        return const Color(0xFF66BB6A);
      case 'entregado':
        return const Color(0xFF81D4FA);
      case 'vencido':
        return const Color(0xFFEF5350);
      case 'solicitado':
      default:
        return const Color(0xFFFDD835);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: BarraSuperiorDesktop(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/biblioteca.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30),
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
              const SizedBox(height: 30),

              if (user != null)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        !snapshot.data!.exists) {
                      return TarjetaPerfil(
                        nombre: "Usuario Desconocido",
                        cedula: "N/A",
                        correo: user.email ?? "N/A",
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    return TarjetaPerfil(
                      nombre:
                          data['nombre'] ??
                          data['name'] ??
                          "Usuario sin nombre",
                      cedula: data['cedula'] ?? data['id'] ?? "N/A",
                      correo: user.email ?? "N/A",
                    );
                  },
                )
              else
                const TarjetaPerfil(
                  nombre: "No autenticado",
                  cedula: "N/A",
                  correo: "N/A",
                ),

              const SizedBox(height: 30),

              if (user != null)
                FutureBuilder<List<dynamic>>(
                  future: Supabase.instance.client
                      .from('solicitudes')
                      .select()
                      .eq('usuario_correo', user.email!)
                      .order('fecha_solicitud', ascending: false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        "Error al cargar historial",
                        style: GoogleFonts.inter(color: Colors.white),
                      );
                    }

                    final solicitudes = snapshot.data ?? [];

                    if (solicitudes.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Aún no tienes solicitudes de libros.",
                          style: GoogleFonts.inter(fontSize: 18),
                        ),
                      );
                    }

                    return Column(
                      children: solicitudes.map((solicitud) {
                        return TarjetaLibroActividad(
                          titulo:
                              solicitud['titulo_libro'] ?? 'Libro sin título',
                          estado: solicitud['estado'] ?? 'Solicitado',
                          colorEstado: _obtenerColorPorEstado(
                            solicitud['estado'] ?? '',
                          ),
                          subtexto:
                              "Fecha: ${solicitud['fecha_solicitud']?.substring(0, 10) ?? 'Reciente'}",
                          imagenUrl: solicitud['imagen_libro'] ?? '',
                        );
                      }).toList(),
                    );
                  },
                ),

              const SizedBox(height: 50),
              Text(
                "Copyright © 2026 - Universidad Metropolitana.",
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
