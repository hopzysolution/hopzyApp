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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/accountBloc/account_bloc.dart';
import 'package:ridebooking/bloc/accountBloc/account_state.dart';

import '../../bloc/accountBloc/account_event.dart';
import '../../bloc/booking_bloc/booking_bloc.dart';
import '../../models/profile_data_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/route_generate.dart';
import '../../utils/session.dart';
import 'wallet_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/transactionBloc/transaction_bloc.dart';
import '../../bloc/transactionBloc/transaction_event.dart';
// Import your booking_bloc and ProfileDataModel files here
// import 'path/to/booking_bloc.dart';
// import 'path/to/profile_data_model.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isLoading = true;
  String? errorMessage;
  ProfileDataModel? profileDataModel;
  String accessTokenHopzy = "";

  getHopzyToken() async {
    accessTokenHopzy = await Session().getHopzyAccessToken();
  }

  @override
  void initState() {
    getHopzyToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountBloc()..add(FetchUserProfileEvent()),
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) async {
          if (state is AccountSuccess) {
            debugPrint("✅ Profile fetched successfully");
          } else if (state is AccountError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is AccountLogout) {
            await Session().clearAllData();

            // Navigate back to login screen and clear history
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginWithOtpScreen,
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            // ✅ Loading
            if (state is AccountLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // ❌ Error UI
            if (state is AccountError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, size: 80, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        "User not logged in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 16),

                      accessTokenHopzy != ""
                          ? Container()
                          : InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.loginWithOtpScreen,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.login,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }

            // ✅ Success UI
            if (state is AccountSuccess) {
              final profile = state.userProfile;
              final wallet = profile.data?.wallet;
              final bookings = profile.data?.bookings;

              final name =
                  "${profile.data?.user?.firstName ?? ''} ${profile.data?.user?.lastName ?? ''}"
                      .trim();
              final contact =
                  profile.data?.user?.email ?? profile.data?.user?.phone ?? "";
              final phone =
                  profile.data?.user?.phone ?? profile.data?.user?.phone ?? "";

              final initials = name.isNotEmpty
                  ? name
                        .split(" ")
                        .where((e) => e.isNotEmpty)
                        .map((e) => e.isNotEmpty ? e[0] : '')
                        .join()
                        .toUpperCase()
                  : "?";

              return Scaffold(
                body: RefreshIndicator(
                  onRefresh: () async {
                    context.read<AccountBloc>().add(FetchUserProfileEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // ✅ Profile Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[300],
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      contact,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      phone, // your phone variable
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),

                                    // OutlinedButton(
                                    //   onPressed: () {},
                                    //   style: OutlinedButton.styleFrom(
                                    //     foregroundColor: Colors.green,
                                    //     side: const BorderSide(color: Colors.green),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(8),
                                    //     ),
                                    //   ),
                                    //   child: const Text("Edit Profile"),
                                    // ),
                                    // ✅ Show phone number
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),

                        // ✅ Wallet
                        if (wallet != null)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => TransactionBloc(),
                                    child: Builder(
                                      builder: (context) {
                                        // Initialize the bloc when the widget is built
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              context
                                                  .read<TransactionBloc>()
                                                  .add(
                                                    FetchTransactionsEvent(),
                                                  );
                                            });
                                        return WalletScreen(
                                          walletBalance: wallet,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Wallet Balance",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹${wallet.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Tap to view details",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // ✅ Bookings
                        if (bookings != null)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bookmark_border,
                                    color: Colors.blue[700],
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Bookings",
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "$bookings",
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        // ✅ Menu Section
                        _menuTile(
                          Icons.account_balance_wallet,
                          "Hopzy Account",
                          "Manage your account details",
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (dialogContext) => BlocProvider.value(
                            //     value: context.read<AccountBloc>(),
                            //     child: EditProfileDialog(
                            //       userId:
                            //           profile.data?.user?.sId ??
                            //           '', // Replace with your actual userId field
                            //       currentFirstName:
                            //           profile.data?.user?.firstName ?? '',
                            //       currentLastName:
                            //           profile.data?.user?.lastName ?? '',
                            //       currentEmail: profile.data?.user?.email ?? '',
                            //       currentState:
                            //           profile.data?.user?.state ??
                            //           '', // Add state field to your model if not present
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                        _divider(),
                        _menuTile(
                          Icons.star_outline,
                          "Help Us",
                          "Share your feedback",
                        ),
                        _divider(),
                        _menuTile(
                          Icons.logout,
                          "Logout",
                          "Tap to logout",
                          onTap: () {
                            context.read<AccountBloc>().add(LogoutEvent());
                          },
                        ),

                        _divider(),
                        _menuTile(
                          Icons.info_outline,
                          "About",
                          "Learn more about the app",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );
  }

  Widget _menuTile(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 56);
}
