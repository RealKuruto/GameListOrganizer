import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  final Color yellowColor = const Color(0xFFF7AA00);
  final Color whiteBackground = const Color(0xFFEEF6F7);
  final Color buttonColor = const Color(0xFF40A8C4);

  @override
  Widget build(BuildContext context) {
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
                      height: 165,
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
                height: 550,
                width: 460,
                child: Stack(
                  children: [
                    Container(color: yellowColor),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.all(20),
                        width: 320,
                        decoration: BoxDecoration(
                          color: whiteBackground,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Sign Up', // Changed from 'Login' to 'Sign Up'
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFF40A8C4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(width: 80, height: 3, color: buttonColor),
                            const SizedBox(height: 20),
                            // Username Field
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Enter Username',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Color(0xFF40A8C4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: buttonColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Enter your username',
                                hintStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Password Field
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Enter Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Color(0xFF40A8C4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              textAlign: TextAlign.center,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: buttonColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
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
                                'sign up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Exit button functionality - navigate back to login screen
                                  Navigator.pop(context);
                                },
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
          // Embedded Triangle Painter
          Positioned(
            bottom: 0,
            right: -150,
            child: CustomPaint(
              size: const Size(250, 250),
              painter: _TrianglePainter(color: buttonColor),
            ),
          ),
        ],
      ),
    );
  }
}

// Embedded Triangle Painter Class
class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
