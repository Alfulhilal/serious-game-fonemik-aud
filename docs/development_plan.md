# Development Plan & Task Backlog
Proyek: Serious Game Pra-Literasi Fonemik AUD berbasis Framework MDA

Dokumen pengembangan teknis lengkap tersimpan di:
[development_plan_and_tasks.md (Artefak)](file:///C:/Users/riyan/.gemini/antigravity/brain/485c7e4e-484f-4e6c-9432-93378ddad8c0/development_plan_and_tasks.md)

---

## Matriks Teknologi yang Digunakan (Technology Stack)

| Kategori | Teknologi / Perangkat Lunak | Versi / Spesifikasi | Peran & Justifikasi Teknis |
| :--- | :--- | :--- | :--- |
| **Game Engine** | **Godot Engine** *(Opsi Utama)* <br>*Alternatif: Unity 2022.3 LTS* | v4.3 LTS (Renderer: *Compatibility / OpenGL ES 3.0*) | Sangat ringan, ukuran runtime APK kecil (< 40 MB), *cold-start* instan (< 3 detik) pada tablet sekolah/HP spek rendah (*low-end*), tidak memungut royalti/bebas lisensi. |
| **Bahasa Pemrograman** | **GDScript** (Godot) <br>*(atau C# .NET 8 jika Unity)* | Godot 4.3 Type-Hinted GDScript | *Statically typed hints* (`var score: int`) untuk mencegah *runtime error*, performa komputasi ringan, dan iterasi pembuatan mini-game yang cepat. |
| **Audio Processing Pipeline** | **Audacity** & **FFmpeg** | Audacity v3.4+, FFmpeg v6.x | Perekaman *Voice Over (VO)* penutur asli bahasa Indonesia, normalisasi audio (-1.0 dB LUFS), *noise reduction*, dan penghilangan desis (*de-essing*) agar artikulasi fonem murni tanpa bunyi pengikut (*schwa*). |
| **Format Aset Audio** | **WAV & OGG Vorbis** | • Fonem & SFX: WAV 16-bit 44.1 kHz Mono <br>• BGM: OGG Vorbis 128 kbps Stereo | WAV Mono dimuat penuh ke memori RAM (*Stream = False*) untuk menjamin latensi pemutaran instan (< 30 ms) saat anak menyentuh huruf. OGG untuk musik latar hemat memori. |
| **Desain Grafis & Aset 2D** | **Figma**, **Adobe Illustrator / Inkscape** | Vektor Flat Art & Asset Atlas | Pembuatan antarmuka ramah anak (tombol $\ge 64\text{dp}$, palet warna pastel/ramah sensorik AUD). Aset diekspor dalam format *Sprite Atlas* untuk menekan *Draw Calls*. |
| **Animasi 2D** | **Godot AnimationPlayer / Tween System** | Built-in Node System | Efek pergerakan lembut (balon mengambang, karakter maskot melompat, *wiggle hint* saat anak bingung) tanpa membebani GPU perangkat. |
| **Sistem Basis Data & Log Riset** | **SQLite (godot-sqlite)** & **JSON File Storage** | SQLite 3.x / JSON RFC 8259 | Menyimpan data profil siswa, riwayat bintang/stiker, serta log pencatatan eksperimen riset (*timestamp*, waktu reaksi, jumlah galat) secara lokal dan *offline*. |
| **Format Ekspor Data Riset** | **CSV (Comma-Separated Values)** | RFC 4180 Standard | Memfasilitasi guru/peneliti mengunduh log metrik belajar anak untuk langsung diolah di software statistik (SPSS, R, Jamovi, MS Excel). |
| **Target Platform & OS** | **Android OS** | • Min SDK: Android 8.0 (API 26)<br>• Target SDK: Android 14 (API 34) | Kompatibel dengan 95%+ gawai tablet dan smartphone yang umum dimiliki sekolah PAUD/TK dan orang tua murid di Indonesia. |
| **Arsitektur CPU** | **ARM64-v8a & ARMv7a** | 32-bit & 64-bit | Menjamin kompatibilitas pada perangkat tablet sekolah lama (32-bit) maupun gawai modern (64-bit). |
| **Resolusi Layar & Rasio** | **Adaptive Canvas Scaling** | Basis: $1920 \times 1080$ (16:9 Landscape) <br>Mode: `canvas_items`, Aspect: `expand` | Tampilan responsif otomatis tanpa *black-bar* kasar pada tablet 16:10 (seperti Samsung Galaxy Tab A) maupun smartphone modern 20:9. |
| **Version Control & Repo** | **Git & GitHub / GitLab** | Git 2.4x + Git LFS | Manajemen versi kode sumber dan pelacakan aset media biner (audio WAV & ilustrasi resolusi tinggi) menggunakan Git LFS. |
| **Alat Pengujian & Profiling** | **Android Studio (Logcat)** & **Godot Profiler** | Android SDK Platform Tools 34+ | Memantau penggunaan memori RAM (dibatasi $\le 200$ MB), *Draw Calls* ($\le 40$), dan memastikan kestabilan *frame rate* (60 FPS). |

---

## Ringkasan Sprint Teknis

- **Sprint 0**: Setup Engine & Multi-Resolution Scaling (DEV-001 s.d DEV-003)
- **Sprint 1**: AudioManager Fonem & Core State Machine (DEV-004 s.d DEV-006)
- **Sprint 2**: Mini-Game 1 "Kebun Vokal" - Isolasi Vokal (DEV-007 s.d DEV-009)
- **Sprint 3**: Mini-Game 2 "Balon Rima" - Deteksi Rima Kata (DEV-010 s.d DEV-012)
- **Sprint 4**: Mini-Game 3 "Rumah Huruf" - Asosiasi Fonem-Grafem (DEV-013 s.d DEV-014)
- **Sprint 5**: Dynamics Layer & Reward System / Album Stiker (DEV-015 s.d DEV-017)
- **Sprint 6**: Panel Guru/Peneliti & Logging Data Riset CSV (DEV-018 s.d DEV-020)
- **Sprint 7**: Optimasi Tablet Low-End, QA Blackbox, & Alpha APK (DEV-021 s.d DEV-024)
