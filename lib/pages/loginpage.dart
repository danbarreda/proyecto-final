import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

void showErrorMessage(BuildContext context, String message){
  showDialog(context: context, builder: (BuildContext context) {
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
  bool validated = false;
  final correoController = TextEditingController();
  final passwordController = TextEditingController();


  void crearUsuario(){
    correo = correoController.text;
    password = passwordController.text;
    List<String> dominio = correo.split("@");
    validated = dominio[1]== "correo.unimet.edu.ve" || dominio[1] == "unimet.edu.ve";
    if (validated){
      print("Correo: " + correo + "\nContrasena: " + password);
    }else{
      showErrorMessage(context, "El correo debe ser correo UNIMET: (ejemplo@correo.unimet.edu.ve o ejemplo@unimet.edu.ve)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.elliptical(20, 20))),
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Iniciar Sesion", textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.deepOrange)), 
            TextField(controller: correoController , decoration: InputDecoration(border: OutlineInputBorder(), hintText:  "ejemplo@correo.unimet.edu.ve", hoverColor: Colors.lightBlue.shade100)),
            TextField(controller: passwordController, decoration: InputDecoration(border: OutlineInputBorder(), hintText:  "Contraseña", hoverColor: Colors.lightBlue.shade100)),
            ElevatedButton.icon(onPressed: crearUsuario, icon: Icon(Icons.send_rounded, color: Colors.deepOrange.shade300,), label: Text("Crear Usuario")),
          ],
      ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
      body:Stack(
            children: [
              Positioned.fill(child: Image(image: AssetImage("assets/images/biblioteca.png"), fit: BoxFit.cover,)),
              Padding(padding: EdgeInsetsGeometry.all(10), child: Center(child: LoginForm()))
            ]
      )
    );
  }
}

