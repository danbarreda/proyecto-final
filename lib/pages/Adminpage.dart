import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/homepage.dart';

class PantallaAdmin extends StatelessWidget {
  const PantallaAdmin({super.key});

  void _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color naranjaSamanet = Color(0xFFFF754C);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "SAMANET.",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: naranjaSamanet,
              fontSize: 26,
              letterSpacing: -0.5,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 8.0,
            ),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abriendo solicitudes...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: naranjaSamanet,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Solicitudes Recibidas",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 8.0,
            ),
            child: ElevatedButton(
              onPressed: () => _cerrarSesion(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: naranjaSamanet,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Salir",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("materialAcademico")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Ocurrió un error al cargar datos."),
            );
          }

          final publicaciones = snapshot.data?.docs ?? [];
          final totalLibros = publicaciones.length;

          Map<String, int> conteoMaterias = {};
          for (var doc in publicaciones) {
            final data = doc.data() as Map<String, dynamic>;
            String materia = data['materia'] ?? 'General';
            conteoMaterias[materia] = (conteoMaterias[materia] ?? 0) + 1;
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Panel de Administración",
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(
                      Icons.library_books,
                      color: naranjaSamanet,
                      size: 40,
                    ),
                    title: Text(
                      "Total de Materiales Publicados",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("$totalLibros libros/guías disponibles"),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Métricas por Materia",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: conteoMaterias.isEmpty
                      ? Center(
                          child: Text(
                            "No hay datos de materias.",
                            style: GoogleFonts.inter(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: conteoMaterias.length,
                          itemBuilder: (context, index) {
                            String materia = conteoMaterias.keys.elementAt(
                              index,
                            );
                            int conteo = conteoMaterias[materia]!;
                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.analytics,
                                  color: Colors.blueAccent,
                                ),
                                title: Text(
                                  materia,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Text(
                                  "$conteo",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
