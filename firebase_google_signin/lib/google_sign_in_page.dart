import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home_page.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final AuthService auth = AuthService();
  final TextEditingController emailCtrl =
      TextEditingController(text: 'clarksalas89@gmail.com');
  bool loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void handleNext() async {
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    setState(() => loading = true);

    User? user;
    try {
      user = await auth.signInWithGoogle();
    } catch (_) {}

    user ??= await auth.signInOrRegisterWithGoogleEmail(email);

    setState(() => loading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A73E8),
        elevation: 0,
        title: const Text(
          "Sign in with Google",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                      TextSpan(text: 'o', style: TextStyle(color: Color(0xFFEA4335))),
                      TextSpan(text: 'o', style: TextStyle(color: Color(0xFFFBBC05))),
                      TextSpan(text: 'g', style: TextStyle(color: Color(0xFF4285F4))),
                      TextSpan(text: 'l', style: TextStyle(color: Color(0xFF34A853))),
                      TextSpan(text: 'e', style: TextStyle(color: Color(0xFFEA4335))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Sign in",
                style: TextStyle(fontSize: 22, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              const Text(
                "Use your Google Account. The account will be added to this device and available to other Google apps.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              const Text(
                "Learn more about using your account",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1A73E8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: "Email or phone",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Forgot email?",
                  style: TextStyle(
                    color: Color(0xFF1A73E8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create account",
                  style: TextStyle(
                    color: Color(0xFF1A73E8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: loading ? null : handleNext,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "NEXT",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
}
