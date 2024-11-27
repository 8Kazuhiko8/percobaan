import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/foto.jpg'),
          ),
          SizedBox(height: 20),*/
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //'Biodata',
                    'Anggota Kelompok',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Nama Lengkap: Muhammad Salman Mahdi // Dimas Rahmadhan'),
                  Text('NIM: 124220014 // 124220024'),
                  //Text('Tempat Tanggal Lahir: Jember, 08 Oktober 2003'),
                  //Text('Hobi: Membaca, Bermain Game'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}