import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/services/firebase_services.dart';
import 'package:todoapp/widgets/custom_textfield.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true; //******* login/signup selector******************
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ************ Dummy social login buttons***************************
  void _dummySocialLogin(String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$method login pressed (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(106, 17, 203, 1),
              Color.fromRGBO(37, 117, 252, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ************************** Logo ***************************
                const Icon(Icons.today_rounded, size: 100, color: Colors.white),
                const SizedBox(height: 30),
                // ************************** Form ****************************
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            _isLogin ? 'Welcome Back!' : 'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 25),
                          // ***************** Email Field****************
                          CustomTextField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          // ****************** Password Field***************
                          CustomTextField(
                            controller: _passwordController,
                            hint: 'Password',
                            icon: Icons.lock,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          // *************** Login/Signup Button ***********
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              // Updated onPressed handler for the login/signup button
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    // Show loading indicator
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );

                                    // Perform authentication
                                    if (_isLogin) {
                                      await AuthService().login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    } else {
                                      await AuthService().signUp(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                    if (mounted) {
                                      context.pushReplacementNamed('intro');
                                    }
                                  } catch (e) {
                                    // Handle errors
                                    if (mounted) {
                                      Navigator.pop(
                                          context); // Dismiss loading indicator
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Error: ${e.toString()}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text(_isLogin ? 'Login' : 'Sign Up'),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // ********** Toggler *************************
                          TextButton(
                            onPressed: () =>
                                setState(() => _isLogin = !_isLogin),
                            child: Text(_isLogin
                                ? 'New user? Create Account'
                                : 'Already have an account? Login'),
                          ),
                          const SizedBox(height: 20),
                          // ************** Extra Login Section ***********
                          const Text('Or continue with',
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // *********** Google ***********************
                              SocialLoginButton(
                                icon: Icons.g_mobiledata,
                                onTap: () => _dummySocialLogin('Google'),
                              ),
                              const SizedBox(width: 15),
                              // ************ Facebook **********************
                              SocialLoginButton(
                                icon: Icons.facebook,
                                onTap: () => _dummySocialLogin('Facebook'),
                              ),
                              const SizedBox(width: 15),
                              // **************** Phone *****************
                              SocialLoginButton(
                                icon: Icons.phone,
                                onTap: () => _dummySocialLogin('Phone'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ************ Extra Login Button Widget*****************************
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const SocialLoginButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 30),
      ),
    );
  }
}
