import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      body: StreamBuilder(
        stream: Supabase.instance.client
            .from("materialAcademico")
            .stream(primaryKey: ["id"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return const Center(
              child: Text("Ocurrió un error al cargar datos."),
            );

          final publicaciones = snapshot.data ?? [];
          final totalLibros = publicaciones.length;
          final disponibles = publicaciones
              .where((item) => item['disponible'] == true)
              .length;
          final noDisponibles = publicaciones
              .where((item) => item['disponible'] == false)
              .length;

          Map<String, double> conteoMaterias = {};
          for (var data in publicaciones) {
            String materia = data['materia'] ?? 'General';
            conteoMaterias[materia] = (conteoMaterias[materia] ?? 0) + 1;
          }

          String masPopular = "Ninguna";
          if (conteoMaterias.isNotEmpty) {
            masPopular = conteoMaterias.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key;
          }

          return SingleChildScrollView(
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
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 2.5,
                  children: [
                    _itemMetrica(
                      "Materia Popular",
                      masPopular,
                      Icons.trending_up,
                      naranjaSamanet,
                    ),
                    _itemMetrica(
                      "Libros Disponibles",
                      "$disponibles",
                      Icons.check_circle,
                      Colors.green,
                    ),
                    _itemMetrica(
                      "Libros No Disponibles",
                      "$noDisponibles",
                      Icons.hourglass_empty,
                      Colors.orange,
                    ),
                    _itemMetrica(
                      "Total en Base",
                      "$totalLibros",
                      Icons.storage,
                      Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "Distribución de Materias",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 20),
                conteoMaterias.isEmpty
                    ? const Center(
                        child: Text("No hay datos de materias suficientes."),
                      )
                    : PieChart(
                        dataMap: conteoMaterias,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        initialAngleInDegree: 0,
                        chartType: ChartType.disc,
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                const SizedBox(height: 40),
                Text(
                  "Gestión de Materiales",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: publicaciones.length,
                  itemBuilder: (context, index) {
                    final libroActual = publicaciones[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          libroActual['titulo'] ?? 'Sin título',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(libroActual['materia'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("¿Borrar libro?"),
                                content: Text(
                                  "¿Estás seguro de eliminar '${libroActual['titulo']}'?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("CANCELAR"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await Supabase.instance.client
                                          .from('materialAcademico')
                                          .delete()
                                          .match({'id': libroActual['id']});
                                    },
                                    child: const Text(
                                      "BORRAR",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  "Solicitudes de Administrador",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: Supabase.instance.client
                      .from("solicitudesAdmin")
                      .stream(primaryKey: ["id"]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const Center(child: CircularProgressIndicator());
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No hay solicitudes de administrador.",
                          style: GoogleFonts.inter(fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final solicitud = snapshot.data![index];
                        final String nombre =
                            solicitud['nombreCompleto'] ?? 'Sin Nombre';
                        final String correo =
                            solicitud['emailSolicitante'] ?? 'Sin Correo';
                        if (solicitud['estado']
                                .toString()
                                .trim()
                                .toLowerCase() !=
                            'pendiente')
                          return const SizedBox.shrink();
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              nombre,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              correo,
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(correo)
                                        .update({'role': 'admin'});
                                    await Supabase.instance.client
                                        .from('solicitudesAdmin')
                                        .update({'estado': 'aceptada'})
                                        .match({'emailSolicitante': correo});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.redAccent,
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    await Supabase.instance.client
                                        .from('solicitudesAdmin')
                                        .update({'estado': 'rechazada'})
                                        .match({'emailSolicitante': correo});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemMetrica(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            valor,
            style: GoogleFonts.inter(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            titulo,
            style: GoogleFonts.inter(fontSize: 15, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
