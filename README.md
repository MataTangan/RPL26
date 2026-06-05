# 🛒 rpl-befe-nyambung

> Proyek tugas mata kuliah **Rekayasa Perangkat Lunak (RPL)** — aplikasi e-commerce/marketplace berbasis web dengan koneksi frontend dan backend yang terintegrasi.

---

## 📌 Deskripsi

Aplikasi marketplace yang memungkinkan pengguna untuk menjual dan membeli produk secara online. Dibangun menggunakan **Next.js** sebagai fullstack framework dengan database **PostgreSQL/MySQL** sebagai penyimpanan data.

---

## 🧰 Tech Stack

| Layer      | Teknologi                     |
|------------|-------------------------------|
| Frontend   | Next.js (React)               |
| Backend    | Next.js API Routes            |
| Database   | PostgreSQL / MySQL            |
| ORM        | Prisma *(jika digunakan)*     |
| Styling    | Tailwind CSS *(jika digunakan)* |

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat

Pastikan sudah terinstall:

- [Node.js](https://nodejs.org/) >= 18.x
- [npm](https://www.npmjs.com/) atau [yarn](https://yarnpkg.com/)
- PostgreSQL / MySQL (lokal atau cloud)

---

### 1. Clone Repository

```bash
git clone https://github.com/MataTangan/rpl-befe-nyambung.git
cd rpl-befe-nyambung
```

### 2. Install Dependencies

```bash
npm install
# atau
yarn install
```

### 3. Konfigurasi Environment

Buat file `.env` di root project berdasarkan template `.env.example`:

```bash
cp .env.example .env
```

Isi variabel berikut di `.env`:

```env
# Database
DATABASE_URL="postgresql://USER:PASSWORD@localhost:5432/nama_database"
# atau MySQL:
# DATABASE_URL="mysql://USER:PASSWORD@localhost:3306/nama_database"

# Next.js
NEXTAUTH_SECRET="your-secret-key"
NEXTAUTH_URL="http://localhost:3000"

# Tambahkan variabel lain sesuai kebutuhan
```

### 4. Migrasi Database

```bash
# Jika menggunakan Prisma
npx prisma migrate dev --name init

# Jalankan seed (opsional)
npx prisma db seed
```

### 5. Jalankan Development Server

```bash
npm run dev
# atau
yarn dev
```

Buka [http://localhost:3000](http://localhost:3000) di browser.

---

## 📁 Struktur Folder

```
rpl-befe-nyambung/
├── app/                  # Next.js App Router
│   ├── api/              # API Routes (backend)
│   └── (pages)/          # Halaman frontend
├── components/           # Komponen UI reusable
├── lib/                  # Konfigurasi database, auth, dll
├── prisma/               # Schema dan migrasi database
│   └── schema.prisma
├── public/               # Aset statis
├── .env.example          # Template environment variables
├── next.config.js
└── package.json
```

---

## ✨ Fitur

- 🔐 Autentikasi pengguna (register & login)
- 🛍️ Listing produk
- 🛒 Keranjang belanja
- 📦 Manajemen pesanan
- 🧑‍💼 Dashboard penjual
- 📱 Responsive design

---

## 👥 Anggota Tim

| Nama | Role |
|------|------|
| *(Nama 1)* | Frontend Developer |
| *(Nama 2)* | Backend Developer |
| *(Nama 3)* | Database & Dokumentasi |

> Perbarui tabel ini dengan nama anggota kelompok yang sebenarnya.

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik — **Tugas Besar Mata Kuliah RPL**.

---

<p align="center">Made with ❤️ by MataTangan</p>
