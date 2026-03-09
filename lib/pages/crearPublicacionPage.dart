import 'package:flutter/material.dart';
import '../widgets/crearPublicacionForm.dart';
import '../widgets/barraSuperior.dart'; 

class CrearPublicacionPage extends StatelessWidget {
  const CrearPublicacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: BarraSuperiorDesktop(), 
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/biblioteca.png"), 
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: CrearPublicacionForm(),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 40,
            child: Text(
              "Copyright © 2026 – Universidad Metropolitana.\nTodos los derechos reservados",
              style: TextStyle(
                color: Colors.white, 
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}