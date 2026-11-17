# Kajian Literatur & Analisis Kebutuhan Sistem
## Serious Game Pra-Literasi Fonemik AUD berbasis Framework MDA

---

### 1. Landasan Konseptual Pra-Literasi Fonemik AUD

#### 1.1 Perbedaan Kesadaran Fonologis, Fonemik, dan Fonik
Dalam pembelajaran membaca awal anak usia dini, sering terjadi kerancuan antara fonologis, fonemik, dan fonik:

```
[ Kesadaran Fonologis (Payung Besar) ]
 ├── Kepekaan Rima & Aliterasi
 ├── Kesadaran Kata & Kalimat
 ├── Kesadaran Suku Kata (Syllable Awareness)
 └── Kesadaran Fonemik (Phonemic Awareness)  <-- Fokus Game Ini
      ├── Isolasi Bunyi (Sound Isolation)
      ├── Identifikasi Bunyi (Sound Identification)
      ├── Penggabungan Bunyi (Blending)
      └── Segmentasi Bunyi (Segmentation)
           │
           ▼
[ Fonik / Phonics (Relasi Bunyi Fonem dengan Grafem/Huruf Tertulis) ]
```

> **Catatan Penting**:
> Anak usia dini (4–6 tahun) belum seharusnya langsung dipaksa mengeja huruf cetak. Kesadaran **fonemik** melatih **telinga dan persepsi auditori** anak untuk membedakan dan memanipulasi bunyi bahasa lisan sebelum/bersamaan dengan mengenalkan bentuk grafemnya.

#### 1.2 Taksonomi Keterampilan Fonemik untuk AUD (Bahasa Indonesia)
1. **Tingkat 1: Pengenalan Bunyi Vokal Awal (Vowel Isolation)**
   - Mendeteksi bunyi vokal di awal kata: /a/ pada "apel", /i/ pada "ikan", /u/ pada "udang", /e/ pada "ember", /o/ pada "obor".
2. **Tingkat 2: Pengenalan Bunyi Konsonan Kontinu & Stop (Consonant Isolation)**
   - Konsonan kontinu (mudah diperpanjang): /m/, /s/, /f/, /n/, /l/.
   - Konsonan letup (stop sounds): /b/, /p/, /d/, /t/, /k/.
3. **Tingkat 3: Kesadaran Rima & Kesamaan Akhiran (Rhyme & Ending Sounds)**
   - Mengenali kata yang berbunyi mirip di akhir (misal: *buku - kuku*, *mata - bata*).
4. **Tingkat 4: Penggabungan Sederhana (Blending Sederhana)**
   - Menggabungkan bunyi fonem menjadi suku kata terbuka (CV): /b/ + /u/ $\rightarrow$ "bu".

---

### 2. Integrasi Framework MDA (Mechanics, Dynamics, Aesthetics)

Pendekatan MDA diposisikan dari sudut pandang *Player-Centric* (anak AUD):

```
[Desainer Game] -> Mechanics -> Dynamics -> Aesthetics -> [Pemain: Anak AUD]
                <-  Evaluasi  <-   Siklus   <-  Emosi/Respon
```

#### 2.1 Aesthetics (Kebutuhan Pengalaman Emosional AUD)
- **Joy / Play**: Game terasa seperti mainan interaktif, bukan ujian atau tes sekolah.
- **Discovery**: Memberikan kejutan bunyi atau animasi lucu ketika anak mencoba menyentuh objek.
- **Competence / Pride**: Perasaan "aku bisa!" melalui umpan balik visual dan audio perayaan (*cheering*, bintang).
- **Safety / No-Fear-of-Failure**: Tidak ada hukuman layar merah, pengurangan nyawa, atau pesan "Kamu Gagal". Kesalahan ditanggapi dengan petunjuk lembut (*auditory scaffolding*).

#### 2.2 Dynamics (Perilaku Sistem saat Dijalankan)
- **Adaptive Auditory Scaffolding**: Jika anak tidak merespons dalam 5 detik atau memilih opsi yang keliru 2 kali berturut-turut, sistem otomatis mengulang bunyi fonem target dengan volume lebih jelas dan petunjuk visual berupa kedipan/goyangan lembut pada opsi yang benar.
- **Short-Burst Play Loop**: Sesi bermain per babak didesain 2–3 menit untuk menjaga fokus anak AUD yang memiliki rentang perhatian pendek (3–5 menit per rentang usia).
- **Audio-Visual Synchrony**: Setiap kali sebuah grafem/objek ditekan, audio fonemik terucap seketika (< 100ms latensi) untuk memperkuat pemetaan sensorik.

#### 2.3 Mechanics (Komponen & Aturan Game)
- **Input Interaksi**: Sentuhan tunggal (*Tap*) dan Seret-Lepas sederhana (*Drag & Drop*) berjarak dekat. Menghindari gestur kompleks seperti *pinch*, *double-tap*, atau *swipe* cepat yang sulit bagi motorik halus AUD.
- **Mini-Game Typologies**:
  1. *Kebun Suara (Sound Matching)*: Mencocokkan benda dengan fonem vokal awal.
  2. *Balon Rima (Rhyme Pop)*: Meletuskan balon yang memiliki bunyi akhir yang sama.
  3. *Rumah Huruf (Letter-Sound Association)*: Memasukkan karakter huruf ke rumahnya berdasarkan suara panggilan fonem.
- **Reward Economy**: Mengumpulkan stiker hewan/bintang virtual yang dapat ditempel di galeri mini (*Sticker Album*).

---

### 3. Profil Pengguna & Pedoman Ergonomi Anak Usia Dini

| Aspek | Karakteristik AUD (4–6 Tahun) | Implikasi Desain pada Game |
| :--- | :--- | :--- |
| **Motorik Halus** | Koordinasi jari tangan belum presisi; area jangkauan jempol terbatas. | Tombol berukuran besar (minimal $64 \times 64$ dp / area sentuh 1.5–2 cm), jarak antar tombol renggang. |
| **Kemampuan Membaca** | Belum lancar membaca teks petunjuk panjang. | Antarmuka mengandalkan instruksi suara (Voice-Over) dan demonstrasi animasi visual (*visual cueing*). |
| **Rentang Perhatian** | 8–15 menit total aktivitas harian gawai; mudah terdistraksi. | Mini-game ringkas, tidak bertele-tele, tanpa dialog panjang yang tidak bisa di-skip. |
| **Sensitivitas Sensorik** | Menyukai warna kontras ceria; mudah overstimulasi suara bising. | Menggunakan palet warna harmonis (bukan kontras silau), vokal pengisi suara yang ramah dan artikulatif. |
