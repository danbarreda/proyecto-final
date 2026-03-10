class Libro {
  final String id;
  final String titulo;
  final List<String> autor;
  final String imagenUrl;
  final String carrera;
  final String descripcion;
  final String estadoFisico;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.imagenUrl,
    required this.carrera,
    required this.descripcion,
    required this.estadoFisico,
  });
}

List<Libro> librosPrueba = [];
