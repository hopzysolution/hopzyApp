
import 'package:flutter/material.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/app_sizes.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/globels.dart' as globals;

class PassengerCard extends StatefulWidget {
  Set<SeatModell>? selectedSeats;
   void Function(List<Passenger>)? selectedPassengerss;

   PassengerCard({super.key,this.selectedSeats,this.selectedPassengerss});

  @override
  State<PassengerCard> createState() => _PassengerCardState();
}

class _PassengerCardState extends State<PassengerCard>
    with TickerProviderStateMixin {
  List<Passenger> passengers = [];
  List<Passenger> selectedPassengers = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadPassengers();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadPassengers() async {
    passengers = await Session.getPassengers();
    setState(() {
      selectedPassengers.clear();
    });
    _animationController.forward();
  }

  void _openAddPassengerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPassengerForm(
        onPassengerAdded: (passenger) async {
          await Session.savePassenger(passenger);
          _loadPassengers();
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _deletePassenger(int index) async {
    final removedPassenger = passengers[index];
    passengers.removeAt(index);
    selectedPassengers.remove(removedPassenger);
    await Session.saveAllPassengers(passengers);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Passenger Details',
                        style: TextStyle(
                          fontSize: AppSizes.md,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                      ),
                    ),
                    if (passengers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${selectedPassengers.length} / ${passengers.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: AppSizes.buttonHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryBlueLight,
                        AppColors.primaryBlue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlueLight.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: _openAddPassengerSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person_add_alt,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Add new Passenger",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSizes.md,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 10),
            if (passengers.isEmpty)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.person_add_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No passengers added yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap "Add Passenger" to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: List.generate(passengers.length, (index) {
                    final p = passengers[index];
                    // final isSelected = selectedPassengers.contains(p);
                    // Manually compare based on name, age, and gender
                    final isSelected = selectedPassengers.any((selectedPassenger) {
                      return selectedPassenger.name == p.name &&
                            selectedPassenger.age == p.age &&
                            selectedPassenger.gender == p.gender;
                    });
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200 + (index * 50)),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1976D2).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1976D2)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async{
                            
                             if (isSelected) {
                                selectedPassengers.removeWhere((sp) =>
                                    sp.name == p.name &&
                                    sp.age == p.age &&
                                    sp.gender == p.gender);
                              } else {
                                int seatIndex = selectedPassengers.length;
                                SeatModell? seatModell = widget.selectedSeats
                                        ?.elementAt(seatIndex) ;

                                Passenger psn = Passenger(
                                  name: p.name,
                                  age: p.age,
                                  gender: p.gender,
                                  seatNo: seatModell!.seatNo,
                                  fare: seatModell.fare,
                                );

                                selectedPassengers.add(psn);
                                        widget.selectedPassengerss?.call(selectedPassengers);
                                print("Selected Passenger: ${psn.toJson()}");
                              }
                          setState(() {  });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true && widget.selectedSeats!=null && widget.selectedSeats!.isNotEmpty) {
                                        int seatIndex =
                                            selectedPassengers.length;
                                        SeatModell? seatModell = widget.selectedSeats
                                                ?.elementAt(seatIndex) ;

                                        Passenger psn = Passenger(
                                          name: p.name,
                                          age: p.age,
                                          gender: p.gender,
                                          seatNo: seatModell!.seatNo,
                                          fare: seatModell.fare,
                                        );

                                        selectedPassengers.add(psn);
                                        widget.selectedPassengerss?.call(selectedPassengers);
                                      } else {
                                        selectedPassengers.removeWhere(
                                            (element) =>
                                                element.name == p.name &&
                                                element.age == p.age);
                                        widget.selectedPassengerss?.call(selectedPassengers);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Age: ${p.age}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: p.gender == 'male'
                                                  ? Colors.cyan.shade50
                                                  : p.gender == 'female'
                                                      ? Colors.pink.shade50
                                                      : Colors.purple.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  p.gender == 'male'
                                                      ? Icons.male
                                                      : p.gender == 'female'
                                                          ? Icons.female
                                                          : Icons.person,
                                                  size: 14,
                                                  color: p.gender == 'male'
                                                      ? Colors.cyan.shade700
                                                      : p.gender == 'female'
                                                          ? Colors.pink.shade700
                                                          : Colors
                                                              .purple.shade700,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  p.gender,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: p.gender == 'male'
                                                        ? Colors.cyan.shade700
                                                        : p.gender == 'female'
                                                            ? Colors
                                                                .pink.shade700
                                                            : Colors.purple
                                                                .shade700,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              _deletePassenger(index);
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddPassengerForm extends StatefulWidget {
  final Function(Passenger) onPassengerAdded;

  const _AddPassengerForm({required this.onPassengerAdded});

  @override
  State<_AddPassengerForm> createState() => _AddPassengerFormState();
}

class _AddPassengerFormState extends State<_AddPassengerForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  String gender = 'male';
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void _submit() {
    globals.phoneNo=phoneController.text;
    globals.email=emailController.text;
    Session().setEmail(emailController.text);
    Session().setPhoneNo(phoneController.text);
    if (_formKey.currentState!.validate()) {
      final passenger = Passenger(
        name: nameController.text.trim(),
        age: int.parse(ageController.text.trim()),
        gender: gender,
      );
      widget.onPassengerAdded(passenger);
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlueLight.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Add New Passenger",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter passenger name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  // validator: (value) =>
                  //     value!.isEmpty ? 'Please enter passenger name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  // validator: (value) =>
                  //     value!.isEmpty ? 'Please enter passenger name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    prefixIcon: const Icon(Icons.cake_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter age';
                    final age = int.tryParse(value);
                    if (age == null || age <= 0 || age > 120) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: gender,
                  items: [
                    DropdownMenuItem(
                      value: 'male',
                      child: Row(
                        children: const [
                          // Icon(Icons.male, color: Colors.cyan),
                          SizedBox(width: 8),
                          Text('male'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'female',
                      child: Row(
                        children: const [
                          // Icon(Icons.female, color: Colors.pink),
                          SizedBox(width: 8),
                          Text('female'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child: Row(
                        children: const [
                          // Icon(Icons.person, color: Colors.purple),
                          SizedBox(width: 8),
                          Text('other'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(
                      gender == 'male'
                          ? Icons.male
                          : gender == 'female'
                              ? Icons.female
                              : Icons.person,
                      color: gender == 'male'
                          ? Colors.cyan
                          : gender == 'female'
                              ? Colors.pink
                              : Colors.purple,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.secondaryTeal,
                          AppColors.primaryBlue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlueLight.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _submit,
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Add to Passenger List',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}