# Game PRD — Falcao Saga

## 1. Overview

| Item | Detail |
|------|--------|
| **Judul Game** | Falcao Saga |
| **Platform** | Android |
| **Genre** | Match-3 Puzzle × Collectible Card Game × Live Service |
| **Engine** | Godot 4.7 (Client) |
| **Backend** | Supabase (PostgreSQL + Auth + Realtime + Edge Functions) |
| **Infra** | VPS 31.97.49.146 (Opsional: custom services, admin panel) |
| **Bahasa** | Indonesia (opsi English) |
| **Target User** | Suporter PSS Sleman, kolektor memorabilia sepakbola, gamer kasual |

---

## 2. Konsep & Tema

**Falcao Saga** adalah game match-3 endless bertema **PSS Sleman** dengan **tiga pilar ekonomi**:

1. **Koleksi** — mengoleksi kartu pemain & jersey dari season ke season (mundur dari 2026 ke 1976)
2. **Kompetisi** — leaderboard global & antar sesama suporter
3. **Reward Nyata** — redeem poin untuk merchandise PSS, tiket pertandingan, pengalaman eksklusif

Maskot game: **Falcao**, Elang Jawa — simbol Super Elang Jawa, pemandu sepanjang permainan.

### Palet Warna
- **Hijau** (#006837) — warna utama PSS Sleman
- **Putih** (#FFFFFF) — sekunder
- **Emas** (#FFD700) — aksen prestasi
- **Hitam** (#1A1A1A) — kontras

---

## 3. Game Economy (Tiga Pilar)

```
         MAIN MATCH-3
              ↓
    ┌─────────┼─────────┐
    ↓         ↓          ↓
  Poin      Koin      XP Card
    ↓         ↓          ↓
Leaderboard  Shop     Level Up
    ↓      ┌──┴──┐    Card
 Ranking   │     │
    │   Card   Redeem
    │   Packs  Merchandise
    │          Tiket PSS
    │
 Hadiah Leaderboard
 (tiap akhir season)
```

---

### 3A. Pilar 1 — Point & Leaderboard

#### Cara Dapat Poin
| Aksi | Poin |
|------|------|
| Selesai 1 level (bintang 1) | +10 XP Leaderboard |
| Selesai level (bintang 3) | +30 XP Leaderboard |
| Combo 4-in-a-row | +5 XP |
| Combo 5-in-a-row | +15 XP |
| Koleksi kartu baru | +50 XP |
| 100% koleksi 1 season | +500 XP |
| Daily challenge selesai | +25 XP |
| Win streak 3 level berturut-turut | Bonus 2x XP |

#### Leaderboard
| Kategori | Reset | Hadiah |
|----------|-------|--------|
| **Mingguan** | Setiap Senin 00:00 WIB | Top 10: koin 200-1000 + 1 Rare Pack |
| **Bulanan** | Setiap awal bulan | Top 50: koin + Exclusive Card + jersey spesial |
| **All-Time** | Tidak pernah reset | Top 100: badge permanen + undangan event spesial PSS |

#### Tampilan Leaderboard
- Nama player + avatar (jersey yang dipakai)
- Rank, total XP, jumlah kartu dikoleksi
- Filter: Global / Teman / Region (Jogja-Solo-Semarang)
- Bisa tap nama player untuk lihat profil & koleksi mereka

---

### 3B. Pilar 2 — Koin & Shop

#### Cara Dapat Koin
| Aksi | Koin |
|------|------|
| Selesai 1 level | 20-50 koin (tergantung bintang) |
| Kartu duplikat otomatis | 10-50 koin (tergantung rarity) |
| Daily login (streak) | 20 × hari streak |
| Daily challenge | 100 koin |
| Nonton iklan rewarded | 50 koin |
| Peringkat leaderboard mingguan | 200-1000 koin |

#### Shop — Beli dengan Koin

| Kategori | Item | Harga (Koin) |
|----------|------|-------------|
| **Power-Up** | +5 Moves | 200 |
| | Hammer (hancurkan 1 cell) | 150 |
| | Bom Suporter (area 3×3) | 300 |
| | +3 Nyawa | 500 |
| **Card Pack** | Common Pack (5 kartu, 1 guaranteed Rare) | 500 |
| | Premium Pack (5 kartu, 1 guaranteed Epic+) | 1.500 |
| | Season Pack (5 kartu dari season spesifik) | 2.000 |
| **Cosmetic** | Avatar Frame (warna spesial) | 1.000 |
| | Badge "Pendiri PSS" | 5.000 |
| | Efek hancurkan spesial | 2.000 |

---

### 3C. Pilar 3 — Redeem Poin Premium (RPP)

Inilah sistem yang membedakan Falcao Saga: **poin yang dikumpulkan bisa ditukar dengan hadiah nyata.**

#### Cara Dapat RPP (Redeem Premium Points)
RPP **tidak bisa dibeli** — hanya dari pencapaian in-game:

| Aksi | RPP |
|------|-----|
| Koleksi 100% 1 season | +100 RPP |
| Top 10 leaderboard mingguan | +50 RPP |
| Top 10 leaderboard bulanan | +200 RPP |
| Login streak 30 hari | +30 RPP |
| Win streak 10 level tanpa gagal | +20 RPP |
| Ajak teman install (referral) | +50 RPP per teman |
| Event spesial (HUT PSS, Derby, dll) | Variable |

#### Katalog Redeem RPP

| Tier | Hadiah | RPP Dibutuhkan | Stok |
|------|--------|---------------|------|
| 🥉 | Stiker PSS digital (WhatsApp) | 50 RPP | Unlimited |
| 🥉 | Wallpaper eksklusif HP | 100 RPP | Unlimited |
| 🥈 | Kartu foil legendary acak | 200 RPP | Unlimited |
| 🥈 | Jersey in-game eksklusif | 300 RPP | Unlimited |
| 🥇 | **Gantungan kunci PSS** | 500 RPP | ~50/bln |
| 🥇 | **Syal/scarf PSS Sleman** | 1.000 RPP | ~20/bln |
| 🥇 | **Poster bertanda tangan pemain** | 1.500 RPP | ~10/bln |
| 🏆 | **Jersey PSS original** | 3.000 RPP | ~5/bln |
| 🏆 | **Tiket pertandingan PSS (gratis)** | 5.000 RPP | ~2/bln |
| 👑 | **Meet & Greet pemain PSS** | 10.000 RPP | Event khusus |
| 👑 | **Nama kamu di jersey PSS (1 pertandingan)** | 25.000 RPP | 1/musim |

#### Alur Redeem
1. Player pilih hadiah → klik "Redeem"
2. Sistem verifikasi RPP cukup
3. Player isi form pengiriman (untuk hadiah fisik)
4. Admin PSS / game admin verifikasi & kirim
5. Player dapat notifikasi + tracking

---

## 4. Sistem Koleksi #1 — Kartu Pemain

### 4.1 Konsep

12 Season (mundur dari 2026 ke 1976). Setiap season punya **pool 15-20 kartu**. Player membuka season lebih tua dengan mengoleksi 50% kartu season saat ini.

**Urutan: Season 1 (terbaru) → Season 2 → ... → Season 12 (1976).**

### 4.2 12 Season

#### 🟢 Season 1: Super League (2024–2026)

| Musim | Kompetisi | Hasil |
|-------|-----------|-------|
| 2024-25 | Liga 1 | Peringkat 16 — Degradasi |
| 2025-26 | Championship | Runner-up — Promosi Super League ⬆️ |
| 2026-27 | Super League | Kembali ke kasta tertinggi |

**Pool (15-20 kartu):** Pieter Huistra ⭐, Fachruddin Aryanto (C), Kim Kurniawan, Kevin Gomes, Gustavo Tocantins, Frédéric Injaï, Hiromu Tanaka, Cleberson, Dimas Drajad, Riko Simanjuntak, Hanif Sjahbandi, Figo Dennis, Ega Rizky, Safaat Romadhona, Yoni Arseto

#### 🟢 Season 2: Liga 1 Modern (2021–2023)

| Musim | Hasil |
|-------|-------|
| 2021 | Piala Menpora — Juara 3 🏆 |
| 2021-22 | Liga 1 — Peringkat 13 |
| 2022 | Piala Presiden — Semifinalis 🏆 |
| 2022-23 | Liga 1 — Peringkat 16 |
| 2023-24 | Liga 1 — Peringkat 13 |

**Pool:** Seto Nurdiantoro, Irkham Mila ⭐, Kim Kurniawan, + riset lanjutan

#### 🟢 Season 3: Debut Liga 1 (2018–2020)

| Musim | Hasil |
|-------|-------|
| 2018 | Liga 2 — Juara 1 → Promosi Liga 1 ⬆️🏆 |
| 2019 | Liga 1 — Peringkat 8 (debut!) |
| 2020 | Liga 1 — Terhenti COVID-19 🦠 |

**Pool:** Seto Nurdiantoro ⭐, Eduardo Perez, + riset lanjutan

#### 🟢 Season 4: ISC B & Liga 2 (2015–2017)

| Musim | Hasil |
|-------|-------|
| 2015 | Kompetisi dihentikan |
| 2016 | ISC B — Runner Up 🥈 |
| 2017 | Liga 2 — 16 Besar |

**Pool:** Seto Nurdiantoro, Freddy Mulli, Herry Kiswanto, + riset

#### 🟡 Season 5: Juara Umum (2012–2014)

| Musim | Hasil |
|-------|-------|
| 2012 | PT Putra Sleman Sembada terbentuk 🏢 |
| 2013 | Divisi Utama — **JUARA UMUM** 🏆⭐ |
| 2014 | Divisi Utama — 8 Besar |

#### 🟡 Season 6: Profesional Awal (2008–2011)

| 2008/09 | Divisi Utama — 8 Timur |
| 2009/10 | Divisi Utama — 10 Grup 3 |
| 2010/11 | Divisi Utama — 10 Grup 3 |
| 2011/12 | Divisi Utama — 7 Grup 2 |

**Pool:** Iwan Setiawan, Maman Durachman, Yance Efraim Matmey, M. Basri, Widyantoro

#### 🟡 Season 7: Gempa & Maguwoharjo (2005–2007)

| 2005 | DU — 7 Wil I, Piala Indo Semifinal 🏆 |
| 2006 | Mundur — Gempa Yogyakarta 💔 |
| 2007 | Pindah ke Stadion Maguwoharjo 🏟️ |

**Pool:** Mundari Karya, Herry Kiswanto, Horacio Alberto Montes, Rudy William Keltjes

#### 🟠 Season 8: Puncak Prestasi (2001–2004)

| 2001 | DU — 10 Timur (*kalahkan Pelita Solo 2-1*) |
| 2002 | DU — 7 Timur |
| 2003 | DU — **Peringkat 4 Nasional** 🏆 |
| 2004 | DU — Peringkat 4 |

**Pool:** Suharno, Yudi Suryata, Daniel Roekito ⭐, Ibnu Subiyanto

#### 🟠 Season 9: Promosi ke Divisi Utama (1996–2000)

| 1996/97 | Divisi Satu — 10 Besar |
| 1999/2000 | Divisi Satu — **Peringkat 2 → PROMOSI** ⬆️⭐ |

**Pool:** M. Eksan ⭐ (11 gol), Slamet Riyadi, M. Ansori, Fajar Listiyantoro, M. Muslih, Bambang Nurdjoko, Herwin Sjahruddin, Sukidi Cakrasuwignya, Arifin Ilyas

#### 🟠 Season 10: Dominasi Divisi II (1990–1995)

| 1990/91 | Div IIA Jateng-DIY — 6 |
| 1993/94 | Div II Nasional — 8 Besar |
| 1995/96 | Div Dua — Promosi ke Divisi Satu ⬆️ |

**Pool:** Suwarno ⭐, H. RM. Tirun Marwito

#### 🔴 Season 11: Fondasi (1983–1989)

| 1983-89 | Divisi II DIY — Juara 7x berturut-turut |

**Pool:** Drs. R. Subardi Pd, Letkol Inf. Suhartono

#### 🔴 Season 12: Legenda 1976 (1976–1982) — ULTIMATE

| 20 Mei 1976 | **PSS Sleman didirikan** 🏁 |
| 10 Agt 1976 | Debut: PSS 1-0 Persig Gunungkidul |
| 1979 | Debut Divisi II — Juara |

**Pool:** H. Suryo Saryono ⭐, Gafar Anwar, Sugiarto SY, Subardi, Sudarsono KH ⭐, Hartadi, Drs. Suyadi, 5 Klub Pendiri (PS Mlati, AMS Seyegan, PSK Kalasan, Godean Putra, PSKS Sleman), Falcao (Elang Jawa) 🦅 — **Mythic**

### 4.3 Rarity

| Tier | Warna | Drop Rate | Contoh |
|------|-------|-----------|--------|
| Common | Abu-abu | 50% | Squad player biasa |
| Rare | Biru | 30% | Starter reguler |
| Epic | Ungu | 13% | Top skor, kapten |
| Legendary | Emas | 5% | Pelatih juara, tokoh |
| Mythic | Pelangi foil | 2% | 1976 founders, Falcao |

### 4.4 Progresi Unlock

| Kondisi | Efek |
|---------|------|
| Koleksi 50% Season N | Unlock Season N+1 |
| Koleksi 100% Season N | Badge "Complete" + bonus RPP |
| Semua 12 season 100% | Gelar "Sejarawan PSS" + 500 RPP |

---

## 5. Sistem Koleksi #2 — Jersey Mockup

### 5.1 Konsep
Setiap season: 1 jersey home + 1 jersey away (total 24 jersey). Didapat dari achievement:

| Trigger | Reward |
|---------|--------|
| Bintang 3 semua level season | Jersey Home season itu |
| Koleksi 100% kartu season | Jersey Away season itu |
| Redeem RPP | Jersey eksklusif edisi terbatas |

### 5.2 Lemari Jersey
- Tampilan ruang ganti pemain
- Jersey yang dimiliki → full render + nama season
- Bisa dipakai sebagai **avatar di leaderboard**

---

## 6. Gameplay Core

### 6.1 Match-3
- Grid 8×8, swap 2 item bersebelahan → 3+ match → meledak
- Item jatuh dari atas isi kekosongan
- Combo: 4/5-in-a-row, L-shape, T-shape → power-up

### 6.2 Item (SVG Custom dari game-icons.net)

| No | Nama | Icon Key |
|----|------|----------|
| 1 | Bola PSS | `soccer-ball` |
| 2 | Elang Jawa | `eagle-emblem` |
| 3 | Stadion | `stadium` |
| 4 | Jersey | `t-shirt` |
| 5 | Trofi | `trophy-cup` |
| 6 | Bintang | `star-medal` |

### 6.3 Power-Up

| Combo | Nama | Efek |
|-------|------|------|
| 4 row | **Tendangan Falcao** | Hancurkan 1 baris |
| 5 row | **Gol Spektakuler** | Hancurkan 1 warna |
| L-shape | **Bom Suporter** | Hancurkan 3×3 |
| T-shape | **Yel-Yel BCS** | Hancurkan kolom+baris |

### 6.4 Obstacle
Lumpur Lapangan, Kartu Merah, Jaring Gawang, Bom Waktu Wasit

---

## 7. Backend Architecture (Supabase)

### 7.1 Database Schema

```sql
-- Users (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users,
  username TEXT UNIQUE NOT NULL,
  avatar_jersey_id INT,
  total_xp INT DEFAULT 0,
  total_coins INT DEFAULT 0,
  total_rpp INT DEFAULT 0,
  current_season INT DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Card ownership
CREATE TABLE player_cards (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id),
  card_id INT NOT NULL,           -- 1-200
  quantity INT DEFAULT 1,          -- for duplicates
  is_foil BOOLEAN DEFAULT false,
  acquired_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(profile_id, card_id)
);

-- Jersey ownership
CREATE TABLE jerseys (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id),
  jersey_id INT NOT NULL,
  acquired_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(profile_id, jersey_id)
);

-- Leaderboard snapshots
CREATE TABLE leaderboard_weekly (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id),
  xp INT NOT NULL,
  rank INT,
  week_start DATE NOT NULL
);

-- Transaction log
CREATE TABLE point_transactions (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id),
  type TEXT NOT NULL,              -- 'coin_earn', 'coin_spend', 'rpp_earn', 'rpp_spend'
  amount INT NOT NULL,
  source TEXT,                     -- 'level_complete', 'duplicate_card', 'leaderboard_reward', 'redeem'
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Redeem catalog
CREATE TABLE reward_catalog (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  rpp_cost INT NOT NULL,
  tier TEXT,                       -- 'bronze', 'silver', 'gold', 'diamond', 'crown'
  stock_total INT,
  stock_remaining INT,
  is_active BOOLEAN DEFAULT true,
  image_url TEXT
);

-- Redemption orders
CREATE TABLE redemptions (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id),
  reward_id INT REFERENCES reward_catalog(id),
  status TEXT DEFAULT 'pending',   -- 'pending', 'verified', 'shipped', 'delivered', 'cancelled'
  shipping_info JSONB,
  admin_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Weekly/daily challenges
CREATE TABLE challenges (
  id SERIAL PRIMARY KEY,
  type TEXT,                       -- 'daily', 'weekly'
  description TEXT NOT NULL,
  target INT NOT NULL,
  reward_coins INT,
  reward_rpp INT,
  starts_at TIMESTAMPTZ,
  ends_at TIMESTAMPTZ
);

-- Player challenge progress
CREATE TABLE challenge_progress (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id),
  challenge_id INT REFERENCES challenges(id),
  current INT DEFAULT 0,
  completed BOOLEAN DEFAULT false,
  UNIQUE(profile_id, challenge_id)
);
```

### 7.2 Row Level Security (RLS)
- Player hanya bisa baca/tulis data sendiri
- Leaderboard read-only untuk semua authenticated users
- Reward catalog read-only
- Redemption write-only untuk player, read+write untuk admin

### 7.3 Edge Functions (Serverless)
- `calculate-leaderboard` — cron job setiap Senin hitung ranking mingguan
- `verify-redemption` — admin panel verifikasi redeem hadiah fisik
- `daily-reset` — reset daily challenge setiap 00:00 WIB
- `sync-card-collection` — validasi kartu yang dikoleksi

### 7.4 Realtime Subscriptions
- Leaderboard update live
- Notifikasi: "Kartu baru!", "Redeem disetujui!", "Event spesial!"

---

## 8. Monetisasi

| Item | Harga |
|------|-------|
| Koin Pack (5.000 koin) | Rp 15.000 |
| Koin Pack (25.000 koin) | Rp 50.000 |
| Premium Pack (5 kartu, Epic guaranteed) | Rp 25.000 |
| Season Pass (bonus XP + exclusive jersey) | Rp 29.000/bulan |
| Starter Bundle (500 koin + 3 Premium Pack) | Rp 10.000 |
| RPP Booster (2x RPP selama 24 jam) | Rp 20.000 |

**Catatan:** RPP sendiri **tidak bisa dibeli langsung** — hanya bisa di-boost. Ini menjaga integritas reward nyata.

---

## 9. Admin Panel (Web Dashboard)

Akses via VPS / Supabase dashboard. Fitur:
- Verifikasi & tracking redeem hadiah fisik
- Manajemen stok katalog reward
- Lihat leaderboard & statistik
- Broadcast notifikasi ke semua player
- Manajemen event & challenge

Tech: Next.js / Svelte, deploy di VPS atau Vercel

---

## 10. MVP Scope (v1.0)

### Game Client (Godot)
- ✅ Match-3 core (grid, swap, match, combo)
- ✅ 6 item custom SVG
- ✅ 2 power-up
- ✅ Lives + skor + bintang
- ✅ **Season 1 & 2 terbuka** (30 kartu)
- ✅ Card pack + duplikat → koin
- ✅ Album PSS (galeri kartu)
- ✅ 4 jersey (S1+S2 Home+Away)
- ✅ Lemari Jersey
- ✅ Shop koin (power-up + card pack)
- ✅ **Leaderboard (global, mingguan)**
- ✅ **Redeem shop (in-game rewards dulu)**
- ✅ Auth login (Supabase)
- ✅ Splash screen Falcao + logo PSS

### Backend (Supabase)
- ✅ Auth (email + Google)
- ✅ Database tables (profiles, cards, jerseys, points, leaderboard)
- ✅ RLS policies
- ✅ Realtime leaderboard
- ✅ Edge functions (leaderboard calc, daily reset)

### MVP Belum Termasuk
- ❌ Redeem hadiah fisik (v1.1 — perlu kerjasama PSS)
- ❌ Season 3-12 full (rilis bertahap)
- ❌ Admin panel web (v1.1)
- ❌ IAP (v1.1)
- ❌ Season Pass (v1.2)
- ❌ 180+ kartu semua era (rilis bertahap per season)

---

## 11. Audio & Visual

### Asset Sources
| Tool | Fungsi |
|------|--------|
| **game-icons.net** | 4.000+ SVG icons CC-BY |
| **Lucide Icons** | Icon modern clean |
| **Kenney Assets** | Asset 2D/UI domain publik |
| **sempitern0/match3-board** | Library Godot match-3 |
| **luiz734/match3_game** | Referensi match-3 Godot 4 |

### Audio
- BGM Lobby: chant instrumen suporter PSS
- BGM Gameplay: drum & trumpet stadion
- SFX: swap, match, combo, "AYO PSS!", "GOOOL!", "Sampai Kau Bisa"

### Animasi
- Falcao terbang di combo besar
- Confetti hijau-putih di level complete
- Jersey turun dari atas saat didapat
- Kartu foil saat buka pack
- Ranking naik animasi di leaderboard

---

## 12. Teknis

| Aspek | Detail |
|-------|--------|
| Engine | Godot 4.7 (GDScript) |
| Backend | Supabase (PostgreSQL, Auth, Realtime) |
| API Client | Godot HTTPRequest + WebSocket |
| Infra | VPS 31.97.49.146 |
| Resolusi | 720×1280 portrait |
| FPS | 60 |
| APK Size | < 50 MB |
| Android Min | API 24 (Android 7.0) |
| Build | `godot --headless --export-release "Android"` |
| CI/CD | GitHub Actions → build APK → upload artifact |
| Git | `github.com/taracorp/falcao-saga.git` |

---

## 13. Timeline

| Tahap | Durasi |
|-------|--------|
| Setup Supabase schema + auth | 1-2 hari |
| Core match-3 + grid system | 3-4 hari |
| Godot ↔ Supabase integration | 2-3 hari |
| Asset creation (SVG custom) | 2-3 hari |
| UI: lobby, gameplay, shop, album, leaderboard | 3-4 hari |
| Level design (Season 1 + 2 = 20 level) | 2-3 hari |
| Leaderboard + point system | 1-2 hari |
| Shop + redeem system | 1-2 hari |
| Audio integration | 1-2 hari |
| Admin panel web | 2-3 hari |
| Test, QA, balance | 2-3 hari |
| Build APK + deploy backend | 1 hari |
| **Total** | **~21-32 hari** |
