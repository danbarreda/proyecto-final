import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/libro.dart';
import '../widgets/barraSuperior.dart';

class DetalleLibroPage extends StatelessWidget {
  final Libro libro;

  const DetalleLibroPage({super.key, required this.libro});

  void solicitarLibro(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes iniciar sesión para solicitar un libro."),
        ),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('solicitudes').insert({
        'libro_id': libro.id,
        'usuario_correo': user.email,
        'estado': 'Solicitado',
        'titulo_libro': libro.titulo,
        'imagen_libro': libro.imagenUrl,
        'fecha_solicitud': DateTime.now().toIso8601String(),
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Solicitud enviada con éxito!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al solicitar el libro: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 700;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: isDesktop ? BarraSuperiorDesktop() : const BarraSuperiorMovil(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF00235E),
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
                Flex(
                  direction: isDesktop ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: libro.imagenUrl.isNotEmpty
                          ? Image.network(
                              libro.imagenUrl,
                              width: isDesktop ? 300 : double.infinity,
                              height: isDesktop ? 450 : 400,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _placeholderImage(isDesktop),
                            )
                          : _placeholderImage(isDesktop),
                    ),
                    SizedBox(
                      width: isDesktop ? 40 : 0,
                      height: isDesktop ? 0 : 30,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              libro.carrera,
                              style: GoogleFonts.inter(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            libro.titulo,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF00235E),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Autor: ${libro.autor.isNotEmpty ? libro.autor.join(', ') : 'Desconocido'}",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "Descripción",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00235E),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            libro.descripcion,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Estado físico: ${libro.estadoFisico}",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => solicitarLibro(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF37021),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Solicitar Material",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage(bool isDesktop) {
    return Container(
      width: isDesktop ? 300 : double.infinity,
      height: isDesktop ? 450 : 400,
      color: Colors.grey[200],
      child: const Icon(Icons.book, size: 100, color: Colors.grey),
    );
  }
}
