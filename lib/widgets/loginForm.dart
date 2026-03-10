import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

import '../pages/mainpage.dart';
import '../pages/singUpPage.dart';
import '../pages/Adminpage.dart';

void showErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Error:"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String correo = "";
  String password = "";
  bool domvalidated = false;
  bool passvalidated = false;
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscureText = true;

  void showPassword() {
    setState(() {
      isObscureText = !isObscureText;
    });
  }

  // funcion helper porque no puedo pasarle el buildcontext desde la funcion asincrona
  void mostrarError(String mensaje) {
    showErrorMessage(context, mensaje);
  }

  // Función de Daniel para navegar
  dynamic navigate(BuildContext context, dynamic page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  void login() async {
    correo = correoController.text.trim();
    password = passwordController.text.trim();
    final db = FirebaseFirestore.instance;

    if (FirebaseAuth.instance.currentUser != null) {
      String currentEmail = FirebaseAuth.instance.currentUser!.email!;

      if (currentEmail == 'admin@unimet.edu.ve') {
        navigate(context, const PantallaAdmin());
        return;
      }

      final docRef = db.collection("users").doc(currentEmail);
      docRef.get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          String role = data["role"] ?? "user";
          navigate(context, MainPage(role: role));
        } else {
          navigate(context, const MainPage(role: "user"));
        }
      }, onError: (e) => print("Error getting document: $e"));
      return;
    }

    if (correo.isNotEmpty && password.isNotEmpty) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: correo, password: password);
        User? user = credential.user;

        if (user != null) {
          if (!mounted) return;

          if (correo == 'admin@unimet.edu.ve') {
            navigate(context, const PantallaAdmin());
            return;
          }
          final docRef = db.collection("users").doc(correo);
          docRef.get().then((DocumentSnapshot doc) {
            if (doc.exists) {
              final data = doc.data() as Map<String, dynamic>;
              String role = data["role"] ?? "user";
              print("Rol: $role");
              navigate(context, MainPage(role: role));
            } else {
              navigate(context, const MainPage(role: "user"));
            }
          }, onError: (e) => print("Error getting document: $e"));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          mostrarError('No se encontró un usuario con ese correo.');
        } else if (e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          mostrarError('Contraseña o credenciales incorrectas.');
        } else {
          mostrarError('Error: ${e.message}');
        }
      } catch (e) {
        mostrarError('Ocurrió un error inesperado al iniciar sesión.');
      }
    } else {
      mostrarError('Por favor, llena todos los campos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 600;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 15,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.deepOrange, width: 2.0),
            ),
            child: Text(
              "Iniciar Sesión",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w900,
                color: Colors.deepOrange,
              ),
            ),
          ),
          SizedBox(
            width: isDesktop ? min(screenWidth * 0.5, 600) : screenWidth - 100,
            child: TextField(
              controller: correoController,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 110, 108, 108),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.5),
                  borderSide: BorderSide(
                    color: Colors.deepOrange.shade400,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.5),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                hintText: "Nombre de usuario o Correo",
                hoverColor: Colors.lightBlue.shade100,
              ),
            ),
          ),
          SizedBox(
            width: isDesktop ? min(screenWidth * 0.5, 600) : screenWidth - 100,
            child: TextField(
              obscureText: isObscureText,
              controller: passwordController,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 110, 108, 108),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscureText = !isObscureText;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.5),
                  borderSide: BorderSide(
                    color: Colors.deepOrange.shade400,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.5),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                hintText: "Contraseña",
                hoverColor: const Color.fromARGB(255, 233, 205, 196),
              ),
            ),
          ),
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿No tienes cuenta?",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => {navigate(context, const SignUpPage())},
                child: Text(
                  "Regístrate aquí",
                  style: GoogleFonts.inter(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async => login(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange.shade400,
              foregroundColor: Colors.white,
            ),
            child: Text(
              "Acceder",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
