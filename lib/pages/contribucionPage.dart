import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/barraSuperior.dart';

class ContribucionPage extends StatefulWidget {
  final String role;

  const ContribucionPage({super.key, required this.role});

  @override
  _ContribucionPageState createState() => _ContribucionPageState();
}

class _ContribucionPageState extends State<ContribucionPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expirationController = TextEditingController();
  final _cvcController = TextEditingController();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expirationController.dispose();
    _cvcController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 700;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? BarraSuperiorDesktop(role: widget.role)
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
                  child: Form(
                    key: _formKey,
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
                        _buildTextFormField(
                          Icons.credit_card,
                          controller: _cardNumberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo no puede estar vacío';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildLabel("Nombre en la Tarjeta:"),
                        _buildTextFormField(
                          Icons.person,
                          controller: _cardNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo no puede estar vacío';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("Fecha Vencimiento:"),
                                  _buildTextFormField(
                                    Icons.date_range,
                                    controller: _expirationController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Este campo no puede estar vacío';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel("CVC:"),
                                  _buildTextFormField(
                                    Icons.security,
                                    controller: _cvcController,
                                    obscure: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Este campo no puede estar vacío';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildLabel("Monto:"),
                        _buildTextFormField(
                          Icons.attach_money,
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo no puede estar vacío';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null) {
                              return 'El monto debe ser un número';
                            }
                            if (amount <= 0) {
                              return 'El monto debe ser mayor a 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildLabel("Mensaje (opcional):"),
                        _buildTextFormField(
                          Icons.message,
                          controller: _messageController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Simulación de pago completada.",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              }
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

  Widget _buildTextFormField(
    IconData icon, {
    TextEditingController? controller,
    bool obscure = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
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
