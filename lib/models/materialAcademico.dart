class materialAcademico {
  final String id; 
  final String propietarioid; 
  final String titulo; 
  final String descripcion; 
  final List<String> categoria; 
  final String materia;
  final dynamic estadofisico; 
  final bool disponible;
  final dynamic fechapublicacion; 
  final List<String> imagenesurl;
  final String autor;

  materialAcademico({
    required this.id, 
    required this.propietarioid, 
    required this.titulo, 
    required this.descripcion, 
    required this.categoria, 
    required this.materia,
    required this.estadofisico, 
    required this.disponible,
    required this.fechapublicacion, 
    required this.imagenesurl,
    required this.autor
  }
  );
}