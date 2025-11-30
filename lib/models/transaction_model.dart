// Transaction models
enum TransactionType { credit, debit }

enum TransactionStatus { success, pending, failed }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id']?.toString() ?? '',
      description: json['description'] ?? json['type'] ?? 'Transaction',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      type: _parseTransactionType(json['type'] ?? json['transaction_type']),
      status: _parseTransactionStatus(json['status']),
      date:
          DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ??
          DateTime.now(),
    );
  }

  static TransactionType _parseTransactionType(dynamic type) {
    switch (type?.toString().toLowerCase()) {
      case 'credit':
      case 'refund':
      case 'cashback':
      case 'wallet_top_up':
      case 'deposit':
        return TransactionType.credit;
      case 'debit':
      case 'payment':
      case 'booking':
      case 'purchase':
      case 'withdrawal':
        return TransactionType.debit;
      default:
        return TransactionType.debit;
    }
  }

  static TransactionStatus _parseTransactionStatus(dynamic status) {
    switch (status?.toString().toLowerCase()) {
      case 'success':
      case 'successful':
      case 'completed':
      case 'approved':
      case 'confirmed':
        return TransactionStatus.success;
      case 'pending':
      case 'processing':
      case 'initiated':
        return TransactionStatus.pending;
      case 'failed':
      case 'rejected':
      case 'cancelled':
      case 'declined':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}
