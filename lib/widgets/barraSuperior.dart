import '../pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/misSolicitudespage.dart';
import '../pages/crearPublicacionPage.dart';
import '../pages/contribucionPage.dart';

class BarraSuperiorDesktop extends StatelessWidget
    implements PreferredSizeWidget {
  final String role;
  BarraSuperiorDesktop({super.key, required this.role});

  bool isAdmin() {
    return role == "admin";
  }

  dynamic navigate(BuildContext context, dynamic page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.deepOrange.shade400,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  final TextStyle actionText = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  void _mostrarDialogoContribucion(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ContribucionPage(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actionsList = [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CrearPublicacionPage(role: role),
            ),
          );
        },
        style: actionButtonStyle,
        child: Text("Crear Publicación", style: actionText),
      ),
      const SizedBox(width: 10),

      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MisSolicitudesPage(role: role),
            ),
          );
        },
        style: actionButtonStyle,
        child: Text("Actividad", style: actionText),
      ),
      const SizedBox(width: 10),

      ElevatedButton(
        onPressed: () => _mostrarDialogoContribucion(context),
        style: actionButtonStyle,
        child: Text("Contribuir", style: actionText),
      ),
      const SizedBox(width: 10),
    ];
    return AppBar(
      backgroundColor: Colors.white,
      title: InkWell(
        onTap: () => navigate(context, const LandingPage()),
        child: Text(
          "SAMANET.",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w900,
            color: Colors.deepOrange,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      actions: actionsList,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BarraSuperiorMovil extends StatelessWidget
    implements PreferredSizeWidget {
  const BarraSuperiorMovil({super.key});

  dynamic navigate(BuildContext context, dynamic page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: InkWell(
        onTap: () => navigate(context, const LandingPage()),
        child: Text(
          "SAMANET.",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w900,
            color: Colors.deepOrange,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BarraSuperiorMovilHome extends StatelessWidget
    implements PreferredSizeWidget {
  const BarraSuperiorMovilHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "SAMANET.",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.grey[300],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BarraSuperiorDesktopHome extends StatelessWidget
    implements PreferredSizeWidget {
  const BarraSuperiorDesktopHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "SAMANET.",
        textAlign: TextAlign.left,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[300],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
