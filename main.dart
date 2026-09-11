import 'package:flutter/material.dart';

void main() {
  runApp(const AvoraApp());
}

class AvoraApp extends StatelessWidget {
  const AvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVORA Cargo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B5ED7),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(width: 1.5),
          ),
        ),
      ),
      home: const AvoraShell(),
    );
  }
}

class AvoraShell extends StatefulWidget {
  const AvoraShell({super.key});

  @override
  State<AvoraShell> createState() => _AvoraShellState();
}

class _AvoraShellState extends State<AvoraShell> {
  int index = 0;
  String? activeOrder;

  void openBooking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingPage(
          onBooked: (resi) {
            setState(() => activeOrder = resi);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onBook: openBooking, activeOrder: activeOrder),
      OrdersPage(activeOrder: activeOrder),
      TrackingPage(resi: activeOrder),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Pesanan'),
          NavigationDestination(icon: Icon(Icons.location_searching), selectedIcon: Icon(Icons.location_on), label: 'Lacak'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onBook;
  final String? activeOrder;

  const HomePage({super.key, required this.onBook, this.activeOrder});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.local_shipping, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AVORA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        Text('Cargo & Delivery', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kirim barang jadi lebih mudah.', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    SizedBox(height: 6),
                    Text('Pesan motor atau mobil untuk kebutuhan pengiriman Anda.', style: TextStyle(color: Colors.white70, height: 1.4)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: FilledButton.icon(
                onPressed: onBook,
                icon: const Icon(Icons.add_location_alt),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Pesan Pengiriman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Text('Layanan AVORA', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: const [
                ServiceCard(icon: Icons.two_wheeler, title: 'AVORA Motor', subtitle: 'Paket ringan & cepat'),
                ServiceCard(icon: Icons.local_shipping_outlined, title: 'AVORA Mobil', subtitle: 'Barang lebih besar'),
                ServiceCard(icon: Icons.inventory_2_outlined, title: 'Cargo', subtitle: 'Pengiriman barang'),
                ServiceCard(icon: Icons.route_outlined, title: 'Tracking', subtitle: 'Pantau perjalanan'),
              ],
            ),
          ),
          if (activeOrder != null)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.local_shipping)),
                    title: const Text('Pengiriman aktif'),
                    subtitle: Text('Resi: $activeOrder'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ServiceCard({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  final ValueChanged<String> onBooked;
  const BookingPage({super.key, required this.onBooked});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final pickup = TextEditingController();
  final destination = TextEditingController();
  final notes = TextEditingController();
  String vehicle = 'Motor';
  String packageType = 'Paket';
  double weight = 2;
  int price = 15000;

  void recalc() {
    final base = vehicle == 'Motor' ? 15000 : 30000;
    final extra = weight > 5 ? ((weight - 5) * 2000).round() : 0;
    setState(() => price = base + extra);
  }

  @override
  void dispose() {
    pickup.dispose();
    destination.dispose();
    notes.dispose();
    super.dispose();
  }

  void submit() {
    if (pickup.text.trim().isEmpty || destination.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi alamat pickup dan tujuan terlebih dahulu.')),
      );
      return;
    }
    final resi = 'AVR${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    widget.onBooked(resi);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pesanan berhasil dibuat'),
        content: Text('Nomor resi Anda:\n$resi\n\nEstimasi tarif: Rp ${formatRupiah(price)}'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesan Pengiriman')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const StepTitle(number: '1', title: 'Lokasi pengiriman'),
          TextField(controller: pickup, decoration: const InputDecoration(labelText: 'Alamat pickup', prefixIcon: Icon(Icons.my_location))),
          const SizedBox(height: 12),
          TextField(controller: destination, decoration: const InputDecoration(labelText: 'Alamat tujuan', prefixIcon: Icon(Icons.location_on_outlined))),
          const SizedBox(height: 24),
          const StepTitle(number: '2', title: 'Detail barang'),
          DropdownButtonFormField<String>(
            value: packageType,
            decoration: const InputDecoration(labelText: 'Jenis barang'),
            items: const ['Dokumen', 'Paket', 'Cargo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => packageType = v!),
          ),
          const SizedBox(height: 12),
          Text('Berat: ${weight.toStringAsFixed(1)} kg', style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(
            value: weight,
            min: 0.5,
            max: 30,
            divisions: 59,
            label: '${weight.toStringAsFixed(1)} kg',
            onChanged: (v) {
              weight = v;
              recalc();
            },
          ),
          const SizedBox(height: 8),
          const Text('Kendaraan', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: VehicleChoice(title: 'Motor', icon: Icons.two_wheeler, selected: vehicle == 'Motor', onTap: () { vehicle = 'Motor'; recalc(); })),
              const SizedBox(width: 12),
              Expanded(child: VehicleChoice(title: 'Mobil', icon: Icons.local_shipping_outlined, selected: vehicle == 'Mobil', onTap: () { vehicle = 'Mobil'; recalc(); })),
            ],
          ),
          const SizedBox(height: 24),
          const StepTitle(number: '3', title: 'Catatan'),
          TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(hintText: 'Contoh: barang mudah pecah, hubungi penerima sebelum tiba.')),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Text('Estimasi tarif', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text('Rp ${formatRupiah(price)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text('$vehicle • $packageType • ${weight.toStringAsFixed(1)} kg', style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: submit,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Konfirmasi Pesanan', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class StepTitle extends StatelessWidget {
  final String number;
  final String title;
  const StepTitle({super.key, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 13, child: Text(number, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class VehicleChoice extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const VehicleChoice({super.key, required this.title, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : Colors.black12,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  final String? activeOrder;
  const OrdersPage({super.key, this.activeOrder});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Pesanan', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          if (activeOrder == null)
            const EmptyState(icon: Icons.receipt_long, title: 'Belum ada pesanan', subtitle: 'Pesanan pengiriman Anda akan muncul di sini.')
          else
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(child: Icon(Icons.local_shipping)),
                title: const Text('Pengiriman aktif', style: TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text('Resi: $activeOrder\nStatus: Menunggu driver'),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
        ],
      ),
    );
  }
}

class TrackingPage extends StatelessWidget {
  final String? resi;
  const TrackingPage({super.key, this.resi});

  @override
  Widget build(BuildContext context) {
    final hasOrder = resi != null;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Lacak Pengiriman', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          TextField(
            decoration: InputDecoration(
              hintText: hasOrder ? resi : 'Masukkan nomor resi',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
            ),
          ),
          const SizedBox(height: 24),
          if (!hasOrder)
            const EmptyState(icon: Icons.location_searching, title: 'Belum ada resi', subtitle: 'Buat pesanan terlebih dahulu untuk melihat tracking.')
          else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resi $resi', style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Text('Estimasi tiba setelah driver mengambil barang.', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const StatusTimeline(),
          ],
        ],
      ),
    );
  }
}

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Pesanan dibuat', 'Pesanan diterima AVORA', Icons.receipt_long),
      ('Driver mencari pesanan', 'Menunggu driver menerima', Icons.person_search),
      ('Pickup', 'Driver menuju lokasi pickup', Icons.two_wheeler),
      ('Dalam perjalanan', 'Barang menuju tujuan', Icons.route),
      ('Selesai', 'Barang telah diterima', Icons.check_circle),
    ];
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: i == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(item.$3, size: 18, color: i == 0 ? Colors.white : Theme.of(context).colorScheme.primary),
                ),
                if (i != items.length - 1)
                  Container(width: 2, height: 48, color: Theme.of(context).colorScheme.primaryContainer),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(item.$2, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Profil', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          Card(
            child: const ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(radius: 28, child: Icon(Icons.person)),
              title: Text('Pelanggan AVORA', style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('Akun pelanggan'),
              trailing: Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 14),
          const MenuTile(icon: Icons.location_on_outlined, title: 'Alamat tersimpan'),
          const MenuTile(icon: Icons.account_balance_wallet_outlined, title: 'Pembayaran'),
          const MenuTile(icon: Icons.help_outline, title: 'Bantuan & Dukungan'),
          const MenuTile(icon: Icons.info_outline, title: 'Tentang AVORA'),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const MenuTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.black26),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

String formatRupiah(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write('.');
    buffer.write(text[i]);
  }
  return buffer.toString();
}
