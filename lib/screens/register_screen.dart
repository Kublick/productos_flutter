import 'package:flutter/material.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

import '../providers/login_form_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
                child: Column(
      children: [
        const SizedBox(
          height: 250,
        ),
        CardContainer(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text('Crear Cuenta', style: Theme.of(context).textTheme.headline4),
            const SizedBox(
              height: 30,
            ),
            ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: const RegisterForm(),
            )
          ],
        )),
        const SizedBox(height: 50),
        TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all( const StadiumBorder())
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'login'),
            child: const Text('¿Ya tienes una cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87)))

      ],
    ))));
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Form(
            key: loginForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'john.doe@gmail.com',
                      labelText: 'Correo Electronico',
                      prefixIcon: Icons.alternate_email_sharp),
                  onChanged: (value) => loginForm.email = value,
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = RegExp(pattern);
                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'El valor ingresado no es un correo';
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: '*****',
                      labelText: 'Contraseña',
                      prefixIcon: Icons.lock_outlined),
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    if (value != null && value.length >= 6) return null;
                    return 'La contraseña debe ser de 6 caracteres';
                  },
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                    FocusScope.of(context).unfocus();
                    final authService = Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;
                    final String? errorMessage = await authService.createUser(loginForm.email, loginForm.password);
                    if(errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'home');

                    }  else {
                      // Mostrar error en pantalla
                      print(errorMessage);
                    loginForm.isLoading = false;
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      child: Text(loginForm.isLoading ? 'Espere' : 'Ingresar',
                          style: const TextStyle(color: Colors.white))),
                )
              ],
            )));
  }
}