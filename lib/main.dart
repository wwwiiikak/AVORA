import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cljcdywnvchdsafblfsb.supabase.co',
    publishableKey: 'sb_publishable_O1ULa0C6Dgm6lP_tORgXeA_JApE5Mlt',
  );
  runApp(const AvoraApp());
}

final supabase = Supabase.instance.client;

class AvoraApp extends StatelessWidget {
  const AvoraApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AVORA Cargo',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
        home: const AuthGate(),
      );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<AuthState>(
        stream: supabase.auth.onAuthStateChange,
        builder: (_, __) => supabase.auth.currentSession == null
            ? const LoginPage()
            : const HomePage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  bool register = false, busy = false;

  void msg(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6) {
      msg('Email harus diisi dan password minimal 6 karakter.'); return;
    }
    if (register && name.text.trim().isEmpty) { msg('Nama harus diisi.'); return; }
    setState(() => busy = true);
    try {
      if (register) {
        final r = await supabase.auth.signUp(
          email: email.text.trim(), password: password.text,
          data: {'full_name': name.text.trim()},
        );
        if (r.session == null) msg('Akun dibuat. Cek email jika konfirmasi aktif.');
      } else {
        await supabase.auth.signInWithPassword(email: email.text.trim(), password: password.text);
      }
    } on AuthException catch (e) { msg(e.message); }
    catch (e) { msg('Terjadi kesalahan: $e'); }
    finally { if (mounted) setState(() => busy = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: Center(child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430), child: Card(
            child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
              const CircleAvatar(radius: 34, child: Icon(Icons.local_shipping, size: 34)),
              const SizedBox(height: 14),
              const Text('AVORA', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text(register ? 'Buat akun customer' : 'Masuk ke AVORA'),
              const SizedBox(height: 22),
              if (register) ...[
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Nama lengkap', border: OutlineInputBorder())),
                const SizedBox(height: 12),
              ],
              TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Memproses...' : register ? 'Daftar' : 'Masuk'))),
              TextButton(onPressed: busy ? null : () => setState(() => register = !register), child: Text(register ? 'Sudah punya akun? Masuk' : 'Belum punya akun? Daftar')),
            ]),),
          )),
        )),),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = const [HomeTab(), OrdersTab(), ProfileTab()];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Pesanan'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
    const Text('AVORA', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
    const Text('Cargo & Delivery — Kutai Barat'),
    const SizedBox(height: 18),
    Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Kirim barang sekarang', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Pesan motor atau mobil dan simpan pesanan langsung ke database AVORA.'),
      const SizedBox(height: 14),
      FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingPage())), icon: const Icon(Icons.add_box_outlined), label: const Text('Buat Pesanan')),
    ]))),
    const SizedBox(height: 12),
    Row(children: const [
      Expanded(child: ServiceCard(icon: Icons.two_wheeler, title: 'Motor')),
      SizedBox(width: 10),
      Expanded(child: ServiceCard(icon: Icons.directions_car, title: 'Mobil')),
    ]),
  ]));
}

class ServiceCard extends StatelessWidget {
  final IconData icon; final String title;
  const ServiceCard({super.key, required this.icon, required this.title});
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Icon(icon, size: 34), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))])));
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});
  @override State<BookingPage> createState() => _BookingPageState();
}
class _BookingPageState extends State<BookingPage> {
  final pickup = TextEditingController();
  final destination = TextEditingController();
  final type = TextEditingController(text: 'Paket');
  final notes = TextEditingController();
  double weight = 1;
  String vehicle = 'motor';
  String service = 'regular';
  int estimate = 15000;
  bool loading = false;

  int localEstimate() => (vehicle == 'motor' ? 15000 : 30000) + (weight > 5 ? (weight - 5).ceil() * 2000 : 0);

  Future<void> loadTariff() async {
    try {
      final row = await supabase.from('tariffs').select('base_price,free_weight_kg,price_per_kg,minimum_price').eq('vehicle_type', vehicle).eq('service_type', service).eq('is_active', true).order('created_at', ascending: false).limit(1).maybeSingle();
      if (row != null && mounted) {
        final base = (row['base_price'] as num).toInt();
        final freeKg = (row['free_weight_kg'] as num?)?.toDouble() ?? 5;
        final perKg = (row['price_per_kg'] as num?)?.toInt() ?? 2000;
        final min = (row['minimum_price'] as num?)?.toInt() ?? 0;
        final total = base + (weight > freeKg ? (weight - freeKg).ceil() * perKg : 0);
        setState(() => estimate = total < min ? min : total);
      }
    } catch (_) { if (mounted) setState(() => estimate = localEstimate()); }
  }

  void msg(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  Future<void> createOrder() async {
    if (pickup.text.trim().isEmpty || destination.text.trim().isEmpty) { msg('Lokasi jemput dan tujuan wajib diisi.'); return; }
    final user = supabase.auth.currentUser;
    if (user == null) { msg('Silakan masuk terlebih dahulu.'); return; }
    setState(() => loading = true);
    try {
      final resi = 'AVR${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final row = await supabase.from('orders').insert({
        'customer_id': user.id,
        'order_number': resi,
        'pickup_address': pickup.text.trim(),
        'destination_address': destination.text.trim(),
        'package_type': 'Paket',
        'weight_kg': weight,
        'vehicle_type': vehicle,
        'service_type': service,
        'notes': notes.text.trim(),
        'estimated_price': estimate,
        'resi': resi,
        'status': 'pending',
      }).select('id,resi').single();
      if (!mounted) return;
      await showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('Pesanan berhasil'),
        content: Text('Nomor resi:\n\n${row['resi']}\n\nSimpan nomor ini untuk pelacakan.'),
        actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Selesai'))],
      ));
      if (mounted) Navigator.pop(context);
    } on PostgrestException catch (e) { msg('Pesanan gagal disimpan: ${e.message}'); }
    catch (e) { msg('Terjadi kesalahan: $e'); }
    finally { if (mounted) setState(() => loading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Buat Pesanan')), body: ListView(padding: const EdgeInsets.all(18), children: [
    TextField(controller: pickup, decoration: const InputDecoration(labelText: 'Lokasi jemput', prefixIcon: Icon(Icons.location_on_outlined), border: OutlineInputBorder())),
    const SizedBox(height: 12),
    TextField(controller: destination, decoration: const InputDecoration(labelText: 'Lokasi tujuan', prefixIcon: Icon(Icons.flag_outlined), border: OutlineInputBorder())),
    const SizedBox(height: 12),
    TextField(controller: type, decoration: const InputDecoration(labelText: 'Jenis barang', border: OutlineInputBorder())),
    const SizedBox(height: 12),
    Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Berat: ${weight.toStringAsFixed(1)} kg'), Slider(value: weight, min: .5, max: 30, divisions: 59, onChanged: (v) { setState(() { weight = v; estimate = localEstimate(); }); loadTariff(); })]))),
    const SizedBox(height: 8),
    SegmentedButton<String>(segments: const [ButtonSegment(value: 'motor', icon: Icon(Icons.two_wheeler), label: Text('Motor')), ButtonSegment(value: 'mobil', icon: Icon(Icons.directions_car), label: Text('Mobil'))], selected: {vehicle}, onSelectionChanged: (s) { setState(() => vehicle = s.first); loadTariff(); }),
    const SizedBox(height: 12),
    TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Catatan untuk driver (opsional)', border: OutlineInputBorder())),
    const SizedBox(height: 16),
    Card(child: ListTile(leading: const Icon(Icons.payments_outlined), title: const Text('Estimasi tarif'), trailing: Text(formatRupiah(estimate), style: const TextStyle(fontWeight: FontWeight.bold)))),
    const SizedBox(height: 16),
    FilledButton.icon(onPressed: loading ? null : createOrder, icon: const Icon(Icons.check_circle_outline), label: Text(loading ? 'Menyimpan...' : 'Konfirmasi Pesanan')),
  ]));
}

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});
  @override State<OrdersTab> createState() => _OrdersTabState();
}
class _OrdersTabState extends State<OrdersTab> {
  Future<List<Map<String,dynamic>>> load() async {
    final u = supabase.auth.currentUser; if (u == null) return [];
    final data = await supabase.from('orders').select('id,resi,pickup_address,destination_address,vehicle_type,status,estimated_price,created_at').eq('customer_id', u.id).order('created_at', ascending: false);
    return List<Map<String,dynamic>>.from(data);
  }
  @override Widget build(BuildContext context) => SafeArea(child: FutureBuilder<List<Map<String,dynamic>>>(future: load(), builder: (_, s) {
    if (s.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
    if (s.hasError) return Center(child: Text('Gagal memuat pesanan: ${s.error}'));
    final orders = s.data ?? []; if (orders.isEmpty) return const Center(child: Text('Belum ada pesanan.'));
    return ListView.builder(padding: const EdgeInsets.all(18), itemCount: orders.length, itemBuilder: (_, i) { final o = orders[i]; return Card(child: ListTile(leading: Icon(o['vehicle_type'] == 'mobil' ? Icons.directions_car : Icons.two_wheeler), title: Text(o['resi'] ?? '-'), subtitle: Text('${o['pickup_address']}\n→ ${o['destination_address']}\nStatus: ${o['status']}'), isThreeLine: true, trailing: Text(formatRupiah((o['estimated_price'] as num?)?.toInt() ?? 0)))); });
  }));
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override Widget build(BuildContext context) { final u = supabase.auth.currentUser; final name = u?.userMetadata?['full_name'] ?? 'Customer AVORA'; return SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)), const SizedBox(height: 12), Center(child: Text('$name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), Center(child: Text(u?.email ?? '')), const SizedBox(height: 20), Card(child: const ListTile(leading: Icon(Icons.location_city), title: Text('Wilayah awal'), subtitle: Text('Kutai Barat'))), const SizedBox(height: 8), OutlinedButton.icon(onPressed: () => supabase.auth.signOut(), icon: const Icon(Icons.logout), label: const Text('Keluar'))])); }
}

String formatRupiah(int value) { final s = value.toString(); final b = StringBuffer(); for (var i=0; i<s.length; i++) { if (i>0 && (s.length-i)%3==0) b.write('.'); b.write(s[i]); } return 'Rp ${b.toString()}'; }
