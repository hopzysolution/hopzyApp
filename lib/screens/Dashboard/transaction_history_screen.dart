import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/transactionBloc/transaction_bloc.dart';
import '../../bloc/transactionBloc/transaction_event.dart';
import '../../bloc/transactionBloc/transaction_state.dart';
import '../../models/transaction_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final double walletBalance;

  const TransactionHistoryScreen({Key? key, required this.walletBalance})
    : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Credit, 2: Debit
  // ================================================================

  @override
  void initState() {
    super.initState();
    // Fetch real transactions when screen loads
    context.read<TransactionBloc>().add(FetchTransactionsEvent());
  }

  // Filter transactions based on selected chip
  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    switch (_selectedFilterIndex) {
      case 0: // All
        return transactions;
      case 1: // Credit
        return transactions
            .where((t) => t.type == TransactionType.credit)
            .toList();
      case 2: // Debit
        return transactions
            .where((t) => t.type == TransactionType.debit)
            .toList();
      default:
        return transactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _buildFilterChip('All', 0),
                const SizedBox(width: 8),
                _buildFilterChip('Credit', 1),
                const SizedBox(width: 8),
                _buildFilterChip('Debit', 2),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }

                if (state is TransactionError) {
                  return _buildErrorState(state.message);
                }

                if (state is TransactionLoaded) {
                  final filteredTransactions = _filterTransactions(
                    state.transactions,
                  );
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TransactionBloc>().add(
                        RefreshTransactionsEvent(),
                      );
                    },
                    child: _buildTransactionList(filteredTransactions),
                  );
                }

                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    Color chipColor;
    Color textColor;

    if (isSelected) {
      if (index == 1) {
        chipColor = Colors.green;
        textColor = Colors.white;
      } else if (index == 2) {
        chipColor = Colors.red;
        textColor = Colors.white;
      } else {
        chipColor = Colors.blue;
        textColor = Colors.white;
      }
    } else {
      chipColor = Colors.grey[200]!;
      textColor = Colors.grey[700]!;
    }

    return Expanded(
      child: FilterChip(
        label: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
        backgroundColor: chipColor,
        selectedColor: chipColor,
        checkmarkColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error Loading Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<TransactionBloc>().add(FetchTransactionsEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    String subtitle;

    switch (_selectedFilterIndex) {
      case 1: // Credit
        message = "No credit transactions";
        icon = Icons.arrow_downward;
        subtitle = "Your credit transactions will appear here";
        break;
      case 2: // Debit
        message = "No debit transactions";
        icon = Icons.arrow_upward;
        subtitle = "Your debit transactions will appear here";
        break;
      default: // All
        message = "No transactions yet";
        icon = Icons.receipt_long_outlined;
        subtitle = "Your transactions will appear here";
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isCredit = transaction.type == TransactionType.credit;
    final isFailed = transaction.status == TransactionStatus.failed;
    final isPending = transaction.status == TransactionStatus.pending;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              _formatDate(transaction.date),
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isFailed
                    ? Colors.red.withOpacity(0.1)
                    : isPending
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.status.name.toUpperCase(),
                style: TextStyle(
                  color: isFailed
                      ? Colors.red
                      : isPending
                      ? Colors.orange
                      : Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isFailed
                    ? Colors.grey
                    : isCredit
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
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
