import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/barraSuperior.dart';

class ContribucionPage extends StatelessWidget {
  final String role;

  const ContribucionPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 700;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? BarraSuperiorDesktop(role: role)
          : const BarraSuperiorMovil(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/homepagebg.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: const Color(0xFF00235E).withOpacity(0.85)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "¿Desea Contribuir a la Biblioteca Pedro Grases?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: isDesktop ? 28 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildLabel("Número de Tarjeta:"),
                      _buildTextField(Icons.credit_card),
                      const SizedBox(height: 15),
                      _buildLabel("Nombre en la Tarjeta:"),
                      _buildTextField(Icons.person),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Fecha Vencimiento:"),
                                _buildTextField(Icons.date_range),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("CVC:"),
                                _buildTextField(Icons.security, obscure: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildLabel("Monto:"),
                      _buildTextField(Icons.attach_money),
                      const SizedBox(height: 15),
                      _buildLabel("Mensaje (opcional):"),
                      _buildTextField(Icons.message, maxLines: 3),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Simulación de pago completada."),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Pagar",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon, {
    bool obscure = false,
    int maxLines = 1,
  }) {
    return TextField(
      obscureText: obscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
