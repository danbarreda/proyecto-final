import 'dart:math';

import 'package:biblioteca_unimet/pages/singUpPage.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

void showErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error:"),
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

  void showPassword(){
    setState(() {
      isObscureText = !isObscureText;
    });
  }

  void login(){
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 600;
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.deepOrange, width: 2.0)
              ),               
              child: Text(
              "Iniciar Sesión",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: Colors.black, offset: Offset(0, 4.0), blurRadius: 4)],
                color: Colors.deepOrange,
              ),
            )),
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
                hintText: "Nombre de usuario",
                hoverColor: Colors.lightBlue.shade100,
              ),
            )
            ),
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
                hintText: "Contraseña",
                hoverColor: const Color.fromARGB(255, 233, 205, 196),
              ),
            )),
            Row(spacing: 20,mainAxisAlignment: MainAxisAlignment.center,children: [
              Text("No tienes cuenta?", style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                ),),
              TextButton(onPressed: () => {
                Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                  builder: (BuildContext context) => SignUpPage(),
                ),)
              },
                child: Text("Regístrate aquí", style: GoogleFonts.inter(
                  decoration: TextDecoration.underline, 
                  decorationColor: Colors.white,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),),
              )
            ],),
            ElevatedButton(
              onPressed: () => login(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade400, foregroundColor: Colors.white),
              child: Text("Acceder", style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),),
            ),
          ],
        ),
      );
  } 
}
