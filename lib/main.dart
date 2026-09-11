import 'package:flutter/material.dart';

void main() => runApp(const AvoraApp());

class AvoraApp extends StatelessWidget {
  const AvoraApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AVORA Cargo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B7A75)),
          scaffoldBackgroundColor: const Color(0xFFF7F9FA),
        ),
        home: const AvoraShell(),
      );
}

class AvoraShell extends StatefulWidget {
  const AvoraShell({super.key});
  @override
  State<AvoraShell> createState() => _AvoraShellState();
}

class _AvoraShellState extends State<AvoraShell> {
  int index = 0;
  final pages = const [HomePage(), OrdersPage(), TrackingPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) => setState(() => index = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Pesanan'),
            NavigationDestination(icon: Icon(Icons.location_searching_outlined), selectedIcon: Icon(Icons.location_searching), label: 'Lacak'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(children: [
              CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary, child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Selamat datang 👋', style: TextStyle(color: Colors.black54)), Text('AVORA Cargo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))])),
              IconButton(onPressed: () => snack(context, 'Notifikasi akan aktif setelah backend terhubung.'), icon: const Icon(Icons.notifications_none)),
            ]),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFF0B7A75), Color(0xFF075A56)])),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Kirim barang lebih mudah', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('Pesan motor atau mobil untuk pengiriman di Kutai Barat.', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 18),
                FilledButton.icon(onPressed: () => openBooking(context), icon: const Icon(Icons.local_shipping_outlined), label: const Text('Pesan Sekarang'), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF075A56))),
              ]),
            ),
            const SizedBox(height: 24),
            const Text('Layanan AVORA', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.25,
              children: [
                ServiceCard(Icons.two_wheeler, 'Motor', 'Barang ringan', () => openBooking(context, 'Motor')),
                ServiceCard(Icons.directions_car_outlined, 'Mobil', 'Barang lebih besar', () => openBooking(context, 'Mobil')),
                ServiceCard(Icons.calculate_outlined, 'Cek Tarif', 'Estimasi harga', () => openBooking(context)),
                ServiceCard(Icons.search, 'Lacak Resi', 'Pantau kiriman', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingPage()))),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Pesanan aktif', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Card(elevation: 0, child: ListTile(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingPage())), leading: const CircleAvatar(child: Icon(Icons.local_shipping_outlined)), title: const Text('AVR-20260911-001', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: const Text('Barong Tongkok → Sendawar\nDalam perjalanan'), trailing: const Icon(Icons.chevron_right))),
          ],
        ),
      );
}

class ServiceCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final VoidCallback onTap;
  const ServiceCard(this.icon, this.title, this.subtitle, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: InkWell(borderRadius: BorderRadius.circular(16), onTap: onTap, child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary), const Spacer(), Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54))])));
}

class BookingPage extends StatefulWidget {
  final String? initialVehicle;
  const BookingPage({super.key, this.initialVehicle});
  @override State<BookingPage> createState() => _BookingPageState();
}
class _BookingPageState extends State<BookingPage> {
  final pickup = TextEditingController(); final destination = TextEditingController(); final note = TextEditingController();
  String type = 'Paket', vehicle = 'Motor'; double weight = 2;
  int get price => (vehicle == 'Motor' ? 15000 : 30000) + (weight > 5 ? ((weight - 5).ceil() * 2000) : 0);
  @override void initState() { super.initState(); vehicle = widget.initialVehicle ?? 'Motor'; }
  @override void dispose() { pickup.dispose(); destination.dispose(); note.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Pesan Cargo')), body: ListView(padding: const EdgeInsets.all(20), children: [
    const Section('Alamat Pengiriman'),
    TextField(controller: pickup, decoration: const InputDecoration(labelText: 'Lokasi pickup', prefixIcon: Icon(Icons.my_location_outlined), hintText: 'Contoh: Barong Tongkok')),
    const SizedBox(height: 12),
    TextField(controller: destination, decoration: const InputDecoration(labelText: 'Alamat tujuan', prefixIcon: Icon(Icons.location_on_outlined), hintText: 'Contoh: Sendawar')),
    const SizedBox(height: 20), const Section('Jenis Barang'),
    Wrap(spacing: 8, children: ['Dokumen', 'Paket', 'Cargo'].map((x) => ChoiceChip(label: Text(x), selected: type == x, onSelected: (_) => setState(() => type = x))).toList()),
    const SizedBox(height: 20), const Section('Berat Barang'),
    Row(children: [Expanded(child: Slider(min: 1, max: 30, divisions: 29, value: weight, label: '${weight.round()} kg', onChanged: (v) => setState(() => weight = v))), Text('${weight.round()} kg', style: const TextStyle(fontWeight: FontWeight.bold))]),
    const SizedBox(height: 10), const Section('Kendaraan'),
    Row(children: [Expanded(child: VehicleCard(Icons.two_wheeler, 'Motor', vehicle == 'Motor', () => setState(() => vehicle = 'Motor'))), const SizedBox(width: 12), Expanded(child: VehicleCard(Icons.directions_car_outlined, 'Mobil', vehicle == 'Mobil', () => setState(() => vehicle = 'Mobil')))]),
    const SizedBox(height: 16), TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'Catatan untuk driver', prefixIcon: Icon(Icons.notes_outlined), alignLabelWithHint: true)),
    const SizedBox(height: 18), Card(elevation: 0, color: const Color(0xFFEAF6F4), child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Estimasi tarif', style: TextStyle(color: Colors.black54)), Text(rupiah(price), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), Text('$vehicle • $type • ${weight.round()} kg', style: const TextStyle(color: Colors.black54))]))),
    const SizedBox(height: 16), FilledButton(onPressed: () { if (pickup.text.trim().isEmpty || destination.text.trim().isEmpty) { snack(context, 'Isi lokasi pickup dan tujuan terlebih dahulu.'); return; } final resi = 'AVR-${DateTime.now().millisecondsSinceEpoch}'; showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Pesanan dibuat'), content: Text('Nomor resi:\n\n$resi\n\nEstimasi tarif ${rupiah(price)}.\n\nPesanan siap dihubungkan ke driver AVORA.'), actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Selesai'))])); }, child: const Text('Buat Pesanan', style: TextStyle(fontWeight: FontWeight.bold))),
  ]));
}

class VehicleCard extends StatelessWidget { final IconData icon; final String title; final bool selected; final VoidCallback onTap; const VehicleCard(this.icon, this.title, this.selected, this.onTap, {super.key}); @override Widget build(BuildContext context) => Card(elevation: 0, color: selected ? const Color(0xFFE5F4F2) : Colors.white, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [Icon(icon, size: 32), const SizedBox(height: 7), Text(title, style: const TextStyle(fontWeight: FontWeight.w800))])))); }
class Section extends StatelessWidget { final String text; const Section(this.text, {super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))); }

class OrdersPage extends StatelessWidget { const OrdersPage({super.key}); @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [const Text('Pesanan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('Riwayat dan status pengiriman Anda.', style: TextStyle(color: Colors.black54)), const SizedBox(height: 20), const OrderTile('AVR-20260911-001', 'Barong Tongkok → Sendawar', 'Dalam perjalanan'), const OrderTile('AVR-20260908-004', 'Melak → Samarinda', 'Selesai'), const SizedBox(height: 12), OutlinedButton.icon(onPressed: () => openBooking(context), icon: const Icon(Icons.add), label: const Text('Buat pesanan baru'))])); }
class OrderTile extends StatelessWidget { final String resi, route, status; const OrderTile(this.resi, this.route, this.status, {super.key}); @override Widget build(BuildContext context) => Card(elevation: 0, margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: const CircleAvatar(child: Icon(Icons.inventory_2_outlined)), title: Text(resi, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('$route\n$status'), isThreeLine: true)); }

class TrackingPage extends StatefulWidget { const TrackingPage({super.key}); @override State<TrackingPage> createState() => _TrackingPageState(); }
class _TrackingPageState extends State<TrackingPage> { final c = TextEditingController(text: 'AVR-20260911-001'); bool searched = true; @override void dispose(){c.dispose();super.dispose();} @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [const Text('Lacak Pengiriman', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('Masukkan nomor resi AVORA Anda.', style: TextStyle(color: Colors.black54)), const SizedBox(height: 20), TextField(controller: c, decoration: InputDecoration(labelText: 'Nomor resi', prefixIcon: const Icon(Icons.qr_code_2), suffixIcon: IconButton(onPressed: () => setState(() => searched = true), icon: const Icon(Icons.search))), onSubmitted: (_) => setState(() => searched = true)), const SizedBox(height: 20), if (searched) Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c.text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), const SizedBox(height: 5), const Text('Dalam perjalanan', style: TextStyle(color: Color(0xFF0B7A75))), const SizedBox(height: 20), const Track('Pesanan dibuat', '11 Sep 2026 • 09:10', true), const Track('Driver menuju pickup', '11 Sep 2026 • 09:20', true), const Track('Barang sudah diambil', '11 Sep 2026 • 10:05', true), const Track('Dalam perjalanan', 'Posisi driver akan tampil realtime', false, true), const Track('Terkirim', 'Menunggu pengantaran', false)])))])); }
class Track extends StatelessWidget { final String title, subtitle; final bool done, active; const Track(this.title, this.subtitle, this.done, [this.active = false], {super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 17), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(done ? Icons.check_circle : active ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: done || active ? const Color(0xFF0B7A75) : Colors.black26), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12))]))])); }

class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [const Text('Profil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 20), Card(elevation: 0, child: const ListTile(contentPadding: EdgeInsets.all(14), leading: CircleAvatar(radius: 28, child: Icon(Icons.person)), title: Text('Pelanggan AVORA', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('Belum login'))), const SizedBox(height: 10), ProfileItem(Icons.person_outline, 'Data pribadi', () => snack(context, 'Login akan dibuat pada tahap berikutnya.')), ProfileItem(Icons.location_on_outlined, 'Alamat tersimpan', () => snack(context, 'Alamat tersimpan akan terhubung ke database.')), ProfileItem(Icons.help_outline, 'Bantuan', () => snack(context, 'Pusat bantuan AVORA akan disiapkan.')), ProfileItem(Icons.info_outline, 'Tentang AVORA', () => snack(context, 'AVORA Cargo & Delivery — Kutai Barat.'))])); }
class ProfileItem extends StatelessWidget { final IconData icon; final String title; final VoidCallback onTap; const ProfileItem(this.icon, this.title, this.onTap, {super.key}); @override Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(onTap: onTap, leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right))); }

void openBooking(BuildContext context, [String? vehicle]) => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingPage(initialVehicle: vehicle)));
void snack(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
String rupiah(int value) { final s = value.toString(); final b = StringBuffer(); for (var i = 0; i < s.length; i++) { if (i > 0 && (s.length - i) % 3 == 0) b.write('.'); b.write(s[i]); } return 'Rp ${b.toString()}'; }
