import 'package:flutter/material.dart';

class PasswordSection extends StatelessWidget {
  final String password;
  final VoidCallback onPasswordChange;

  const PasswordSection({
    super.key,
    required this.password,
    required this.onPasswordChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Password:",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              password.isNotEmpty ? '*' * password.length : 'No password set',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: onPasswordChange,
          child: Text(password.isNotEmpty ? "Change Password" : "Add Password"),
        ),
      ],
    );
  }
}
