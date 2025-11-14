import 'package:flutter/material.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void updatePassword() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    // Temporary success message (no DB)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password Updated Successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Match login page color palette and layout
    const Color yellowColor = Color(0xFFF7AA00);
    const Color whiteBackground = Color(0xFFEEF6F7);
    const Color buttonColor = Color(0xFF40A8C4);

    return Scaffold(
      backgroundColor: whiteBackground,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 100),
                          child: Text(
                            'Game List',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Color(0xFF40A8C4),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 100),
                          child: Text(
                            'Organizer',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Color(0xFF40A8C4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 520,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(color: yellowColor),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.all(20),
                        width: 340,
                        decoration: BoxDecoration(
                          color: whiteBackground,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFF40A8C4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(width: 80, height: 3, color: buttonColor),
                            const SizedBox(height: 20),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Color(0xFF40A8C4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            buildTextField(usernameController, false),
                            const SizedBox(height: 16),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'New Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Color(0xFF40A8C4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            buildTextField(passwordController, true),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: updatePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 15,
                                ),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text(
                                'EXIT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF41A5BD),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }
}
