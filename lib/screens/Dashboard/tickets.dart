import 'package:flutter/material.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Tickets Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}