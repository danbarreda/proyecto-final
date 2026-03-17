import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/barraSuperior.dart';
import '../widgets/tarjetaPerfil.dart';
import '../widgets/tarjetaLibroActividad.dart';

class MisSolicitudesPage extends StatefulWidget {
  final String role;
  const MisSolicitudesPage({super.key, required this.role});

  @override
  State<MisSolicitudesPage> createState() => _MisSolicitudesPageState();
}

class _MisSolicitudesPageState extends State<MisSolicitudesPage> {
  late final Stream<List<Map<String, dynamic>>> _recibidasStream;
  late final Stream<List<Map<String, dynamic>>> _enviadasStream;
  late final Stream<List<Map<String, dynamic>>> _feedbacksStream;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email;

    if (userEmail != null) {
      _recibidasStream = Supabase.instance.client
          .from('solicitudes')
          .stream(primaryKey: ['id'])
          .eq('propietario_correo', userEmail!);
      _enviadasStream = Supabase.instance.client
          .from('solicitudes')
          .stream(primaryKey: ['id'])
          .eq('usuario_correo', userEmail!);
      _feedbacksStream = Supabase.instance.client
          .from('feedbacks')
          .stream(primaryKey: ['id'])
          .eq('evaluador_correo', userEmail!);
    }
  }

  Color _obtenerColorPorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'aceptado':
        return Colors.blue;
      case 'entregado':
        return const Color(0xFF66BB6A);
      case 'rechazado':
      case 'vencido':
        return const Color(0xFFEF5350);
      case 'solicitado':
      default:
        return const Color(0xFFFDD835);
    }
  }

  Future<void> _gestionarSolicitud(
    String solicitudId,
    String libroId,
    String nuevoEstado,
  ) async {
    try {
      await Supabase.instance.client
          .from('solicitudes')
          .update({'estado': nuevoEstado})
          .eq('id', solicitudId);
      if (nuevoEstado == 'Aceptado') {
        await Supabase.instance.client
            .from('materialAcademico')
            .update({'disponible': false})
            .eq('id', libroId);
        await Supabase.instance.client
            .from('solicitudes')
            .update({'estado': 'Rechazado'})
            .eq('libro_id', libroId)
            .eq('estado', 'Solicitado');
      } else if (nuevoEstado == 'Rechazado') {
        await Supabase.instance.client
            .from('materialAcademico')
            .update({'disponible': true})
            .eq('id', libroId);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Solicitud marcada como $nuevoEstado"),
          backgroundColor: nuevoEstado == 'Rechazado'
              ? Colors.red
              : Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _mostrarDialogoCalificacion(Map<String, dynamic> solicitud) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    int estrellas = 5;
    TextEditingController comentarioCtrl = TextEditingController();
    String evaluadoCorreo = solicitud['propietario_correo'];

    showDialog(
      context: context,
      builder: (contextDialog) {
        return StatefulBuilder(
          builder: (contextDialog, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                "Calificar Intercambio",
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
                    "¿Cómo fue tu experiencia intercambiando con $evaluadoCorreo?",
                    style: GoogleFonts.inter(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < estrellas ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          setStateDialog(() {
                            estrellas = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: comentarioCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Deja un comentario (opcional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pop(contextDialog);
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    try {
                      await Supabase.instance.client.from('feedbacks').insert({
                        'solicitud_id': solicitud['id'].toString(),
                        'evaluador_correo': user.email,
                        'evaluado_correo': evaluadoCorreo,
                        'calificacion': estrellas,
                        'comentario': comentarioCtrl.text.trim(),
                      });
                      if (!contextDialog.mounted) return;
                      Navigator.pop(contextDialog);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("¡Gracias por tu feedback!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!contextDialog.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error al enviar: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF37021),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Enviar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userEmail == null) {
      return Scaffold(
        appBar: BarraSuperiorDesktop(role: widget.role),
        body: const Center(
          child: Text("Debes iniciar sesión para ver esta página."),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    String nombreUsuario = "Usuario sin nombre";
    Future<List<dynamic>> fetchSolicitudesAdmin() async {
      return await Supabase.instance.client
              .from('solicitudesAdmin')
              .select("*")
              .eq('emailSolicitante', user?.email ?? '')
          as List<dynamic>;
    }

    final Future<List<dynamic>> dataSolicitudAdmin = fetchSolicitudesAdmin();

    return Scaffold(
      appBar: BarraSuperiorDesktop(role: widget.role),
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
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists)
                    return TarjetaPerfil(
                      nombre: "Usuario Desconocido",
                      cedula: "N/A",
                      correo: userEmail ?? "N/A",
                    );
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  nombreUsuario =
                      data['nombreCompleto'] ??
                      data['nombre'] ??
                      data['name'] ??
                      "Usuario sin nombre";
                  return TarjetaPerfil(
                    nombre: nombreUsuario,
                    cedula: data['cedula'] ?? data['id'] ?? "N/A",
                    correo: userEmail ?? "N/A",
                  );
                },
              ),
              const SizedBox(height: 30),
              Container(
                constraints: const BoxConstraints(maxWidth: 850),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _feedbacksStream,
                  builder: (context, fbSnapshot) {
                    final misFeedbacks = fbSnapshot.data ?? [];
                    final calificadas = misFeedbacks
                        .map((e) => e['solicitud_id'].toString())
                        .toSet();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Solicitudes Recibidas (Tus Libros)",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _recibidasStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            final recibidas = snapshot.data ?? [];
                            recibidas.sort(
                              (a, b) => (b['fecha_solicitud'] ?? '').compareTo(
                                a['fecha_solicitud'] ?? '',
                              ),
                            );
                            if (recibidas.isEmpty)
                              return _mensajeVacio(
                                "Nadie ha solicitado tus libros aún.",
                              );
                            return Column(
                              children: recibidas.map((sol) {
                                return TarjetaLibroActividad(
                                  titulo:
                                      sol['titulo_libro'] ?? 'Libro sin título',
                                  estado: sol['estado'] ?? 'Solicitado',
                                  colorEstado: _obtenerColorPorEstado(
                                    sol['estado'] ?? '',
                                  ),
                                  subtexto:
                                      "Solicitado por: ${sol['usuario_correo']}\nFecha: ${sol['fecha_solicitud']?.substring(0, 10)}",
                                  imagenUrl: sol['imagen_libro'] ?? '',
                                  esEntrante: true,
                                  onAceptar: () => _gestionarSolicitud(
                                    sol['id'].toString(),
                                    sol['libro_id'].toString(),
                                    'Aceptado',
                                  ),
                                  onRechazar: () => _gestionarSolicitud(
                                    sol['id'].toString(),
                                    sol['libro_id'].toString(),
                                    'Rechazado',
                                  ),
                                  onEntregado: sol['estado'] == 'Aceptado'
                                      ? () => _gestionarSolicitud(
                                          sol['id'].toString(),
                                          sol['libro_id'].toString(),
                                          'Entregado',
                                        )
                                      : null,
                                  mostrarCalificar: false,
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Text(
                          "Mis Solicitudes (Enviadas)",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _enviadasStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            final enviadas = snapshot.data ?? [];
                            enviadas.sort(
                              (a, b) => (b['fecha_solicitud'] ?? '').compareTo(
                                a['fecha_solicitud'] ?? '',
                              ),
                            );
                            if (enviadas.isEmpty)
                              return _mensajeVacio(
                                "No has solicitado ningún libro.",
                              );
                            return Column(
                              children: enviadas.map((sol) {
                                bool yaCalifico = calificadas.contains(
                                  sol['id'].toString(),
                                );
                                bool puedeCalificar =
                                    sol['estado'] == 'Entregado' && !yaCalifico;
                                return TarjetaLibroActividad(
                                  titulo:
                                      sol['titulo_libro'] ?? 'Libro sin título',
                                  estado: sol['estado'] ?? 'Solicitado',
                                  colorEstado: _obtenerColorPorEstado(
                                    sol['estado'] ?? '',
                                  ),
                                  subtexto:
                                      "Propietario: ${sol['propietario_correo'] ?? 'Desconocido'}\nFecha: ${sol['fecha_solicitud']?.substring(0, 10)}",
                                  imagenUrl: sol['imagen_libro'] ?? '',
                                  onEntregado: sol['estado'] == 'Aceptado'
                                      ? () => _gestionarSolicitud(
                                          sol['id'].toString(),
                                          sol['libro_id'].toString(),
                                          'Entregado',
                                        )
                                      : null,
                                  mostrarCalificar: puedeCalificar,
                                  onCalificar: () =>
                                      _mostrarDialogoCalificacion(sol),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              if (widget.role.trim().toLowerCase() == "user")
                Column(
                  children: [
                    Text(
                      "Solicitudes de administrador:",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    FutureBuilder<List<dynamic>>(
                      future: dataSolicitudAdmin,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        if (snapshot.hasError)
                          return Text(
                            "Error al cargar solicitudes.",
                            style: GoogleFonts.montserrat(fontSize: 18),
                          );
                        final solicitudes = snapshot.data ?? [];
                        if (solicitudes.isNotEmpty)
                          return Text(
                            "Solicitud enviada o ya evaluada",
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        return Column(
                          children: [
                            Text(
                              "No has enviado solicitudes para ser admin.",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await Supabase.instance.client
                                      .from('solicitudesAdmin')
                                      .insert({
                                        'emailSolicitante': user?.email,
                                        'estado': 'Pendiente',
                                        'nombreCompleto': nombreUsuario,
                                      });
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Solicitud enviada!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text("Solicitar Permisos"),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mensajeVacio(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(texto, style: GoogleFonts.inter(fontSize: 16)),
    );
  }
}
