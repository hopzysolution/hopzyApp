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
  @override
  void initState() {
    super.initState();
    // Fetch real transactions when screen loads
    context.read<TransactionBloc>().add(FetchTransactionsEvent());
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
      body: BlocBuilder<TransactionBloc, TransactionState>(
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
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionBloc>().add(RefreshTransactionsEvent());
              },
              child: _buildTransactionList(state.transactions),
            );
          }

          return _buildEmptyState();
        },
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No transactions yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your transactions will appear here",
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
