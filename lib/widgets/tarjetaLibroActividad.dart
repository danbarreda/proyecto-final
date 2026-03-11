import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TarjetaLibroActividad extends StatelessWidget {
  final String titulo;
  final String estado;
  final Color colorEstado;
  final String subtexto;
  final String imagenUrl;
  final bool esEntrante;
  final VoidCallback? onAceptar;
  final VoidCallback? onRechazar;
  final bool mostrarCalificar;
  final VoidCallback? onCalificar;

  const TarjetaLibroActividad({
    super.key,
    required this.titulo,
    required this.estado,
    required this.colorEstado,
    required this.subtexto,
    required this.imagenUrl,
    this.esEntrante = false,
    this.onAceptar,
    this.onRechazar,
    this.mostrarCalificar = false,
    this.onCalificar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      padding: const EdgeInsets.all(15),
      constraints: const BoxConstraints(maxWidth: 850),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imagenUrl.isNotEmpty
                ? Image.network(
                    imagenUrl,
                    width: 80,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          width: 80,
                          height: 110,
                          child: Icon(Icons.book, size: 50, color: Colors.grey),
                        ),
                  )
                : const SizedBox(
                    width: 80,
                    height: 110,
                    child: Icon(Icons.book, size: 50, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorEstado,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        estado,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  subtexto,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (esEntrante && estado.toLowerCase() == 'solicitado') ...[
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: onAceptar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Aceptar"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onRechazar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Rechazar"),
                      ),
                    ],
                  ),
                ],
                if (mostrarCalificar) ...[
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: onCalificar,
                    icon: const Icon(Icons.star, color: Colors.amber),
                    label: const Text("Calificar Intercambio"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[900],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
