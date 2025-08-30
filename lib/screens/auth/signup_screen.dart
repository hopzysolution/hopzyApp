
// import 'package:demoappfortest/screens/demo.dart';
// import 'package:flutter/material.dart';

// class SignupScreen extends StatefulWidget {
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   String _selectedGender = 'Select Gender';

//   final List<String> _genderOptions = [
//     'Select Gender',
//     'Male',
//     'Female',
//     'Other'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.blue[600],
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(0),
//                   bottomRight: Radius.circular(0),
//                 ),
//               ),
//               child: Text(
//                 'User Registration',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),

//             // Form Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(24),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       SizedBox(height: 20),

//                       // Name Field
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           hintText: 'Name',
//                           hintStyle: TextStyle(color: Colors.grey[500]),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your name';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 16),

//                       // Gender Dropdown
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: DropdownButtonFormField<String>(
//                           value: _selectedGender,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                           ),
//                           hint: Text(
//                             'Gender',
//                             style: TextStyle(color: Colors.grey[500]),
//                           ),
//                           items: _genderOptions.map((String gender) {
//                             return DropdownMenuItem<String>(
//                               value: gender,
//                               child: Text(
//                                 gender,
//                                 style: TextStyle(
//                                   color: gender == 'Select Gender'
//                                       ? Colors.grey[500]
//                                       : Colors.black,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               _selectedGender = newValue!;
//                             });
//                           },
//                           validator: (value) {
//                             if (value == null || value == 'Select Gender') {
//                               return 'Please select your gender';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),

//                       SizedBox(height: 16),

//                       // Email Field
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           hintText: 'Email Id',
//                           hintStyle: TextStyle(color: Colors.grey[500]),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                               .hasMatch(value)) {
//                             return 'Please enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 16),

//                       // Phone Field
//                       TextFormField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           hintText: 'Phone',
//                           hintStyle: TextStyle(color: Colors.grey[500]),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your phone number';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 16),

//                       // Password Field
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: !_isPasswordVisible,
//                         decoration: InputDecoration(
//                           hintText: 'Password',
//                           hintStyle: TextStyle(color: Colors.grey[500]),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: Colors.grey[500],
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a password';
//                           }
//                           if (value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 16),

//                       // Confirm Password Field
//                       TextFormField(
//                         controller: _confirmPasswordController,
//                         obscureText: !_isConfirmPasswordVisible,
//                         decoration: InputDecoration(
//                           hintText: 'Confirm Password',
//                           hintStyle: TextStyle(color: Colors.grey[500]),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isConfirmPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: Colors.grey[500],
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isConfirmPasswordVisible =
//                                     !_isConfirmPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please confirm your password';
//                           }
//                           if (value != _passwordController.text) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 32),

//                       // Register Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Demo()));
//                             // if (_formKey.currentState!.validate()) {
//                             //   // Handle registration logic here
//                             //   ScaffoldMessenger.of(context).showSnackBar(
//                             //     SnackBar(
//                             //         content: Text('Registration Successful!')),
//                             //   );
//                             // }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue[600],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'Register',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 24),

//                       // OR Divider
//                       Row(
//                         children: [
//                           Expanded(child: Divider(color: Colors.grey[400])),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               'OR',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           Expanded(child: Divider(color: Colors.grey[400])),
//                         ],
//                       ),

//                       SizedBox(height: 24),

//                       // Google Sign In Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             // Handle Google sign in
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Google Sign In clicked')),
//                             );
//                           },
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             side: BorderSide(color: Colors.grey[300]!),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           icon: Container(
//                             width: 20,
//                             height: 20,
//                             child: Image.network(
//                               'https://developers.google.com/identity/images/g-logo.png',
//                               width: 20,
//                               height: 20,
//                             ),
//                           ),
//                           label: Text(
//                             'Sign in with Google',
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 32),

//                       // Already have account
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Already have an account? ',
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               // Navigate to sign in screen
//                               print('Navigate to Sign In');
//                             },
//                             child: Text(
//                               'Sign in',
//                               style: TextStyle(
//                                 color: Colors.blue[600],
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }









// import 'package:flutter/material.dart';
// import 'package:ridebooking/screens/Dashboard/home_screen.dart';
// import 'package:ridebooking/utils/app_sizes.dart';
// import 'package:ridebooking/utils/route_generate.dart';

// class SignupScreen extends StatefulWidget {
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   String _selectedGender = 'Select Gender';

//   final List<String> _genderOptions = [
//     'Select Gender',
//     'Male',
//     'Female',
//     'Other'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Get screen size for responsive design
//     final isTablet =
//         AppSizes.isTablet(context); // Consider tablet for width > 600

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Column(
//               children: [
//                 // Header with SVG icon
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                     vertical: isTablet ? 30 : 20,
//                     horizontal: 16,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[600],
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // SvgPicture.asset(
//                       //   'assets/steering_wheel.svg',
//                       //   width: isTablet ? 40 : 30,
//                       //   height: isTablet ? 40 : 30,
//                       //   colorFilter:
//                       //       ColorFilter.mode(Colors.white, BlendMode.srcIn),
//                       // ),
//                       SizedBox(width: 10),
//                       Text(
//                         'User Registration',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: isTablet ? 24 : 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Form Content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.all(isTablet ? 32 : 24),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           SizedBox(height: isTablet ? 30 : 20),

//                           // Name Field
//                           _buildTextField(
//                             controller: _nameController,
//                             hintText: 'Name',
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your name';
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 16),

//                           // Gender Dropdown
//                           _buildDropdownField(
//                             value: _selectedGender,
//                             items: _genderOptions,
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 _selectedGender = newValue!;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null || value == 'Select Gender') {
//                                 return 'Please select your gender';
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 16),

//                           // Email Field
//                           _buildTextField(
//                             controller: _emailController,
//                             hintText: 'Email Id',
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                                   .hasMatch(value)) {
//                                 return 'Please enter a valid email';
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 16),

//                           // Phone Field
//                           _buildTextField(
//                             controller: _phoneController,
//                             hintText: 'Phone',
//                             keyboardType: TextInputType.phone,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your phone number';
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 16),

//                           // Password Field
//                           _buildTextField(
//                             controller: _passwordController,
//                             hintText: 'Password',
//                             obscureText: !_isPasswordVisible,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Colors.grey[500],
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a password';
//                               }
//                               if (value.length < 6) {
//                                 return 'Password must be at least 6 characters';
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 16),

//                           // Confirm Password Field
//                           _buildTextField(
//                             controller: _confirmPasswordController,
//                             hintText: 'Confirm Password',
//                             obscureText: !_isConfirmPasswordVisible,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isConfirmPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Colors.grey[500],
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isConfirmPasswordVisible =
//                                       !_isConfirmPasswordVisible;
//                                 });
//                               },
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please confirm your password';
//                               }
//                               if (value != _passwordController.text) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: isTablet ? 40 : 32),

//                           // Register Button
//                           _buildButton(
//                             text: 'Register',
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => HomeScreen()),
//                               );
//                               // if (_formKey.currentState!.validate()) {
//                               //   Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => Demo()),
//                               //   );
//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(
//                               //         content:
//                               //             Text('Registration Successful!')),
//                               //   );
//                               // }
//                             },
//                             isTablet: isTablet,
//                           ),

//                           SizedBox(height: isTablet ? 32 : 24),

//                           // OR Divider
//                           Row(
//                             children: [
//                               Expanded(child: Divider(color: Colors.grey[400])),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                                 child: Text(
//                                   'OR',
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: isTablet ? 16 : 14,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(child: Divider(color: Colors.grey[400])),
//                             ],
//                           ),

//                           SizedBox(height: isTablet ? 32 : 24),

//                           // Google Sign In Button
//                           _buildGoogleButton(
//                             onPressed: () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text('Google Sign In clicked')),
//                               );
//                             },
//                             isTablet: isTablet,
//                           ),

//                           SizedBox(height: isTablet ? 40 : 32),

//                           // Already have account
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Already have an account? ',
//                                 style: TextStyle(
//                                   color: Colors.grey[600],
//                                   fontSize: isTablet ? 16 : 14,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   print('Navigate to Sign In');
//                                   Navigator.pushReplacementNamed(context, Routes.loginWithOtpScreen);
//                                 },
//                                 child: Text(
//                                   'Sign in',
//                                   style: TextStyle(
//                                     color: Colors.blue[600],
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: isTablet ? 16 : 14,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           SizedBox(height: isTablet ? 30 : 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // Reusable Text Field Widget
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       constraints:
//           BoxConstraints(maxWidth: 500), // Limit width for large screens
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey[500]),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           suffixIcon: suffixIcon,
//           errorStyle: TextStyle(fontSize: 12),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   // Reusable Dropdown Field Widget
//   Widget _buildDropdownField({
//     required String value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       constraints: BoxConstraints(maxWidth: 500),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//         hint: Text(
//           'Gender',
//           style: TextStyle(color: Colors.grey[500]),
//         ),
//         items: items.map((String gender) {
//           return DropdownMenuItem<String>(
//             value: gender,
//             child: Text(
//               gender,
//               style: TextStyle(
//                 color:
//                     gender == 'Select Gender' ? Colors.grey[500] : Colors.black,
//               ),
//             ),
//           );
//         }).toList(),
//         onChanged: onChanged,
//         validator: validator,
//       ),
//     );
//   }

//   // Reusable Button Widget
//   Widget _buildButton({
//     required String text,
//     required VoidCallback onPressed,
//     required bool isTablet,
//   }) {
//     return Container(
//       constraints: BoxConstraints(maxWidth: 500),
//       height: isTablet ? 56 : 50,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue[600],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//           shadowColor: Colors.blue[200],
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isTablet ? 18 : 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }

//   // Reusable Google Sign In Button Widget
//   Widget _buildGoogleButton({
//     required VoidCallback onPressed,
//     required bool isTablet,
//   }) {
//     return Container(
//       constraints: BoxConstraints(maxWidth: 500),
//       height: isTablet ? 56 : 50,
//       child: OutlinedButton.icon(
//         onPressed: onPressed,
//         style: OutlinedButton.styleFrom(
//           backgroundColor: Colors.white,
//           side: BorderSide(color: Colors.grey[300]!),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         icon: Container(
//           width: isTablet ? 24 : 20,
//           height: isTablet ? 24 : 20,
//           child: Image.network(
//             'https://developers.google.com/identity/images/g-logo.png',
//             width: isTablet ? 24 : 20,
//             height: isTablet ? 24 : 20,
//           ),
//         ),
//         label: Text(
//           'Sign in with Google',
//           style: TextStyle(
//             color: Colors.grey[700],
//             fontSize: isTablet ? 18 : 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }
