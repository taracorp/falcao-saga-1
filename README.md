# Falcao Saga

> Match-3 Puzzle Game · PSS Sleman · Collect the Legacy

---

## Tentang Game

**Falcao Saga** adalah game match-3 puzzle bertema **PSS Sleman**, klub sepak bola kebanggaan Daerah Istimewa Yogyakarta. Game ini menggabungkan mekanik klasik Candy Crush dengan sistem koleksi kartu pemain dan jersey dari seluruh sejarah PSS — mulai era Super League 2026 mundur hingga era legendaris 1976, tahun berdirinya klub.

Maskot game: **Falcao**, seekor Elang Jawa — simbol **Super Elang Jawa** — yang memandu pemain sepanjang perjalanan melintasi waktu.

---

## Fitur Utama

### 🎮 Match-3 Puzzle
Grid 8×8 bertema sepak bola PSS. Susun 3+ item sejenis untuk mencetak skor. Combo spesial menghasilkan power-up:
- **Tendangan Falcao** — hancurkan 1 baris penuh
- **Gol Spektakuler** — hancurkan semua item 1 warna
- **Bom Suporter** — hancurkan area 3×3
- **Yel-Yel BCS** — hancurkan 1 kolom + 1 baris

### 📇 Koleksi Kartu Pemain (Misi Utama)
Kumpulkan **200+ kartu pemain** PSS dari **12 season**, berjalan mundur dari era termodern ke era paling legendaris:
1. Super League (2024-2026)
2. Liga 1 Modern (2021-2023)
3. Debut Liga 1 (2018-2020)
4. ISC B & Liga 2 (2015-2017)
5. Juara Umum (2012-2014)
6. Profesional Awal (2008-2011)
7. Gempa & Maguwoharjo (2005-2007)
8. Puncak Prestasi (2001-2004)
9. Promosi ke Divisi Utama (1996-2000)
10. Dominasi Divisi II (1990-1995)
11. Fondasi (1983-1989)
12. **Legenda 1976** — Ultimate Tier

5 tingkat kelangkaan: Common → Rare → Epic → Legendary → **Mythic** (foil)

### 👕 Koleksi Jersey Mockup
24 jersey (12 home + 12 away) dari setiap era — didapat dari achievement spesial.

### 🏆 Leaderboard & Kompetisi
- **Mingguan** — Top 10 dapat hadiah koin + rare pack
- **Bulanan** — Top 50 dapat kartu eksklusif
- **All-Time** — Badge permanen + undangan event spesial PSS

### 🛒 Shop & Redeem RPP
- **Koin**: beli power-up, card pack, item kosmetik
- **RPP (Redeem Premium Points)**: dikumpulkan dari pencapaian in-game, **tidak bisa dibeli** — ditukar dengan hadiah nyata:

| Hadiah | RPP |
|--------|-----|
| Stiker PSS Digital | 50 |
| Wallpaper Eksklusif | 100 |
| Gantungan Kunci PSS | 500 |
| Syal PSS Sleman | 1.000 |
| Jersey PSS Original | 3.000 |
| Tiket Pertandingan Gratis | 5.000 |
| Meet & Greet Pemain | 10.000 |
| Nama Kamu di Jersey PSS | 25.000 |

---

## Teknologi

| Layer | Teknologi |
|-------|-----------|
| **Game Engine** | Godot 4.7 (GDScript) |
| **Backend** | Supabase (PostgreSQL + Auth + Realtime) |
| **Infrastruktur** | Self-hosted VPS (31.97.49.146) via Coolify |
| **Asset Grafis** | SVG dari game-icons.net (CC-BY) |
| **Platform** | Android (APK ~50MB) |
| **Build** | CLI — tanpa Android Studio |

---

## Build

```bash
source setup.sh
godot --headless --path . --export-release "Android" build/falcao-saga.apk
```

Requirements: Godot 4.7, JDK 17, Android SDK 34, NDK 25

---

## Tim

Game ini dibuat untuk komunitas suporter **PSS Sleman** — **Slemania** & **Brigata Curva Sud 1976**.

*"Sampai Kau Bisa"* 🦅
