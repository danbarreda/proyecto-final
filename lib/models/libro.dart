class Libro {
  final String titulo;
  final String autor;
  final String imagenUrl;
  final String carrera;

  Libro({
    required this.titulo,
    required this.autor,
    required this.imagenUrl,
    required this.carrera,
  });
}

// Lista de prueba 
List<Libro> librosPrueba = [
  Libro(titulo: "Cálculo I", autor: "Daniela Urdaneta", carrera: "Ingeniería", imagenUrl: "assets/images/libro1.png"),
  Libro(titulo: "Física Vol. 1", autor: "Daniel Barreda", carrera: "Ingeniería", imagenUrl: "assets/images/libro2.png"),
  Libro(titulo: "Administración", autor: "Maria F Ballesteros", carrera: "Ciencias Administrativas", imagenUrl: "assets/images/libro3.png"),
  Libro(titulo: "Derecho Civil", autor: "Giovanni Zarbo", carrera: "Derecho", imagenUrl: "assets/images/libro4.png"),
];