# chatting-ui
Front-end for CorpaChat

## Paradigma OOP Proyek Flutter

### Konsep OOP yang Digunakan

1. **Class dan Object**:
   - **Class**: Merupakan blueprint atau template untuk membuat objek. Dalam proyek ini, contoh class adalah `ChatScreen`, `LoginScreen`, `SignupScreen`, `ProfileScreen`, dan `EditProfileScreen`.
   - **Object**: Merupakan instance dari class. Contoh: `ChatScreen()` adalah objek yang dibuat dari class `ChatScreen`.

2. **Encapsulation**:
   - Menyembunyikan detail implementasi dari pengguna dan hanya menyediakan antarmuka publik. Dalam proyek ini, variabel dan metode dalam class hanya dapat diakses melalui instance dari class tersebut.

3. **Inheritance**:
   - Mewarisi sifat dan perilaku dari class lain. Dalam proyek ini, class seperti `ChatScreen`, `LoginScreen`, `SignupScreen`, `ProfileScreen`, dan `EditProfileScreen` mewarisi dari `StatefulWidget` atau `StatelessWidget`.

4. **Polymorphism**:
   - Kemampuan untuk menggunakan metode yang sama dengan cara yang berbeda. Dalam proyek ini, metode `build` di-override di setiap class yang mewarisi `StatefulWidget` atau `StatelessWidget` untuk memberikan implementasi spesifik dari UI.

5. **Abstraction**:
   - Menyediakan antarmuka yang sederhana untuk pengguna dan menyembunyikan detail kompleks. Dalam proyek ini, penggunaan widget Flutter seperti `Scaffold`, `AppBar`, `TextFormField`, dan `ListView` menyembunyikan detail implementasi kompleks di balik antarmuka yang sederhana.

### Contoh Implementasi dalam dart/flutter

#### Class dan Object
```dart
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

```
#### Encapsulation
```dart
class _ChatScreenState extends State<ChatScreen> {
  final List<ProjectItem> projects = [
    ProjectItem(
      title: 'Project CorpsChat',
      subtitle: "Let's Meet",
      time: '11:48',
    ),
    // ...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
    );
  }
}

```

#### Inheritance
```dart
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ...
}
```
#### Polymorphism
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Chat Screen'),
    ),
    body: Center(
      child: Text('Welcome to Chat Screen'),
    ),
  );
}
```

#### Abstraction
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Chat Screen'),
    ),
    body: Center(
      child: Text('Welcome to Chat Screen'),
    ),
  );
}
```

---

# Perbandingan Flutter vs Kotlin untuk Pengembangan Aplikasi Mobile

## 1. Bahasa Pemrograman

### Flutter
- Menggunakan bahasa pemrograman Dart
- Sintaks yang mirip dengan C-style languages
- Mendukung pengembangan cross-platform
- Kompilasi AOT (Ahead of Time) untuk performa yang lebih baik

### Kotlin
- Bahasa pemrograman modern berbasis JVM
- 100% interoperabilitas dengan Java
- Fokus pada pengembangan Android native
- Mendukung multiplatform melalui Kotlin Multiplatform Mobile (KMM)

## 2. Kinerja dan Performa

### Flutter

Flutter menggunakan rendering langsung (Direct Rendering Engine), yang berarti UI Flutter dirender dengan cara unik tanpa harus mengandalkan tampilan platform asli. Ini memberikan performa cepat dan animasi halus, tetapi ukurannya bisa lebih besar.
- Performa yang konsisten di berbagai platform
- Rendering engine sendiri (Skia)
- Kompilasi native memberikan performa hampir setara native
- Frame rate 60fps sebagai standar

### Kotlin

Karena Kotlin menggunakan native view (tampilan asli dari platform), aplikasi memiliki performance hampir sama dengan aplikasi asli (native), terutama di Android. Pada Kotlin Multiplatform, performa di platform berbeda bergantung pada integrasi dengan native view di tiap platform.
- Performa native untuk Android
- Akses langsung ke API platform
- Overhead minimal karena kompilasi langsung ke bytecode
- Optimasi khusus untuk platform Android

## 3. Pengembangan UI

### Flutter

Menawarkan tingkat kustomisasi tinggi dalam membuat UI dengan widget yang dapat dikustomisasi sesuai kebutuhan. Namun, beberapa fitur khusus OS, seperti layanan atau komponen perangkat keras, mungkin perlu menggunakan channel native.
- Widget-based UI development
- Hot Reload untuk preview instan
- Material Design dan Cupertino widgets
- Custom widget yang konsisten lintas platform

### Kotlin

Karena Kotlin berinteraksi langsung dengan native component, pengembangan dan penggunaan layanan sistem atau perangkat keras menjadi lebih fleksibel, terutama jika dibandingkan dengan Flutter yang harus melalui bridge antara Dart dan platform native.
- XML-based layout
- Android Studio Layout Editor
- Mendukung Jetpack Compose untuk UI deklaratif
- Akses penuh ke komponen UI native

## 4. Learning Curve

### Flutter
- Memerlukan pembelajaran Dart
- Konsep widget tree yang unik
- Dokumentasi lengkap dan komunitas yang aktif
- Lebih mudah untuk pemula tanpa pengalaman mobile development

### Kotlin
- Lebih mudah bagi developer Java
- Membutuhkan pemahaman Android framework
- Kurva pembelajaran lebih curam untuk pemula
- Dokumentasi resmi yang sangat baik

## 5. Kelebihan dan Kekurangan

### Flutter

Kelebihan:
- Single codebase untuk multiple platform
- Hot Reload untuk development yang lebih cepat
- UI yang konsisten di semua platform
- Performa yang baik

Kekurangan:
- Ukuran aplikasi yang lebih besar
- Keterbatasan akses ke native API
- Ekosistem yang relatif baru
- Ketergantungan pada Google

### Kotlin

Kelebihan:
- Performa native yang optimal
- Akses penuh ke API Android
- Interoperabilitas dengan Java
- Dukungan penuh dari Google

Kekurangan:
- Primarily untuk Android development
- Development time lebih lama untuk multi-platform
- Membutuhkan pengalaman Android development
- Learning curve yang lebih tinggi

## Sumber:

1. [Flutter Documentation](https://docs.flutter.dev/)

2. [Kotlin Documentation](https://kotlinlang.org/docs/home.html)
   
3. [Google Developers Blog](https://developers.googleblog.com/)
   
4. [Android Developers Blog](https://android-developers.googleblog.com/)
   
