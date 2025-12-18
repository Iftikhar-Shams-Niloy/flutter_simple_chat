import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_simple_chat/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AushScreenState();
  }
}

class _AushScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredUsername = "";
  var _isLoading = false;

  Future<void> _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        // Save username to Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredentials.user!.uid)
            .set({"username": _enteredUsername, "email": _enteredEmail});

        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully!")),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();

      String errorMessage = "Authentication Error!";
      if (error.code == 'email-already-in-use') {
        errorMessage = "This email is already in use.";
      } else if (error.code == 'weak-password') {
        errorMessage = "Password is too weak.";
      } else if (error.code == 'invalid-email') {
        errorMessage = "Invalid email address.";
      } else if (error.code == 'user-not-found') {
        errorMessage = "No account found with this email.";
      } else if (error.code == 'wrong-password') {
        errorMessage = "Wrong password.";
      } else {
        errorMessage = error.message ?? "Authentication Error!";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset("assets/images/simple_chat_logo.png"),
              ),

              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsGeometry.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin) UserImagePicker(),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Username",
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return "Please enter at least 4 characters";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Email Address",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "Your email address is invalid!";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            autocorrect: false,
                            obscureText: true,
                            textCapitalization: TextCapitalization.none,
                            validator: (pass) {
                              if (pass == null || pass.trim().length < 6) {
                                return "Password too short!";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (pass) {
                              _enteredPassword = pass!;
                            },
                          ),

                          const SizedBox(height: 12),

                          if (_isLoading)
                            const CircularProgressIndicator()
                          else
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              child: Text(_isLogin ? "Log IN" : "Sign UP"),
                            ),

                          if (!_isLoading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? "Create an account"
                                    : "Already have an account? Click here.",
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
