import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:percobaan/models/user_model.dart';
import 'package:percobaan/main.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final _amountController = TextEditingController();
  String _selectedCurrency = 'USD';
  double _amount = 10.0;

  // Rates initialized directly
  final Map<String, double> _rates = {
    'USD': 1,
    'IDR': 15000,
    'EUR': 0.95,
    'CAD': 1.40,
    'JPY': 150,
    'KRW': 1400,
  };

  double _getConvertedAmount() {
    if (_selectedCurrency == 'USD') return _amount;
    return _amount * (_rates[_selectedCurrency] ?? 1.0);
  }

  Future<void> _showNotification(bool success) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'premium_channel',
      'Premium Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      success ? 'Payment Successful' : 'Payment Failed',
      success ? 'You are now a premium user!' : 'Please try again',
      platformChannelSpecifics,
    );
  }

  void _processPurchase() async {
    final enteredAmount = double.tryParse(_amountController.text);
    final expectedAmount = _getConvertedAmount();

    if (enteredAmount == expectedAmount) {
      final userBox = Hive.box<User>('users');
      final user = userBox.getAt(0);
      user?.isPremium = true;
      await user?.save();

      await _showNotification(true);

      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      await _showNotification(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Access')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get Premium Access',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Base price: \$10'),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedCurrency,
              items: ['USD', 'EUR', 'CAD', 'JPY', 'IDR', 'KRW']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Amount to pay: ${_getConvertedAmount().toStringAsFixed(2)} $_selectedCurrency',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.purple,
                  backgroundColor: Colors.white,
                ),
                onPressed: _processPurchase,
                child: const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
