import '../pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/misSolicitudespage.dart';
import '../pages/crearPublicacionPage.dart';

class BarraSuperiorDesktop extends StatelessWidget
    implements PreferredSizeWidget {
  BarraSuperiorDesktop({super.key});

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Contribuir con SAMANET",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00235E),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tu aporte voluntario nos ayuda a mantener y mejorar esta plataforma colaborativa para reducir la brecha de acceso al material educativo en toda la comunidad Unimetana.",
                style: GoogleFonts.inter(fontSize: 16),
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Redirigiendo a la pasarela de pago (PayPal)...",
                        ),
                        backgroundColor: Color(0xFF0079C1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment),
                  label: Text(
                    "Donar con PayPal",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0079C1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cerrar",
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CrearPublicacionPage(),
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
              MaterialPageRoute(builder: (context) => MisSolicitudesPage()),
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

        ElevatedButton(
          onPressed: () {
            navigate(context, const LandingPage());
          },
          style: actionButtonStyle,
          child: Text("Salir", style: actionText),
        ),
        const SizedBox(width: 20),
      ],
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
