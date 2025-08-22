import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';


/*class LoginPageWithEmailOrPhone extends StatefulWidget {
  const LoginPageWithEmailOrPhone({Key? key}) : super(key: key);

  @override
  State<LoginPageWithEmailOrPhone> createState() => _LoginPageWithEmailOrPhoneState();
}

class _LoginPageWithEmailOrPhoneState extends State<LoginPageWithEmailOrPhone> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loginWithEmailOrPhone(
      identifierController.text.trim(),
      passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: identifierController,
              decoration: InputDecoration(labelText: "Email or Phone"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            authProvider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () => _login(context),
              child: Text("Login"),
            ),
            if (authProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(authProvider.errorMessage!, style: TextStyle(color: Colors.red)),
              ),
            if (authProvider.token != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Access Token: ${authProvider.token!}"),
              ),
          ],
        ),
      ),
    );
  }
}

*/
