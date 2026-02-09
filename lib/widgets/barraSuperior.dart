import 'package:biblioteca_unimet/pages/homepage.dart';
import 'package:biblioteca_unimet/pages/singUpPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class BarraSuperiorDesktop extends StatelessWidget implements PreferredSizeWidget {
  
  dynamic navigate(BuildContext context, dynamic page){
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (BuildContext context) => page,
    ),);
  }

  final ButtonStyle actionButtonStyle = TextButton.styleFrom(backgroundColor:Colors.deepOrange.shade400, foregroundColor: Colors.white);
  final TextStyle actionText = GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white,);

  BarraSuperiorDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        title: InkWell(
          onTap: () => navigate(context, LandingPage()),
          child: Text(
          "SAMANET.",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontStyle: FontStyle.italic,
          ),)
        ),
        actions: [
          ElevatedButton(onPressed:() => navigate(context, SignUpPage()), style: actionButtonStyle, child: Text("Registrarse", style: actionText, ),)
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
}
class BarraSuperiorMovil extends StatelessWidget implements PreferredSizeWidget {
  const BarraSuperiorMovil({super.key});

  
  dynamic navigate(BuildContext context, dynamic page){
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (BuildContext context) => page,
    ),);
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: InkWell(
          onTap: () => navigate(context, LandingPage()),
          child: Text(
          "SAMANET.",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontStyle: FontStyle.italic,
          ),)
        ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
}

class BarraSuperiorMovilHome extends StatelessWidget implements PreferredSizeWidget {
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
            color: Colors.deepOrange,
            fontStyle: FontStyle.italic,
          ),)
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
}

class BarraSuperiorDesktopHome extends StatelessWidget implements PreferredSizeWidget {
  const BarraSuperiorDesktopHome({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "SAMANET.",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontStyle: FontStyle.italic,
          ),)
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
}