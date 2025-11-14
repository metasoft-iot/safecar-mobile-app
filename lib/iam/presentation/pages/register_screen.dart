import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/blocs/auth_bloc.dart';
import '../../application/blocs/auth_event.dart';
import '../../application/blocs/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para Auth
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Controladores para Perfil
  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dniController = TextEditingController();

  String _selectedRole = 'ROLE_DRIVER'; // Tu rol por defecto
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  void _submitRegister() {
    if (_formKey.currentState!.validate()) {
      // Enviar el evento con TODOS los datos
      context.read<AuthBloc>().add(
        RegisterRequested(
          // Auth
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          role: _selectedRole,
          // Perfil
          fullName: _fullNameController.text,
          city: _cityController.text,
          country: _countryController.text,
          phone: _phoneController.text,
          dni: _dniController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333366),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is Unauthenticated && context.read<AuthBloc>().state is! AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful! Please log in.'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/login');
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ... (Tu cabecera de SafeCar no cambia)
              const Expanded(flex: 2, child: Center(child: Text('SafeCar', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)))),
              Expanded(
                flex: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          const SizedBox(height: 24),

                          // --- CAMPOS DE PERFIL ---
                          _buildTextField(_fullNameController, 'Full Name', 'John Doe', validator: _validateNonEmpty),
                          const SizedBox(height: 16),
                          _buildTextField(_dniController, 'DNI', '12345678', validator: _validateNonEmpty),
                          const SizedBox(height: 16),
                          _buildTextField(_cityController, 'City', 'Lima', validator: _validateNonEmpty),
                          const SizedBox(height: 16),
                          _buildTextField(_countryController, 'Country', 'Peru', validator: _validateNonEmpty),
                          const SizedBox(height: 16),
                          _buildTextField(_phoneController, 'Phone', '+51987654321', validator: _validateNonEmpty),
                          const SizedBox(height: 16),

                          // --- CAMPO DE ROL ---
                          const Text('Role'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            items: const [
                              DropdownMenuItem(value: 'ROLE_DRIVER', child: Text('User (Driver)')),
                              DropdownMenuItem(value: 'ROLE_MECHANIC', child: Text('Mechanic')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedRole = value);
                            },
                            decoration: _buildInputDecoration(hintText: ''),
                            validator: (value) => value == null ? 'Please select a role' : null,
                          ),
                          const SizedBox(height: 16),

                          // --- CAMPOS DE AUTH ---
                          _buildTextField(_emailController, 'Email', 'you@example.com', validator: _validateEmail),
                          const SizedBox(height: 16),
                          _buildTextField(_passwordController, 'Password', '********', isPassword: true, validator: _validatePassword),
                          const SizedBox(height: 16),
                          _buildTextField(_confirmPasswordController, 'Confirm Password', '********', isPassword: true, validator: (value) {
                            if (value == null || value.isEmpty) return 'Please confirm your password';
                            if (value != _passwordController.text) return 'Passwords do not match';
                            return null;
                          }),
                          const SizedBox(height: 24),

                          // --- BOTÓN ---
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return ElevatedButton(
                                onPressed: _submitRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9999CC),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: const Text('Already have an account? Log in'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets de Helper ---
  Widget _buildTextField(TextEditingController controller, String label, String hintText, {bool isPassword = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: _buildInputDecoration(hintText: hintText),
          validator: validator,
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    );
  }

  // --- Validadores ---
  String? _validateNonEmpty(String? value) => (value == null || value.isEmpty) ? 'This field cannot be empty' : null;
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter an email';
    if (!value.contains('@')) return 'Please enter a valid email';
    return null;
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}