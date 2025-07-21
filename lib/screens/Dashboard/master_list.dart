import 'package:flutter/material.dart';

class MasterList extends StatefulWidget {
  const MasterList({super.key});

  @override
  State<MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<MasterList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master List'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Master List Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}