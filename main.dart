import 'package:flutter/material.dart';

void main() {
  runApp(const AvoraApp());
}

class AvoraApp extends StatelessWidget {
  const AvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AVORA Cargo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0B6E4F),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVORA'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Cargo lebih mudah.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kirim barang dari pickup sampai tujuan dengan AVORA.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          _ServiceCard(
            icon: Icons.two_wheeler,
            title: 'Motor',
            subtitle: 'Untuk dokumen dan paket kecil',
            onTap: () => _showMessage(context, 'Layanan Motor dipilih'),
          ),
          const SizedBox(height: 12),
          _ServiceCard(
            icon: Icons.local_shipping,
            title: 'Mobil / Cargo',
            subtitle: 'Untuk barang lebih besar dan banyak',
            onTap: () => _showMessage(context, 'Layanan Mobil / Cargo dipilih'),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _showMessage(context, 'Fitur pemesanan akan segera aktif'),
            icon: const Icon(Icons.add_location_alt),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Pesan Pengiriman'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showMessage(context, 'Pelacakan resi akan segera aktif'),
            icon: const Icon(Icons.search),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Lacak Resi'),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
