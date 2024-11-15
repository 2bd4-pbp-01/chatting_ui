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