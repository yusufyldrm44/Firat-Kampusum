import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_panel_page.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Sabit admin bilgileri
  static const String ADMIN_EMAIL = 'admin@firat.edu.tr';
  static const String ADMIN_PASSWORD = 'admin123';

  @override
  void initState() {
    super.initState();
    // Admin bilgilerini otomatik doldur
    _emailController.text = ADMIN_EMAIL;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

            Future<void> _adminLogin() async {
            if (!_formKey.currentState!.validate()) return;

            setState(() {
              _isLoading = true;
            });

            try {
              // Admin bilgilerini kontrol et
              if (_emailController.text == ADMIN_EMAIL && 
                  _passwordController.text == ADMIN_PASSWORD) {
                
                // Admin paneline yönlendir (Firebase authentication bypass)
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminPanelPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Admin bilgileri hatalı!'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Giriş yapılırken hata oluştu: $e'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8B0000),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/firat.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Başlık
                  Text(
                    'Admin Paneli',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    'Fırat Üniversitesi Kampüsüm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  
                  SizedBox(height: 48),
                  
                  // Giriş Formu
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // E-posta
                        TextFormField(
                          controller: _emailController,
                          enabled: false, // Sabit admin e-postası
                          decoration: InputDecoration(
                            labelText: 'E-posta',
                            prefixIcon: Icon(Icons.email, color: Color(0xFF8B0000)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-posta gerekli';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Şifre
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: Icon(Icons.lock, color: Color(0xFF8B0000)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Color(0xFF8B0000),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Şifre gerekli';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Giriş Butonu
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _adminLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B0000),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Admin Girişi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        
                                                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Geri Dön Butonu
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Geri Dön',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 