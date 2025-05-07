// Placeholder for your profile view (declaration for context)
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Profile')), body: const Center(child: Text('Profile Page Content')));
  }
}