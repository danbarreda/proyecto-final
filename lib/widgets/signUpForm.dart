import 'dart:math';
import 'package:biblioteca_unimet/pages/mainpage.dart';
import 'package:biblioteca_unimet/widgets/popups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String correo = "";
  String password = "";
  String cedulaStr = "";
  String nombresApellidos = "";
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final cedulaController = TextEditingController();
  final nombresApellidosController = TextEditingController();
  bool isObscureText = true;
  final db = FirebaseFirestore.instance;
  late final usersCollection = db.collection("users");

  void navigate(dynamic page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  void showPassword() {
    setState(() {
      isObscureText = !isObscureText;
    });
  }

  void crearUsuario() async {
    correo = correoController.text.trim();
    password = passwordController.text;
    nombresApellidos = nombresApellidosController.text;
    cedulaStr = cedulaController.text;
    int? cedulaParsed = int.tryParse(cedulaStr);

    if (correo.isEmpty) {
      if (!mounted) return;
      showErrorMessage(context, "El campo correo no debe estar vacío.");
      return;
    }

    if (password.isEmpty) {
      if (!mounted) return;
      showErrorMessage(context, "La contraseña no debe estar vacía.");
      return;
    }

    if (cedulaStr.isEmpty) {
      if (!mounted) return;
      showErrorMessage(context, "La cédula no debe estar vacía.");
      return;
    }

    if (cedulaParsed == null) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "La cédula no puede contener puntos ni letras, deben ser solamente caracteres numéricos\nEjemplo: 25867420",
      );
      return;
    }

    if (nombresApellidos.isEmpty) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "Los nombres y apellidos no deben estar vacíos.",
      );
      return;
    }

    if (!correo.contains("@")) {
      if (!mounted) return;
      showErrorMessage(context, "Correo inválido. Debe contener '@'.");
      return;
    }

    List<String> parts = correo.split("@");
    if (parts.length != 2) {
      if (!mounted) return;
      showErrorMessage(context, "Correo inválido.");
      return;
    }

    String domain = parts[1].toLowerCase();
    bool validDomain =
        domain == "correo.unimet.edu.ve" || domain == "unimet.edu.ve";
    if (!validDomain) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "El correo debe pertenecer a la familia UNIMET: ejemplo@correo.unimet.edu.ve o ejemplo@unimet.edu.ve",
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: password,
      );

      await usersCollection.doc(correo).set({
        "role": "user",
        "cedula": cedulaStr,
        "nombre": nombresApellidos,
      });

      if (!mounted) return;
      navigate(const MainPage(role: "user"));
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'weak-password') {
        showErrorMessage(
          context,
          "La contraseña es muy corta o sencilla. Debe tener al menos 6 caracteres.",
        );
      } else if (e.code == 'email-already-in-use') {
        showErrorMessage(
          context,
          "Este correo ya está registrado en el sistema.",
        );
      } else {
        showErrorMessage(context, "Ocurrió un error: ${e.message}");
      }
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "No se pudo crear la cuenta. Inténtalo de nuevo.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 600;
    TextStyle textStyle = GoogleFonts.inter(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nombres y Apellidos:", style: textStyle),
                const SizedBox(height: 10),
                _buildTextField(
                  nombresApellidosController,
                  isDesktop,
                  screenWidth,
                  false,
                ),
                const SizedBox(height: 20),
                Text("Cédula de Identidad:", style: textStyle),
                const SizedBox(height: 10),
                _buildTextField(
                  cedulaController,
                  isDesktop,
                  screenWidth,
                  false,
                ),
                const SizedBox(height: 20),
                Text("Correo Electrónico Institucional:", style: textStyle),
                const SizedBox(height: 10),
                _buildTextField(
                  correoController,
                  isDesktop,
                  screenWidth,
                  false,
                ),
                const SizedBox(height: 20),
                Text("Contraseña:", style: textStyle),
                const SizedBox(height: 10),
                _buildTextField(
                  passwordController,
                  isDesktop,
                  screenWidth,
                  true,
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => crearUsuario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Acceder",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    bool isDesktop,
    double screenWidth,
    bool isPassword,
  ) {
    return SizedBox(
      width: isDesktop ? min(screenWidth * 0.5, 600) : screenWidth - 100,
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isObscureText : false,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6E6C6C),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: showPassword,
                )
              : null,
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
        ),
      ),
    );
  }
}
