
import 'package:flutter/material.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/session.dart';

class ContactDetailsCard extends StatefulWidget {
  const ContactDetailsCard({super.key});

  @override
  State<ContactDetailsCard> createState() => _ContactDetailsCardState();
}

class _ContactDetailsCardState extends State<ContactDetailsCard> {
  String? phoneNumber;
  String? email;

  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _startEditing() async{
    
      isEditing = true;
      _phoneController.text = phoneNumber ?? '';
      _emailController.text = email ?? '';
      await Session().setEmail(email!);
   await Session().setPhoneNo(phoneNumber!);
   setState(() { });
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
      _phoneController.clear();
      _emailController.clear();
    });
  }

  void _saveContactDetails() async{
    if (_formKey.currentState!.validate()) {
     
        phoneNumber = _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null;
        email = _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null;
        isEditing = false;
   await Session().setEmail(email!);
   await Session().setPhoneNo(phoneNumber!);
     setState(() {  });
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a phone number';
    }
    // Basic phone number validation
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{7,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDetails = phoneNumber != null || email != null;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.neutral100!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(
                  //   Icons.contact_phone,
                  //   color: theme.primaryColor,
                  //   size: 24,
                  // ),
                  const SizedBox(width: 8),
                  Text(
                    "Contact Details",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (!isEditing)
                IntrinsicWidth(
                  child: TextButton(
                    onPressed: _startEditing,
                    style: TextButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasDetails ? Icons.edit : Icons.add,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(
                            width: 8), // Add spacing between icon and text
                        Text(hasDetails ? 'Edit' : 'Add'),
                      ],
                    ),
                  ),
                )
            ],
          ),

          const SizedBox(height: 20),

          // Main content
          if (isEditing) ...[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Phone Number Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: _validatePhone,
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _cancelEditing,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _saveContactDetails,
                          icon: const Icon(Icons.save),
                          label: Text(hasDetails ? 'Update' : 'Save'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (hasDetails) ...[
            // Display Contact Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (phoneNumber != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 20,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            phoneNumber!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Add phone call functionality here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Phone call feature not implemented'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.call),
                          iconSize: 20,
                        ),
                      ],
                    ),
                    if (email != null) const SizedBox(height: 12),
                  ],
                  if (email != null)
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 20,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            email!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Add email functionality here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email feature not implemented'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.send),
                          iconSize: 20,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ] else ...[
            // Empty State
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.contact_phone_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No contact details available",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap 'Add' to enter your phone and email",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}