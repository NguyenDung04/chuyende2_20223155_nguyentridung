import 'package:flutter/material.dart';
import '../../widgets/top_menu.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFEAF1FF),
            child: Icon(icon, color: const Color(0xFF5B8DEF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopMenu(currentIndex: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    const Text(
                      'Thông tin sinh viên',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 18),
                    infoTile(Icons.person, 'Họ tên', 'Nguyễn Trí Dũng'),
                    infoTile(Icons.badge, 'Mã sinh viên', '20223155'),
                    infoTile(Icons.phone, 'Số điện thoại', '0378519357'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}