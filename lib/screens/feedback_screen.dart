import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kesan dan Saran',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Kesan:\n'
                    'Karena saya selalu penasaran bagaimana cara aplikasi mobile itu dibuat, dengan adanya mata kuliah Pemrograman Aplikasi Mobile ini dapat memberikan '
                    'pengalaman baru dalam membuat dan mengembangkan aplikasi mobile. Pembelajaran '
                    'Flutter membuka wawasan baru tentang pengembangan aplikasi cross-platform.\n\n'
                    'Saran:\n'
                    'Mungkin bisa ditambahkan lebih banyak contoh studi kasus real-world dan implementasi aplikasi mobilenya'
                    'untuk meningkatkan pemahaman mahasiswa.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}