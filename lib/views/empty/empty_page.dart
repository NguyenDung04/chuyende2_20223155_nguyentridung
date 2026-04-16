import 'package:flutter/material.dart';
import '../../widgets/top_menu.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopMenu(currentIndex: 2),
            const Expanded(
              child: Center(
                child: Text(
                  'Trang trống',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3A59),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}