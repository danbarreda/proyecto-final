import 'dart:math';
import 'package:biblioteca_unimet/pages/Adminpage.dart';
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
  Map<String, List<String>> filtrosActivos = {"carreras": [], "estados": []};
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
      if (publicacion.isNotEmpty)
        query = query.ilike('titulo', '%$publicacion%');
      if (filtrosActivos["carreras"]!.isNotEmpty)
        query = query.contains('categoria', filtrosActivos["carreras"]!);
      if (filtrosActivos["estados"]!.isNotEmpty)
        query = query.inFilter('estadofisico', filtrosActivos["estados"]!);

      librosFetched = await query;
      if (!mounted) return;
      setState(() {
        libros.clear();
        for (var item in librosFetched) {
          dynamic autorData = item["autor"];
          List<String> autoresArray = (autorData is List)
              ? List<String>.from(autorData.map((e) => e.toString()))
              : (autorData is String ? [autorData] : ["Desconocido"]);
          dynamic imagenesData = item["imagenesurl"];
          String imagenString =
              (imagenesData is List && imagenesData.isNotEmpty)
              ? imagenesData[0].toString()
              : (imagenesData is String ? imagenesData : "");

          libros.add(
            Libro(
              id: item["id"]?.toString() ?? "",
              propietarioid: (item["propietarioid"]?.toString() ?? "").trim(),
              titulo: item["titulo"]?.toString() ?? "Sin Título",
              autor: autoresArray,
              imagenUrl: imagenString,
              carrera: item["materia"]?.toString() ?? "General",
              descripcion:
                  item["descripcion"]?.toString() ?? "Sin descripción.",
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
                  children: [
                    Text(
                      "Bienvenido a Samanet",
                      style: GoogleFonts.montserrat(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rol: ${widget.role[0].toUpperCase()}${widget.role.substring(1)}",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    widget.role.trim().toLowerCase() == "admin"
                        ? ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PantallaAdmin(),
                              ),
                            ),
                            icon: const Icon(Icons.admin_panel_settings),
                            label: const Text("Panel Admin"),
                          )
                        : Text(
                            "¿Quieres ser administrador? Solicítalo en Actividad",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              hintText: "Buscar una publicación",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  onFilterApplied: (lista) {
                    setState(() {
                      filtrosActivos = lista;
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
                        itemBuilder: (context, index) =>
                            buildLibroCard(context, libros[index], widget.role),
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
  final Map<String, List<String>> filtrosActivos;
  final String role;
  const MainPageBodyMovil({
    super.key,
    required this.filtrosActivos,
    required this.role,
  });
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
    if (oldWidget.filtrosActivos != widget.filtrosActivos) buscarPublicacion();
  }

  void buscarPublicacion() async {
    publicacion = publicacionController.text.trim();
    List<dynamic> librosFetched = [];
    try {
      var query = Supabase.instance.client.from("materialAcademico").select();
      if (publicacion.isNotEmpty)
        query = query.ilike('titulo', '%$publicacion%');
      if (widget.filtrosActivos["carreras"]!.isNotEmpty)
        query = query.contains('categoria', widget.filtrosActivos["carreras"]!);
      if (widget.filtrosActivos["estados"]!.isNotEmpty)
        query = query.inFilter(
          'estadofisico',
          widget.filtrosActivos["estados"]!,
        );

      librosFetched = await query;
      if (!mounted) return;
      setState(() {
        libros.clear();
        for (var item in librosFetched) {
          dynamic autorData = item["autor"];
          List<String> autoresArray = (autorData is List)
              ? List<String>.from(autorData.map((e) => e.toString()))
              : (autorData is String ? [autorData] : ["Desconocido"]);
          dynamic imagenesData = item["imagenesurl"];
          String imagenString =
              (imagenesData is List && imagenesData.isNotEmpty)
              ? imagenesData[0].toString()
              : (imagenesData is String ? imagenesData : "");

          libros.add(
            Libro(
              id: item["id"]?.toString() ?? "",
              propietarioid: (item["propietarioid"]?.toString() ?? "").trim(),
              titulo: item["titulo"]?.toString() ?? "Sin Título",
              autor: autoresArray,
              imagenUrl: imagenString,
              carrera: item["materia"]?.toString() ?? "General",
              descripcion:
                  item["descripcion"]?.toString() ?? "Sin descripción.",
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
                  children: [
                    Text(
                      "Bienvenido a Samanet",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rol: ${widget.role[0].toUpperCase()}${widget.role.substring(1)}",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (widget.role.trim().toLowerCase() == "admin")
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PantallaAdmin(),
                          ),
                        ),
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text("Panel Admin"),
                      ),
                    const SizedBox(height: 10),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          hintText: "Buscar una publicación",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: buscarPublicacion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade400,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Buscar",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
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
                        onPressed: () => Scaffold.of(context).openDrawer(),
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
                const SizedBox(height: 100),
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
  Map<String, List<String>> filtrosActivos = {"carreras": [], "estados": []};

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
        appBar: const BarraSuperiorMovil(),
        drawer: Drawer(
          width: 280,
          child: FilterSidebar(
            onFilterApplied: (lista) {
              setState(() {
                filtrosActivos = lista;
              });
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            MainPageBodyMovil(
              filtrosActivos: filtrosActivos,
              role: widget.role,
            ),
            Positioned(
              left: screenWidth - 200 < 300 ? (screenWidth - 300) / 2 : 100,
              bottom: 20,
              child: NavBar(role: widget.role),
            ),
          ],
        ),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Inicia sesión.")));
      return;
    }
    if (await yaSolicitado(user.email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ya solicitado.")));
      return;
    }
    if (user.email!.trim() == libro.propietarioid.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Es tu propio libro.")));
      return;
    }
    try {
      await Supabase.instance.client.from('solicitudes').insert({
        'libro_id': libro.id,
        'usuario_correo': user.email!.trim(),
        'propietario_correo': libro.propietarioid.trim(),
        'estado': 'Solicitado',
        'titulo_libro': libro.titulo,
        'imagen_libro': libro.imagenUrl,
        'fecha_solicitud': DateTime.now().toIso8601String(),
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Solicitud enviada"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleLibroPage(libro: libro, role: role),
      ),
    ),
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
                      errorBuilder: (ctx, err, st) => Container(
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.blueGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        libro.propietarioid.isNotEmpty
                            ? libro.propietarioid
                            : 'Desconocido',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
