import 'package:biblioteca_unimet/widgets/popups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrearPublicacionForm extends StatefulWidget {
  const CrearPublicacionForm({super.key});

  @override
  State<CrearPublicacionForm> createState() => _CrearPublicacionFormState();
}

class _CrearPublicacionFormState extends State<CrearPublicacionForm> {
  final tituloController = TextEditingController();
  final autorController = TextEditingController();
  final materiaController = TextEditingController();
  final yearController = TextEditingController();
  final categoriaController = TextEditingController();
  final estadoController = TextEditingController();
  final descController = TextEditingController();
  final picker = ImagePicker();
  String publicUrl = "";
  final List<String> opcionesEstado = [
    "Nuevo",
    "Usado Bueno",
    "Usado Regular",
    "Digital",
  ];

  @override
  void dispose() {
    tituloController.dispose();
    autorController.dispose();
    materiaController.dispose();
    yearController.dispose();
    categoriaController.dispose();
    estadoController.dispose();
    descController.dispose();
    super.dispose();
  }

  String quitarAcentos(String texto) {
    const conAcento = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÍÎÏíîïÙÚÛÜùúûüÑñÇç';
    const sinAcento = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeIIIiiiUUUUuuuuNnCc';
    String resultado = texto;
    for (int i = 0; i < conAcento.length; i++) {
      resultado = resultado.replaceAll(conAcento[i], sinAcento[i]);
    }
    return resultado;
  }

  void subirImagen() async {
    String titulo = tituloController.text;
    String year = yearController.text;
    if (titulo.isEmpty || year.isEmpty) {
      showErrorMessage(
        context,
        "Por favor inserte primero el título y el año de publicación antes de insertar la portada",
      );
      return;
    }

    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      final bytes = await imagen.readAsBytes();

      String tituloSinAcentos = quitarAcentos(titulo);
      String tituloLimpio = tituloSinAcentos.replaceAll(' ', '_');
      final fileName = "${tituloLimpio}_$year.jpg";

      try {
        await Supabase.instance.client.storage
            .from('fotos')
            .uploadBinary(fileName, bytes);
        publicUrl = Supabase.instance.client.storage
            .from('fotos')
            .getPublicUrl(fileName);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Portada subida con éxito!"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        showErrorMessage(context, 'Error inesperado: $e');
      }
    }
  }

  void publicar() async {
    String titulo = tituloController.text;
    String autor = autorController.text;
    String materia = materiaController.text;
    String year = yearController.text;
    String categoria = categoriaController.text;
    String estado = estadoController.text;
    String descripcion = descController.text;

    if (titulo.isEmpty ||
        autor.isEmpty ||
        materia.isEmpty ||
        year.isEmpty ||
        categoria.isEmpty ||
        estado.isEmpty ||
        descripcion.isEmpty ||
        publicUrl.isEmpty) {
      showErrorMessage(
        context,
        "Por favor llene todos los campos y suba la portada.",
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      showErrorMessage(context, "Error: Usuario no autenticado correctamente.");
      return;
    }

    try {
      final validacion = await Supabase.instance.client
          .from("materialAcademico")
          .select()
          .eq("titulo", titulo)
          .eq("propietarioid", currentUser.email!);

      if (validacion.isNotEmpty) {
        if (!mounted) return;
        showErrorMessage(
          context,
          "Ya tienes un libro publicado con este mismo título.",
        );
        return;
      }

      await Supabase.instance.client.from("materialAcademico").insert({
        "propietarioid": currentUser.email,
        "titulo": titulo,
        "descripcion": descripcion,
        "categoria": [categoria],
        "materia": materia,
        "estadofisico": estado,
        "disponible": true,
        "imagenesurl": [publicUrl],
        "autor": [autor],
      });
      if (!mounted) return;
      showMessageDialog(
        context,
        "¡Libro insertado exitosamente!",
        "Gracias!",
        secondaryMessage:
            "Si no visualiza el material, refresque la página principal",
      );
      Navigator.pop(context);
    } catch (e) {
      showErrorMessage(context, 'Error inesperado: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 700;
    double formWidth = isDesktop ? 700 : screenWidth - 40;

    return Container(
      width: formWidth,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Crear Nueva Publicación",
              style: GoogleFonts.montserrat(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),

          _buildField("Título de la Publicación:", tituloController),
          _buildField("Autor(es):", autorController),

          Row(
            children: [
              Expanded(child: _buildField("Materia:", materiaController)),
              const SizedBox(width: 20),
              Expanded(
                child: _buildField("Año de Publicación:", yearController),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: _buildField("Categoría:", categoriaController)),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDropdownField(
                  "Estado de conservación:",
                  estadoController,
                  opcionesEstado,
                ),
              ),
            ],
          ),

          _buildField("Descripción:", descController, maxLines: 5),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async => subirImagen(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 85, 110, 202),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                "Subir Portada",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: () async => publicar(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Publicar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: "Campo obligatorio",
                child: Text(
                  "*",
                  style: GoogleFonts.inter(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    TextEditingController controller,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              const Tooltip(
                message: "Campo obligatorio",
                child: Text(
                  "*",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.text.isEmpty ? null : controller.text,
                hint: const Text("Seleccione"),
                isExpanded: true,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    controller.text = newValue!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
