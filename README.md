# Course Data Manager (UTS Pemrograman Mobile)

Aplikasi manajemen data mata kuliah interaktif berbasis Flutter yang mendukung pengelolaan katalog mata kuliah, pencatatan favorit, serta integrasi database cloud Supabase secara *real-time*.

---

## 👤 Identitas Mahasiswa

- **Nama**: Jamilatul Amalia
- **NIM**: 2415051107
- **Kelas**: Pemrograman Mobile

---

## ✨ Daftar Fitur Utama

1. **Dashboard Statistik (`HomeScreen`)**: Menampilkan ringkasan statistik data dan rekomendasi mata kuliah.
2. **Katalog Mata Kuliah (`CourseListPage`)**: Menampilkan daftar mata kuliah berbasis `ListView`/`GridView` yang responsif.
3. **Detail Mata Kuliah (`CourseDetailPage`)**: Menampilkan rincian informasi mata kuliah yang dipilih secara lengkap.
4. **Tambah Data (`AddCoursePage`)**: Form interaktif dengan validasi input untuk menambah mata kuliah baru.
5. **Edit Data (`EditCoursePage`)**: Form untuk memperbarui data mata kuliah yang sudah ada berdasarkan ID.
6. **Hapus Data dengan Konfirmasi**: Menghapus mata kuliah disertai `AlertDialog` konfirmasi keamanan.
7. **Daftar Favorit (`FavoritesPage`)**: Fitur menandai dan melihat daftar mata kuliah favorit secara tersinkronisasi.
8. **Profil Mahasiswa (`ProfilePage`)**: Informasi identitas pengembang dan versi aplikasi.

---

## 🛠️ Tech Stack & Library

- **Framework**: Flutter (Dart)
- **State Management**: Provider (`ChangeNotifier`)
- **Backend & Database**: Supabase (PostgreSQL)
- **UI Components**: Material Design 3 (Responsive Layout)

---

## 📡 REST API & Backend Database

- **Backend**: Supabase Database Service
- **REST API Endpoint**: Standard Supabase RESTful API Client
- **Operasi HTTP**:
  - `GET`: Mengambil daftar dan detail mata kuliah
  - `POST`: Menambah data mata kuliah baru
  - `PATCH` / `PUT`: Memperbarui data mata kuliah
  - `DELETE`: Menghapus data mata kuliah

---

## 🏗️ Struktur Arsitektur Aplikasi

Aplikasi ini menerapkan prinsip *Clean Architecture* sederhana:

```text
lib/
├── models/         # Class Model Dart (CourseModel) & JSON Serializer
├── services/       # Koneksi mentah Supabase Client & REST API
├── repositories/   # Abstraksi data layer / mediator
├── providers/      # State Management (CourseProvider)
├── screens/        # Halaman-halaman UI (HomeScreen, CourseListPage, dll)
├── widgets/        # Component UI modular yang dapat digunakan kembali
└── main.dart       # Titik masuk utama aplikasi & inisialisasi Provider