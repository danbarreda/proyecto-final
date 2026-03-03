import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterSidebar extends StatefulWidget {
  const FilterSidebar({super.key});
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
    "Ingeniería Mecanica": false,
    "Idiomas modernos": false,
    "Ingeniería Civil": false,
    "Ingeniería Electrica": false,
    "Ingenieria de Produccion": false,
    "Ingeniería Quimica": false,
    "Matematicas Industriales": false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 117, 148, 227),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            "Filtrar por Carrera",
            style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _carreras.keys
                  .map((nombre) => _crearCheckbox(nombre))
                  .toList(),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => print(_carreras),
              child: const Text("Aplicar Filtro"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearCheckbox(String carrera) {
    return CheckboxListTile(
      title: Text(carrera, style: const TextStyle(fontSize: 14)),
      value: _carreras[carrera],
      controlAffinity:
          ListTileControlAffinity.leading,
      onChanged: (bool? valor) {
        setState(() => _carreras[carrera] = valor!); 
      },
    );
  }
}
