
import 'package:flutter/material.dart';

Future<dynamic> showTextFieldDialog(BuildContext context, TextEditingController passwordController) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Handle the password input here
              String password = passwordController.text;
              // ignore: avoid_print
              print('Password entered: $password');
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without doing anything
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
