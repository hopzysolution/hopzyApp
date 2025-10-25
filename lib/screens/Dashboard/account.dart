// import 'package:flutter/material.dart';
//
// class Account extends StatefulWidget {
//   const Account({super.key});
//
//   @override
//   State<Account> createState() => _AccountState();
// }
//
// class _AccountState extends State<Account> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Account'),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to the Account Screen',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile Image (Left)
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and Email (Right)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Edit Profile Button
                        OutlinedButton(
                          onPressed: () {
                            // Navigate to edit profile
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Menu Items Section
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Hopzy Account'),
              subtitle: const Text('Manage your account details'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Hopzy Account
              },
            ),
            const Divider(height: 1, indent: 56),

            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Rate Us'),
              subtitle: const Text('Share your feedback'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Rate Us
              },
            ),
            const Divider(height: 1, indent: 56),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              subtitle: const Text('App preferences and configurations'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Settings
              },
            ),
            const Divider(height: 1, indent: 56),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              subtitle: const Text('Learn more about the app'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to About
              },
            ),
          ],
        ),
      ),
    );
  }
}