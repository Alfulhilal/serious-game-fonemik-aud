# Panduan Aset Audio (Voice Over, SFX, & BGM)

Folder ini digunakan untuk menampung berkas suara pada game.

### Struktur Subfolder:
- `phonemes/`: Berkas rekaman bunyi fonem vokal dan konsonan.
  - Format: **WAV 16-bit 44.1 kHz Mono**
  - Standar Normalisasi: **-1.0 dB LUFS**
  - Contoh: `vowel_a.wav`, `vowel_i.wav`, `cons_b.wav`, `cons_m.wav`.
  - *Perhatian Khusus*: Bunyi fonem harus dilafalkan murni oleh penutur asli tanpa imbuhan bunyi 'e' (schwa), misalnya /b/ bukan "be", /m/ bukan "em".
- `words/`: Pelafalan utuh kata pemicu (contoh: `word_apel.wav`, `word_buku.wav`, `word_kuku.wav`).
- `sfx/`: Efek suara interaksi (contoh: `click.wav`, `cheer.wav`, `balloon_pop.wav`, `gentle_miss.wav`).
- `bgm/`: Musik latar ceria anak-anak (Format: **OGG Vorbis 128 kbps Stereo**).
