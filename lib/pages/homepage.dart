

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return /*Column(
      children: [
        Text("Bienvenido a SamaNet!", textAlign: TextAlign.center, style: GoogleFonts.crimsonText(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.075 )),
        */
        // Placeholder por ahora, luego lo cambiare para que se vea bien :)
        ListView(
          shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
        Container(
          width: screenWidth,
          color: Colors.deepOrange.shade200,
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Column(
              children: [
              Text("Publica, busca y gestiona libros y material educativo \nde forma eficiente y centralizada", textAlign: TextAlign.center , style: GoogleFonts.cormorant(fontWeight: FontWeight.normal, fontSize: screenWidth * 0.025 ,)),
              Row(
                children: [
                  Column(
                    children: [
                      Text("-Un ecosistema colaborativo\n-Intercambio rapido, seguro y transparente", style: GoogleFonts.crimsonPro(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.02 )),
                      ElevatedButton.icon(onPressed: () => {print("Comience ahora")}, label: Text("Comience Ahora!", style: GoogleFonts.crimsonPro(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.02 )),)
                    ],
                  )

                ],
              )
              ]
            ),
        ),
        ),
        Container(
          width: screenWidth,
          color: Colors.indigo.shade300,
          child: Text("prueba"),
        ),
      ],
        );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("SAMANET.",
        selectionColor: Colors.deepOrange.shade400,
        textAlign: TextAlign.left,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
      ),
      body: Welcome(),

    );
  }
}