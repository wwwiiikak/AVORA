# AVORA — Tahap 5: Supabase + Auth

Paket ini menghubungkan prototype Flutter AVORA ke project Supabase AVORA.

Isi:
- `pubspec.yaml` — menambahkan `supabase_flutter`
- `lib/main.dart` — inisialisasi Supabase + login/daftar
- `docs/AVORA_DATA_API_GRANTS.sql` — grant Data API untuk role authenticated

Catatan keamanan:
- Aplikasi menggunakan publishable key, bukan secret key.
- Secret key `sb_secret_...` jangan dimasukkan ke aplikasi mobile atau GitHub.
- RLS tetap menjadi pengaman akses data.

Langkah setelah file masuk ke project Flutter:
1. Jalankan `flutter pub get`.
2. Jalankan aplikasi.
3. Uji Daftar.
4. Uji Masuk.
5. Setelah Auth berhasil, kita lanjut ke koneksi order, alamat, tarif, driver, tracking, dan admin.
