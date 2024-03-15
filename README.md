# Modified RC4

## Tugas Kecil 2 - II4031 Kriptografi dan Koding

## Deskripsi

Program ini merupakan aplikasi yang menyediakan algoritma enkripsi dan dekripsi dengan menggunakan kombinasi cipher klasik dan stream cipher, serta dikembangkan menggunakan Flutter untuk mobile app. Program dapat menerima input pesan dari keyboard atau berkas dengan ekstensi apa pun, serta mampu mengenkripsi pesan plaintext dengan 256 karakter ASCII menggunakan Extended Vigenere Cipher, serta mendekripsi ciphertext dalam base64 menjadi plaintext. Untuk file, proses enkripsi dan dekripsi dilakukan pada tingkat byte, termasuk header file, dan disimpan kembali dalam format dengan ekstensi yang sama untuk memastikan keutuhan file namun tidak dapat dibuka oleh aplikasi terkait. Pengguna memiliki kemampuan untuk memasukkan kunci pada setiap cipher sesuai keinginan mereka. Program ini dikembangkan menggunakan Flutter dengan dasar bahasa pemrograman Dart untuk logika dan antarmuka pengguna (GUI).

## Instalasi (Emulator & APK)

### 1. Emulator
**Step 1:**

Download atau clone repo dengan menggunakan command dibawah:

```
https://github.com/abrahammegantoro/cipher-generator.git
```

**Step 2:**

Buka folder utama darai project dan jalankan command dibawah ini untuk menginstall *dependencies* yang diperlukan:

```
flutter pub get 
```
### 2. APK

Install aplikasi yang bernama *app-release.apk* yang berada pada folder project ini.


## Kontributor

- 18221123 - Abraham Megantoro Samudra
- 18221143 - Lie, Kevin Sebastian Sheva Tjahyana

## Tabel Fitur

| No  | Feature                  | Success (✔) | Fail (❌) | Details                                                                                           |
| :-: | :----------------------- | :---------- | :-------- | :-----------------------------------------------------------------------------------------------  |
|  1  | Program dapat menerima pesan berupa file sembarang (file text maupun file biner) atau pesan yang diketikkan dari papan-ketik. | ✔           |           |          |
|  2  | Program dapat mengenkripsi plainteks dan mendekripsi cipherteks menjadi plainteks semula.                                     | ✔           |           |          |
|  3  | Untuk pesan berupa text, program dapat menampilkan plainteks dan cipherteks di layer (format string atau base64).             | ✔           |           | Dekripsi cipherteks dengan membaca ciphertext dalam base64. Base64 yang ingin didekripsi harus memiliki panjang kelipatan 4, jika tidak, program akan menambahkan char “=” hingga panjang teks kelipatan 4.|
|  4  | Program dapat menyimpan cipherteks ke dalam file.          | ✔           |           |                                                                                                   |
|  5  | Kunci dimasukkan oleh pengguna. Panjang kunci bebas.            | ✔           |           |                                                                                                   |
