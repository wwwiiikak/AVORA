# AVORA — Tahap 6: Pemesanan Terhubung Supabase

Tahap ini menghubungkan alur pemesanan customer ke database Supabase.

Fitur utama:
- Login/registrasi
- Lokasi jemput dan tujuan
- Jenis barang dan berat
- Motor/Mobil
- Tarif dari tabel `tariffs`
- Nomor resi otomatis
- Penyimpanan ke tabel `orders`
- Riwayat pesanan customer
- Profil dan logout

Pemasangan di GitHub:
1. Ganti `pubspec.yaml` di root.
2. Ganti `lib/main.dart`.
3. Tambahkan `docs/AVORA_STAGE_6_ORDERS.sql`.
4. Jalankan SQL tersebut sekali di Supabase SQL Editor.

Jangan pernah memasukkan `sb_secret_...` ke aplikasi mobile.
