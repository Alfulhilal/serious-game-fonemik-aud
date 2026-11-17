# Serious Game Pra-Literasi Fonemik Anak Usia Dini (Berbasis Framework MDA)

Proyek penelitian dan pengembangan *serious game* untuk stimulasi pra-literasi fonemik anak usia dini (4–6 tahun) menggunakan pendekatan **Mechanics, Dynamics, Aesthetics (MDA) Framework**.

---

## 📁 Struktur Direktori Proyek

```plaintext
├── docs/
│   ├── research/          # Kajian literatur, analisis kurikulum PAUD, & telaah fonemik
│   ├── gdd/               # Game Design Document & rancangan MDA
│   └── instruments/       # Instrumen validasi ahli, lembar pre/post-test, & kuesioner UX
├── assets/
│   ├── audio/             # Voice over fonem, sfx, & background music
│   └── sprites/           # Ilustrasi karakter maskot, background tema, & UI elemen
├── src/                   # Kode sumber implementasi game
└── reports/               # Laporan kemajuan, tabulasi data eksperimen, & naskah publikasi
```

---

## 📌 Status Tahapan Kerja (Work Plan)

- [x] **Sprint 0: Setup Engine & Arsitektur Teknis**
  - [x] Konfigurasi multi-resolusi & canvas expand (`project.godot`)
  - [x] Konfigurasi audio bus (`Master`, `Music`, `SFX`, `Voice` dengan ducking)
  - [x] Setup struktur folder repositori modular & aset panduan
- [x] **Sprint 1: Audio Engine & Core Game Loop**
  - [x] `AudioManager.gd` (Ducking BGM otomatis & pemutaran fonem prioritas tinggi)
  - [x] `PhonemeDatabase.gd` (Katalog fonem vokal, konsonan, & rima bahasa Indonesia)
  - [x] `GameManager.gd` (State machine & pembatas waktu layar AUD)
  - [x] `ScaffoldingController.gd` (Bantuan adaptif bertingkat: audio hint & visual wiggle)
- [x] **Sprint 2: Mini-Game 1 — Kebun Vokal**
  - [x] Implementasi logika isolasi vokal awal (`KebunVokal.gd` & `.tscn`)
  - [x] Mekanisme *fail-soft* & animasi apresiasi tombol
- [x] **Sprint 3: Mini-Game 2 — Balon Rima**
  - [x] Implementasi pencocokan rima kata (`BalonRima.gd` & `.tscn`)
  - [x] Efek balon melayang & letusan pop ramah anak
- [x] **Sprint 6 (Komponen Riset): Panel Guru & Pencatat Data**
  - [x] `ResearchEventLogger.gd` (Pencatatan waktu reaksi, galat, & ekspor CSV otomatis)
  - [x] `TeacherPanel.gd` & `.tscn` (Panel guru terlindungi PIN)

---

## 📑 Dokumen Terkait
- [Rencana Kerja Detail (Work Plan)](file:///C:/Users/riyan/.gemini/antigravity/brain/485c7e4e-484f-4e6c-9432-93378ddad8c0/rencana_kerja_mda_serious_game.md)
- [Development Plan & Task Backlog](file:///C:/Users/riyan/.gemini/antigravity/brain/485c7e4e-484f-4e6c-9432-93378ddad8c0/development_plan_and_tasks.md)
- [Kajian Literatur & Analisis Kebutuhan](file:///d:/Penerapan%20Framework%20MDA%20pada%20Serious%20Game%20Pra-Literasi%20Fonemik%20Anak%20Usia%20Dini/docs/research/kajian_literatur_dan_analisis_kebutuhan.md)
