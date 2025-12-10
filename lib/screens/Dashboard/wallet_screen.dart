import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/screens/Dashboard/dashboard_screen.dart';
import 'transaction_history_screen.dart';
import '../../bloc/transactionBloc/transaction_bloc.dart';
import '../../bloc/transactionBloc/transaction_event.dart';
import '../../bloc/transactionBloc/transaction_state.dart';
import '../../models/transaction_model.dart';

class WalletScreen extends StatefulWidget {
  final double walletBalance;

  const WalletScreen({Key? key, required this.walletBalance}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool showBalance = true;
  // Added on Dec 7, 2025 - Dropdown filter for transactions
  String _selectedWalletFilter = 'All'; // 'All', 'Credit', 'Debit'

  @override
  void initState() {
    super.initState();
    // Load wallet data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<TransactionBloc>().state is! TransactionLoaded) {
        context.read<TransactionBloc>().add(FetchTransactionsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        // Handle any side effects if needed
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'My Wallet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green.shade600,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  showBalance ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    showBalance = !showBalance;
                  });
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Refresh real wallet data
              context.read<TransactionBloc>().add(RefreshTransactionsEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Wallet Balance Card
                  _buildBalanceCard(),

                  const SizedBox(height: 16),

                  // Quick Actions
                  _buildQuickActions(),

                  const SizedBox(height: 24),

                  // Transaction History
                  _buildTransactionHistory(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
            Colors.green.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Available Balance",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              double balance =
                  widget.walletBalance; // Fallback to passed balance

              if (state is TransactionLoaded) {
                balance = state.walletBalance;
              }

              return Text(
                showBalance ? "₹${balance.toStringAsFixed(2)}" : "₹****.**",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Reedem Wallet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: _buildActionButton(
          icon: Icons.history,
          label: "View Transaction History",
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => TransactionBloc(),
                  child: Builder(
                    builder: (context) {
                      // Initialize the bloc for transaction history screen
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<TransactionBloc>().add(
                          FetchTransactionsEvent(),
                        );
                      });
                      return TransactionHistoryScreen(
                        walletBalance: widget.walletBalance,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Added on Dec 7, 2025 - Header with dropdown filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Added on Dec 7, 2025 - Dropdown for filtering transactions
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value: _selectedWalletFilter,
                    underline: const SizedBox(),
                    isDense: true,
                    dropdownColor: Colors.white,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text(
                          'All',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Credit',
                        child: Text(
                          'Credit',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Debit',
                        child: Text(
                          'Debit',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                    selectedItemBuilder: (BuildContext context) {
                      return ['All', 'Credit', 'Debit'].map<Widget>((
                        String item,
                      ) {
                        return Center(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedWalletFilter = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                );
              }

              if (state is TransactionError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[300],
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load transactions',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<TransactionBloc>().add(
                              FetchTransactionsEvent(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is TransactionLoaded) {
                List<Transaction> filteredTransactions = state.transactions;

                switch (_selectedWalletFilter) {
                  case 'Credit':
                    filteredTransactions = state.transactions
                        .where((t) => t.type == TransactionType.credit)
                        .toList();
                    break;
                  case 'Debit':
                    filteredTransactions = state.transactions
                        .where((t) => t.type == TransactionType.debit)
                        .toList();
                    break;
                  case 'All':
                  default:
                    filteredTransactions = state.transactions;
                }

                final recentTransactions = filteredTransactions
                    .take(5)
                    .toList();

                if (recentTransactions.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return _buildTransactionTile(transaction);
                  },
                );
              }

              return _buildEmptyState();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Center(
            child: Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No transactions yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your transaction history will appear here",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    final isCredit = transaction.type == TransactionType.credit;
    final isFailed = transaction.status == TransactionStatus.failed;
    final isPending = transaction.status == TransactionStatus.pending;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isFailed
              ? Colors.red.withOpacity(0.1)
              : isPending
              ? Colors.orange.withOpacity(0.1)
              : isCredit
              ? Colors.green.withOpacity(0.1)
              : Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFailed
              ? Icons.close
              : isPending
              ? Icons.access_time
              : isCredit
              ? Icons.add
              : Icons.remove,
          color: isFailed
              ? Colors.red
              : isPending
              ? Colors.orange
              : isCredit
              ? Colors.green
              : Colors.blue,
          size: 20,
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(transaction.date),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          if (isFailed || isPending)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isFailed
                    ? Colors.red.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                transaction.status.name.toUpperCase(),
                style: TextStyle(
                  color: isFailed ? Colors.red : Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      trailing: Text(
        "${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}",
        style: TextStyle(
          color: isFailed
              ? Colors.red
              : isCredit
              ? Colors.green
              : Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference < 7) {
      return "$difference days ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
