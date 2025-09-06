import 'package:flutter/material.dart';
import 'package:ridebooking/commonWidgets/custom_action_button.dart';
import 'package:ridebooking/utils/app_colors.dart';

class GstDetails {
  final String gstNumber;
  final String businessName;
  final String businessAddress;
  final String businessEmail;

  GstDetails({
    required this.gstNumber,
    required this.businessName,
    required this.businessAddress,
    required this.businessEmail,
  });
}

class GstFormWidget extends StatefulWidget {
  final bool hasGST;
  final ValueChanged<bool> onGSTChanged;
  final ValueChanged<GstDetails> onSubmit;

  const GstFormWidget({
    super.key,
    required this.hasGST,
    required this.onGSTChanged,
    required this.onSubmit,
  });

  @override
  State<GstFormWidget> createState() => _GstFormWidgetState();
}

class _GstFormWidgetState extends State<GstFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _gstController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _gstController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final details = GstDetails(
        gstNumber: _gstController.text.trim(),
        businessName: _nameController.text.trim(),
        businessAddress: _addressController.text.trim(),
        businessEmail: _emailController.text.trim(),
      );
      widget.onSubmit(details);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox Row
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: widget.hasGST,
                onChanged: (val) => widget.onGSTChanged(val ?? false),
              ),
              const Text("I have a GST number (optional)?"),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // GST Form (visible only if checked)
        if (widget.hasGST)
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _gstController,
                      decoration: const InputDecoration(
                        labelText: "GST Number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter GST number" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Business Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter business name" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Business Address",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter business address" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      
                      // onEditingComplete:_submitForm ,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Business Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter business email";
                        }
                        final emailRegex = RegExp(r"^[^@]+@[^@]+\.[^@]+");
                        if (!emailRegex.hasMatch(val)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomActionButton(
                      onPressed: _submitForm,
                      text: "Save GST Details",
                      backgroundColor: AppColors.primaryBlue,
                      
                    ),
                    // ElevatedButton(
                    //   onPressed: _submitForm,
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     minimumSize: const Size(double.infinity, 48),
                    //   ),
                    //   child: const Text("Save GST Details"),
                    // )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
