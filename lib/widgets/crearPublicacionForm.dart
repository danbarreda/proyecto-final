import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CrearPublicacionForm extends StatefulWidget {
  const CrearPublicacionForm({super.key});

  @override
  State<CrearPublicacionForm> createState() => _CrearPublicacionFormState();
}

class _CrearPublicacionFormState extends State<CrearPublicacionForm> {
  final tituloController = TextEditingController();
  final autorController = TextEditingController();
  final materialController = TextEditingController();
  final anioController = TextEditingController();
  final categoriaController = TextEditingController();
  final estadoController = TextEditingController();
  final descController = TextEditingController();

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
              Expanded(child: _buildField("Tipo de Material:", materialController)),
              const SizedBox(width: 20),
              Expanded(child: _buildField("Año de Publicación:", anioController)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _buildField("Categoría:", categoriaController)),
              const SizedBox(width: 20),
              Expanded(child: _buildField("Estado de conservación:", estadoController)),
            ],
          ),

          _buildField("Descripción:", descController, maxLines: 5),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 85, 110, 202),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text("Subir Portada", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),

          const SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Publicar",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, 
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}