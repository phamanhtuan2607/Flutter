import 'package:flutter/material.dart';

class TestAnh extends StatelessWidget {
  const TestAnh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Ảnh')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Image.asset('assets/images/1.png'),
            ),
            Expanded(
              child: Image.asset('assets/images/2.png'),
            ),
            Expanded(
              child: Image.asset('assets/images/3.png'),
            ),
          ],
        ),
      ),
    );
  }
}