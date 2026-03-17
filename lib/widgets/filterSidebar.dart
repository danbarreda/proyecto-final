import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterSidebar extends StatefulWidget {
  final Function(Map<String, List<String>>) onFilterApplied;
  const FilterSidebar({super.key, required this.onFilterApplied});

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  final Map<String, bool> _carreras = {
    "Ciencias Administrativas": false,
    "Comunicación Social": false,
    "Contaduría Pública": false,
    "Derecho": false,
    "Economía Empresarial": false,
    "Educación": false,
    "Ingeniería de Sistemas": false,
    "Psicología": false,
    "Estudios liberales": false,
    "Ingeniería Mecánica": false,
    "Idiomas modernos": false,
    "Ingeniería Civil": false,
    "Ingeniería Electrica": false,
    "Ingenieria de Produccion": false,
    "Ingeniería Quimica": false,
    "Matematicas Industriales": false,
  };

  final Map<String, bool> _estados = {
    "Nuevo": false,
    "Usado Bueno": false,
    "Usado Regular": false,
    "Digital": false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 117, 148, 227),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filtros Avanzados",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Carrera / Materia",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: ListView(
              children: _carreras.keys
                  .map((nombre) => _crearCheckbox(nombre, _carreras))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Estado Físico",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: ListView(
              children: _estados.keys
                  .map((nombre) => _crearCheckbox(nombre, _estados))
                  .toList(),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Map<String, List<String>> filtros = {
                  "carreras": _carreras.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList(),
                  "estados": _estados.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList(),
                };
                widget.onFilterApplied(filtros);
              },
              child: const Text("Aplicar Filtros"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearCheckbox(String llave, Map<String, bool> mapa) {
    return CheckboxListTile(
      title: Text(
        llave,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      value: mapa[llave],
      activeColor: Colors.orange,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? valor) {
        setState(() => mapa[llave] = valor!);
      },
    );
  }
}
