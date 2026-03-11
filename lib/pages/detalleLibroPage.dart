import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/libro.dart';
import '../widgets/barraSuperior.dart';

class DetalleLibroPage extends StatefulWidget {
  final Libro libro;
  final String role;

  const DetalleLibroPage({super.key, required this.libro, required this.role});

  @override
  State<DetalleLibroPage> createState() => _DetalleLibroPageState();
}

class _DetalleLibroPageState extends State<DetalleLibroPage> {
  late final Stream<List<Map<String, dynamic>>> _solicitudesStream;
  late final Stream<List<Map<String, dynamic>>> _feedbacksStream;

  @override
  void initState() {
    super.initState();
    _solicitudesStream = Supabase.instance.client
        .from('solicitudes')
        .stream(primaryKey: ['id'])
        .eq('libro_id', widget.libro.id);

    _feedbacksStream = Supabase.instance.client
        .from('feedbacks')
        .stream(primaryKey: ['id'])
        .eq('evaluado_correo', widget.libro.propietarioid.trim());
  }

  Future<bool> yaSolicitado(String? email) async {
    final data = await Supabase.instance.client
        .from("solicitudes")
        .select("*")
        .eq("libro_id", widget.libro.id)
        .eq("usuario_correo", email!);
    return data.isNotEmpty;
  }

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

    if (await yaSolicitado(user.email)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ya has solicitado ese libro, puedes revisar su estado en 'Actividad'!",
          ),
        ),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('solicitudes').insert({
        'libro_id': widget.libro.id,
        'usuario_correo': user.email!.trim(),
        'propietario_correo': widget.libro.propietarioid.trim(),
        'estado': 'Solicitado',
        'titulo_libro': widget.libro.titulo,
        'imagen_libro': widget.libro.imagenUrl,
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

  Widget _buildFeedbackList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _solicitudesStream,
      builder: (context, solSnapshot) {
        if (solSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final solicitudes = solSnapshot.data ?? [];
        final validIds = solicitudes.map((e) => e['id'].toString()).toSet();

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: _feedbacksStream,
          builder: (context, fbSnapshot) {
            if (fbSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final allFeedbacks = fbSnapshot.data ?? [];
            final feedbacks = allFeedbacks
                .where((f) => validIds.contains(f['solicitud_id'].toString()))
                .toList();

            feedbacks.sort((a, b) {
              DateTime dateA =
                  DateTime.tryParse(a['fecha_creacion'] ?? '') ??
                  DateTime.now();
              DateTime dateB =
                  DateTime.tryParse(b['fecha_creacion'] ?? '') ??
                  DateTime.now();
              return dateB.compareTo(dateA);
            });

            if (feedbacks.isEmpty) {
              return Text(
                "Aún no hay feedbacks para este intercambio.",
                style: GoogleFonts.inter(color: Colors.grey[600]),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final fb = feedbacks[index];
                int calificacion = fb['calificacion'] ?? 5;
                String comentario = fb['comentario'] ?? '';
                String evaluador = fb['evaluador_correo'] ?? 'Usuario anónimo';
                String fecha = fb['fecha_creacion'] != null
                    ? fb['fecha_creacion'].toString().substring(0, 10)
                    : '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < calificacion
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                          Text(
                            fecha,
                            style: GoogleFonts.inter(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        evaluador,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontSize: 13,
                        ),
                      ),
                      if (comentario.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          comentario,
                          style: GoogleFonts.inter(
                            color: Colors.grey[800],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 700;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: isDesktop
          ? BarraSuperiorDesktop(role: widget.role)
          : const BarraSuperiorMovil(),
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
                      child: widget.libro.imagenUrl.isNotEmpty
                          ? Image.network(
                              widget.libro.imagenUrl,
                              width: isDesktop ? 300 : 400,
                              height: isDesktop ? 450 : 500,
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
                    isDesktop
                        ? Expanded(
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
                                    widget.libro.carrera,
                                    style: GoogleFonts.inter(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  widget.libro.titulo,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF00235E),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Autor: ${widget.libro.autor.isNotEmpty ? widget.libro.autor.join(', ') : 'Desconocido'}",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Propietario: ${widget.libro.propietarioid.isNotEmpty ? widget.libro.propietarioid : 'Desconocido'}",
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
                                  widget.libro.descripcion,
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
                                      "Estado físico: ${widget.libro.estadoFisico}",
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
                                const SizedBox(height: 40),
                                const Divider(),
                                const SizedBox(height: 20),
                                Text(
                                  "Feedbacks de Intercambio",
                                  style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF00235E),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildFeedbackList(),
                              ],
                            ),
                          )
                        : Column(
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
                                  widget.libro.carrera,
                                  style: GoogleFonts.inter(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                widget.libro.titulo,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF00235E),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Autor: ${widget.libro.autor.isNotEmpty ? widget.libro.autor.join(', ') : 'Desconocido'}",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.blueGrey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Propietario: ${widget.libro.propietarioid.isNotEmpty ? widget.libro.propietarioid : 'Desconocido'}",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
                                widget.libro.descripcion,
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
                                    "Estado físico: ${widget.libro.estadoFisico}",
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
                              const SizedBox(height: 40),
                              const Divider(),
                              const SizedBox(height: 20),
                              Text(
                                "Feedbacks de Intercambio",
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00235E),
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildFeedbackList(),
                            ],
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
