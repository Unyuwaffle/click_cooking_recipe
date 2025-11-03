import 'package:flutter/material.dart';
import '../widgets/primary_button.dart'; // Import the new button
import 'package:go_router/go_router.dart'; // Import router to move screens


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈 화면')),
      body: Center(
        // Use the new button
        child: PrimaryButton(
          text: '레시피 찾으러 가기!',
          onPressed: () {
            // When clicked, go to the camera screen
            context.go('/camera');
          },
        ),
      ),
    );
  }
}