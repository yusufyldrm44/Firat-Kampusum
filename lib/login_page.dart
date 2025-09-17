import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;
  bool isLogin = true;
  bool isPasswordVisible = false;

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Başarılı girişte ana sayfaya yönlendirme veya başka bir işlem yapılabilir
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı.';
            break;
          case 'wrong-password':
            errorMessage = 'Hatalı şifre. Lütfen tekrar deneyin.';
            break;
          case 'invalid-email':
            errorMessage = 'Geçersiz e-posta adresi.';
            break;
          case 'user-disabled':
            errorMessage = 'Bu hesap devre dışı bırakılmış.';
            break;
          case 'too-many-requests':
            errorMessage = 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin.';
            break;
          default:
            errorMessage = 'Giriş yapılırken bir hata oluştu: ${e.message}';
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Firestore'a kullanıcı verisi ekle
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Kayıt başarılı mesajı göster ve giriş ekranına yönlendir
      if (mounted) {
        setState(() {
          isLogin = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt başarılı! Lütfen giriş yapın.'),
            backgroundColor: Color(0xFF8B0000),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Bu e-posta adresi zaten kullanımda.';
            break;
          case 'weak-password':
            errorMessage = 'Şifre çok zayıf. En az 6 karakter kullanın.';
            break;
          case 'invalid-email':
            errorMessage = 'Geçersiz e-posta adresi.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'E-posta/şifre girişi etkin değil.';
            break;
          default:
            errorMessage = 'Kayıt olurken bir hata oluştu: ${e.message}';
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF8B0000),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Logo ve başlık bölümü
                  SizedBox(height: 60),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/firat.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Fırat Üniversitesi',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kampüsüm Uygulaması',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 60),

                  // Giriş/Kayıt formu
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Başlık
                        Text(
                          isLogin ? 'Hoş Geldiniz' : 'Hesap Oluştur',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0000),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          isLogin 
                            ? 'Hesabınıza giriş yapın'
                            : 'Yeni hesap oluşturun',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 32),

                        // E-posta alanı
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-posta',
                            prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF8B0000)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Şifre alanı
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: Icon(Icons.lock_outlined, color: Color(0xFF8B0000)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Color(0xFF8B0000),
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        SizedBox(height: 24),

                        // Hata mesajı
                        if (errorMessage != null)
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage!,
                                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (errorMessage != null) SizedBox(height: 20),

                        // Giriş/Kayıt butonu
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : (isLogin ? signIn : signUp),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B0000),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    isLogin ? 'Giriş Yap' : 'Kayıt Ol',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Geçiş butonu
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                                errorMessage = null;
                                isPasswordVisible = false;
                              });
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: isLogin 
                                        ? 'Hesabınız yok mu? '
                                        : 'Zaten hesabınız var mı? ',
                                  ),
                                  TextSpan(
                                    text: isLogin ? 'Kayıt Ol' : 'Giriş Yap',
                                    style: TextStyle(
                                      color: Color(0xFF8B0000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Admin Panel butonu
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => AdminLoginPage()),
                              );
                            },
                            icon: Icon(Icons.admin_panel_settings, color: Color(0xFF8B0000)),
                            label: Text(
                              'Admin Paneli',
                              style: TextStyle(
                                color: Color(0xFF8B0000),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 