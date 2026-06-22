import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/firebase/auth_service.dart';

import '../../core/database/database_provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final auth = AuthService();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool loading = false;

  String? error;

  // User? get user => auth.currentUser;

  @override
  void dispose() {
    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      loading = true;

      error = null;
    });

    try {
      await auth.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (mounted) {
        setState(() {});
      }
    } on FirebaseAuthException catch (e) {
      error = e.message;
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> register() async {
    setState(() {
      loading = true;

      error = null;
    });

    try {
      await auth.register(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (mounted) {
        setState(() {});
      }
    } on FirebaseAuthException catch (e) {
      error = e.message;
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      return;
    }

    try {
      await auth.resetPassword(emailController.text.trim());

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } on FirebaseAuthException catch (e) {
      error = e.message;

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> logout() async {
    await auth.logout();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),

      // body: Padding(
      //   padding: const EdgeInsets.all(16),

      //   child: user == null ? buildOfflineView() : buildConnectedView(),
      // ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),

        builder: (context, snapshot) {
          final user = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16),

            child: user == null ? buildOfflineView() : buildConnectedView(user),
          );
        },
      ),
    );
  }

  Widget buildOfflineView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Offline mode",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text("Sign in to enable cloud sync."),

        const SizedBox(height: 24),

        TextField(
          controller: emailController,

          keyboardType: TextInputType.emailAddress,

          decoration: const InputDecoration(labelText: "Email"),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: passwordController,

          obscureText: true,

          decoration: const InputDecoration(labelText: "Password"),
        ),

        const SizedBox(height: 24),

        if (error != null)
          Text(error!, style: const TextStyle(color: Colors.red)),

        if (error != null) const SizedBox(height: 16),

        if (loading)
          const Center(child: CircularProgressIndicator())
        else ...[
          SizedBox(
            width: double.infinity,

            child: FilledButton(onPressed: login, child: const Text("Login")),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,

            child: OutlinedButton(
              onPressed: register,

              child: const Text("Register"),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: TextButton(
              onPressed: resetPassword,

              child: const Text("Forgot password?"),
            ),
          ),
        ],
      ],
    );
  }

  // Widget buildConnectedView() {
  Widget buildConnectedView(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Connected",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        // Text(user?.email ?? "", style: const TextStyle(fontSize: 18)),
        Text(user.email ?? "", style: const TextStyle(fontSize: 18)),

        const SizedBox(height: 8),

        const Text("Cloud sync enabled"),

        const Spacer(),

        SizedBox(
          width: double.infinity,

          child: FilledButton(onPressed: logout, child: const Text("Logout")),
        ),

        SizedBox(
          width: double.infinity,

          child: FilledButton(
            onPressed: () async {
              await syncService.uploadEverything();

              print("Upload completed");

              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Uploaded')));
              }
            },

            child: const Text('Upload'),
          ),
        ),

        FilledButton(
          onPressed: () async {
            // await syncService.downloadEverything();
            await syncService.downloadEverything();

            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },

          child: const Text("Download"),
        ),
      ],
    );
  }
}
