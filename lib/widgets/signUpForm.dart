import 'dart:math';
import 'package:biblioteca_unimet/pages/mainpage.dart';
import 'package:biblioteca_unimet/widgets/popups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

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
  bool domvalidated = false;
  bool passvalidated = false;
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final cedulaController = TextEditingController();
  final nombresApellidosController = TextEditingController();
  bool isObscureText = true;
  final db = FirebaseFirestore.instance;
  late final usersCollection = db.collection("users");

  dynamic navigate(dynamic page){
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (BuildContext context) => page,
    ),);
  }

  void showPassword(){
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
      showErrorMessage(context, "El campo correo no debe estar vacío.");
      return;
    }

    if (password.isEmpty) {
      showErrorMessage(context, "La contraseña no debe estar vacía.");
      return;
    }

    if (cedulaStr.isEmpty) {
      showErrorMessage(context, "La cedula no debe estar vacía.");
      return;
    }

    if (cedulaParsed == null){
      showErrorMessage(context, "La cedula no puede contener puntos ni letras, deben ser solamente caracteres numericos\nEjemplo: 25867420");
      return;
    }

    if (nombresApellidos.isEmpty) {
      showErrorMessage(context, "Los nombres y apellidos no deben estar vacíos.");
      return;
    }

    if (!correo.contains("@")) {
      showErrorMessage(context, "Correo inválido. Debe contener '@'.");
      return;
    }

    List<String> parts = correo.split("@");
    if (parts.length != 2) {
      showErrorMessage(context, "Correo inválido.");
      return;
    }

    String domain = parts[1].toLowerCase();
    bool validDomain =
      domain == "correo.unimet.edu.ve" || domain == "unimet.edu.ve";
    if (!validDomain) {
      showErrorMessage(
        context,
        "El correo debe pertenecer a la familia UNIMET: ejemplo@correo.unimet.edu.ve o ejemplo@unimet.edu.ve",
      );
      return;
    }

    //logica con firebase y redireccion a mainpage
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: password,
      );
      print("$credential");
      usersCollection.doc(correo).set(
        {
          "role": "user",
          "cedula": cedulaStr,
        }
      );
      navigate(MainPage(role: "user",));
      } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 600;
    TextStyle textStyle = GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold);

    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 40,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              spacing: 10,
              children: [
                Text("Nombres y Apellidos:", textAlign: TextAlign.start,style: textStyle,),
                SizedBox(             
                  width: isDesktop ? min(screenWidth*0.5,600) : screenWidth - 100,
                  child: TextField(
                  controller: nombresApellidosController,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 110, 108, 108)
                    ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.deepOrange.shade400, 
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.blue, 
                        width: 2.0,
                    ),),
                    hoverColor: Colors.lightBlue.shade100,
                  ),
                )
                ),
                Text("Cédula de Identidad:", textAlign: TextAlign.start,style: textStyle,),
                SizedBox(             
                  width: isDesktop ? min(screenWidth*0.5,600) : screenWidth - 100,
                  child: TextField(
                  controller: cedulaController,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 110, 108, 108)
                    ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.deepOrange.shade400, 
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.blue, 
                        width: 2.0,
                    ),),
                    hoverColor: Colors.lightBlue.shade100,
                  ),
                )
                ),
                Text("Correo Electrónico Institucional:", textAlign: TextAlign.start,style: textStyle,),
                SizedBox(             
                  width: isDesktop ? min(screenWidth*0.5,600) : screenWidth - 100,
                  child: TextField(
                  controller: correoController,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 110, 108, 108)
                    ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.deepOrange.shade400, 
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.blue, 
                        width: 2.0,
                    ),),
                    hoverColor: Colors.lightBlue.shade100,
                  ),
                )
                ),
                Text("Contraseña:", textAlign: TextAlign.start,style: textStyle,),
                SizedBox(
                  width: isDesktop ? min(screenWidth*0.5,600) : screenWidth - 100,
                  child: TextField(
                  obscureText: isObscureText,
                  controller: passwordController,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 110, 108, 108)
                    ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(icon: Icon(isObscureText ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isObscureText = !isObscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.deepOrange.shade400, 
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      borderSide: BorderSide(
                        color: Colors.blue, 
                        width: 2.0,
                    ),),
                    hoverColor: const Color.fromARGB(255, 233, 205, 196),
                  ),
                )),
              ]
            ),
            ElevatedButton(
              onPressed: () => crearUsuario(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade400, foregroundColor: Colors.white),
              child: Text("Acceder", style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),),
            ),
          ],
        )
        );
  } 
}

