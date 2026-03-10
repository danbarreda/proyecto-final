import 'dart:math';
import 'package:biblioteca_unimet/pages/Adminpage.dart';
import 'package:biblioteca_unimet/pages/crearPublicacionPage.dart';
import 'package:biblioteca_unimet/widgets/barraSuperior.dart';
import 'package:biblioteca_unimet/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblioteca_unimet/widgets/filterSidebar.dart';
import 'package:biblioteca_unimet/models/libro.dart';
import 'detalleLibroPage.dart';

class MainPageBodyDesktop extends StatefulWidget {
  final String role;
  const MainPageBodyDesktop({super.key, required this.role});

  @override
  State<MainPageBodyDesktop> createState() => _MainPageBodyDesktopState();
}

class _MainPageBodyDesktopState extends State<MainPageBodyDesktop> {
  final publicacionController = TextEditingController();
  String publicacion = "";
  List<Libro> libros = [];
  List<String> filtrosActivos = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    buscarPublicacion();
  }

  void buscarPublicacion() async {
    publicacion = publicacionController.text.trim();
    List<dynamic> librosFetched = [];

    try {
      var query = Supabase.instance.client.from("materialAcademico").select();

      if (publicacion.isNotEmpty) {
        query = query.ilike('titulo', '%$publicacion%');
      }

      if (filtrosActivos.isNotEmpty) {
        query = query.contains('categoria', filtrosActivos);
      }

      librosFetched = await query;

      if (!mounted) return;

      setState(() {
        libros.clear();
        for (var item in librosFetched) {
          String tituloItem = item["titulo"]?.toString() ?? "Sin Título";

          dynamic autorData = item["autor"];
          List<String> autoresArray = [];
          if (autorData is String) {
            autoresArray = [autorData];
          } else if (autorData is List) {
            autoresArray = List<String>.from(
              autorData.map((e) => e.toString()),
            );
          } else {
            autoresArray = ["Desconocido"];
          }

          dynamic imagenesData = item["imagenesurl"];
          String imagenString = "";
          if (imagenesData is List && imagenesData.isNotEmpty) {
            imagenString = imagenesData[0].toString();
          } else if (imagenesData is String) {
            imagenString = imagenesData;
          }

          libros.add(
            Libro(
              id: item["id"]?.toString() ?? "",
              titulo: tituloItem,
              autor: autoresArray,
              imagenUrl: imagenString,
              carrera: item["materia"]?.toString() ?? "General",
              descripcion:
                  item["descripcion"]?.toString() ??
                  "Sin descripción disponible.",
              estadoFisico:
                  item["estadofisico"]?.toString() ?? "No especificado",
            ),
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: ListView(
        controller: scrollController,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 350,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/biblioteca.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Column( 
                  spacing: 10,
                  children: [
                    Text(
                      "Bienvenido a Samanet",
                      style: GoogleFonts.montserrat(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Rol: ${widget.role[0].toUpperCase()}${widget.role.substring(1)}",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  if (widget.role.trim().toLowerCase() == "admin")
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const PantallaAdmin()),
                          );
                        },
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text("Panel Admin"),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: min(screenWidth * 0.5, 600),
                        child: TextField(
                          controller: publicacionController,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 110, 108, 108),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.5),
                              borderSide: BorderSide(
                                color: Colors.deepOrange.shade400,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.5),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                            hintText: "Buscar una publicación",
                            hoverColor: Colors.lightBlue.shade100,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: buscarPublicacion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade400,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "Buscar",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                    ),
              
                  ]
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                height: 800,
                child: FilterSidebar(
                  onFilterApplied: (listaSeleccionada) {
                    setState(() {
                      filtrosActivos = listaSeleccionada;
                    });
                    buscarPublicacion();
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Publicaciones Disponibles",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF00235E),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: libros.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (screenWidth / 300 >= 2.7) ? 3 : 2,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          return buildLibroCard(context, libros[index], widget.role);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MainPageBodyMovil extends StatefulWidget {
  final List<String> filtrosActivos;
  final String role;
  const MainPageBodyMovil({super.key, required this.filtrosActivos, required this.role});

  @override
  State<MainPageBodyMovil> createState() => _MainPageBodyMovilState();
}

class _MainPageBodyMovilState extends State<MainPageBodyMovil> {
  String publicacion = "";
  final publicacionController = TextEditingController();
  List<Libro> libros = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    buscarPublicacion();
  }

  @override
  void didUpdateWidget(covariant MainPageBodyMovil oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filtrosActivos != widget.filtrosActivos) {
      buscarPublicacion();
    }
  }

  void buscarPublicacion() async {
    publicacion = publicacionController.text.trim();
    List<dynamic> librosFetched = [];

    try {
      var query = Supabase.instance.client.from("materialAcademico").select();

      if (publicacion.isNotEmpty) {
        query = query.ilike('titulo', '%$publicacion%');
      }

      if (widget.filtrosActivos.isNotEmpty) {
        query = query.contains('categoria', widget.filtrosActivos);
      }

      librosFetched = await query;

      if (!mounted) return;

      setState(() {
        libros.clear();
        for (var item in librosFetched) {
          String tituloItem = item["titulo"]?.toString() ?? "Sin Título";

          dynamic autorData = item["autor"];
          List<String> autoresArray = [];
          if (autorData is String) {
            autoresArray = [autorData];
          } else if (autorData is List) {
            autoresArray = List<String>.from(
              autorData.map((e) => e.toString()),
            );
          } else {
            autoresArray = ["Desconocido"];
          }

          dynamic imagenesData = item["imagenesurl"];
          String imagenString = "";
          if (imagenesData is List && imagenesData.isNotEmpty) {
            imagenString = imagenesData[0].toString();
          } else if (imagenesData is String) {
            imagenString = imagenesData;
          }

          libros.add(
            Libro(
              id: item["id"]?.toString() ?? "",
              titulo: tituloItem,
              autor: autoresArray,
              imagenUrl: imagenString,
              carrera: item["materia"]?.toString() ?? "General",
              descripcion:
                  item["descripcion"]?.toString() ??
                  "Sin descripción disponible.",
              estadoFisico:
                  item["estadofisico"]?.toString() ?? "No especificado",
            ),
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: ListView(
        controller: scrollController,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 400,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/biblioteca.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      "Bienvenido a Samanet",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Rol: ${widget.role[0].toUpperCase()}${widget.role.substring(1)}",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  if (widget.role.trim().toLowerCase() == "admin")
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const PantallaAdmin()),
                          );
                        },
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text("Panel Admin"),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.65,
                      child: TextField(
                        controller: publicacionController,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 110, 108, 108),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.5),
                            borderSide: BorderSide(
                              color: Colors.deepOrange.shade400,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.5),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          hintText: "Buscar una publicación",
                          hoverColor: Colors.lightBlue.shade100,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: buscarPublicacion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade400,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Buscar",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Publicaciones",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF00235E),
                      ),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Color(0xFF00235E),
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: libros.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) =>
                      buildLibroCard(context, libros[index], widget.role),
                ),
                SizedBox(height: 100,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final String role;

  const MainPage({super.key, required this.role});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> filtrosActivos = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 700) {
      return Scaffold(
        appBar: BarraSuperiorDesktop(role: widget.role),
        body: MainPageBodyDesktop(role: widget.role),
      );
    } else {
      return Scaffold(
        appBar: BarraSuperiorMovil(),
        drawer: Drawer(
          width: 280,
          child: FilterSidebar(
            onFilterApplied: (listaSeleccionada) {
              setState(() {
                filtrosActivos = listaSeleccionada;
              });
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack (
          children: [
            MainPageBodyMovil(filtrosActivos: filtrosActivos, role: widget.role),
            Positioned(
              left: 100,
              bottom: 20,
              child: NavBar(role: widget.role)
            )
          ]
        )
      );
    }
  }
}

Widget buildLibroCard(BuildContext context, Libro libro, String role) {

  Future<bool> yaSolicitado(String? email) async {
    final data = await Supabase.instance.client
      .from("solicitudes")
      .select("*")
      .eq("libro_id", libro.id)
      .eq("usuario_correo", email!);
      return data.isNotEmpty;
  }

  void solicitarLibroDirecto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inicia sesión para solicitar un libro.")),
      );
      return;
    }
    if (await yaSolicitado(user.email)){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ya has solicitado ese libro, puedes revisar su estado en 'Actividad'!")),
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
          content: Text("Error al solicitar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetalleLibroPage(libro: libro, role: role)),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: libro.imagenUrl.isNotEmpty
                  ? Image.network(
                      libro.imagenUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.book,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.book,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  libro.titulo,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  libro.autor.isNotEmpty ? libro.autor[0] : 'Desconocido',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: solicitarLibroDirecto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF37021),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Solicitar"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
