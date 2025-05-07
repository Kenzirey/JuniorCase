import 'package:flutter/material.dart';

/// Displays one post in detail.
/// This came with the starter project, and I've not set it up to actually be used.
class GroupPostScreen extends StatelessWidget {
  const GroupPostScreen({super.key});
  static const routeName = '/sample_item';
  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)?.settings.arguments as int?;
    return Scaffold(
      appBar: AppBar(title: Text(itemId != null ? 'Details for Item $itemId' : 'Item Details')),
      body: Center(child: Text(itemId != null ? 'More Information Here for Item $itemId' : 'More Information Here')),
    );
  }
}