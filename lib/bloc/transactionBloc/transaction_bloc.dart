import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../models/transaction_model.dart';
import '../../utils/session.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<FetchTransactionsEvent>(_onFetchTransactions);
    on<RefreshTransactionsEvent>(_onRefreshTransactions);
  }

  Future<void> _onFetchTransactions(
    FetchTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      // Get user token from session
      final token = await Session().getHopzyAccessToken();

      if (token.isEmpty) {
        emit(
          TransactionError(
            'Authentication token not found. Please login again.',
          ),
        );
        return;
      }

      // Fetch wallet balance and transactions concurrently
      final walletBalance = await _fetchWalletBalance(token);
      final transactions = await _fetchTransactionsFromAPI(token);

      emit(
        TransactionLoaded(
          transactions: transactions,
          walletBalance: walletBalance,
        ),
      );
    } catch (error) {
      emit(TransactionError('Failed to fetch transactions: $error'));
    }
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final token = await Session().getHopzyAccessToken();

      if (token.isEmpty) {
        emit(
          TransactionError(
            'Authentication token not found. Please login again.',
          ),
        );
        return;
      }

      final walletBalance = await _fetchWalletBalance(token);
      final transactions = await _fetchTransactionsFromAPI(token);

      emit(
        TransactionLoaded(
          transactions: transactions,
          walletBalance: walletBalance,
        ),
      );
    } catch (error) {
      emit(TransactionError('Failed to refresh transactions: $error'));
    }
  }

  Future<double> _fetchWalletBalance(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://prodapi.hopzy.in/api/private/wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 1 && data['data'] != null) {
          return double.tryParse(data['data']['balance']?.toString() ?? '0') ??
              0.0;
        } else {
          throw Exception('Invalid wallet balance response format');
        }
      } else {
        throw Exception(
          'Failed to fetch wallet balance: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error while fetching wallet balance: $e');
    }
  }

  Future<List<Transaction>> _fetchTransactionsFromAPI(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://prodapi.hopzy.in/api/private/wallet/transactions?limit=500&page=1',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Transaction> transactions = [];

        if (data['status'] == 1 &&
            data['data'] != null &&
            data['data']['transactions'] != null) {
          for (var item in data['data']['transactions']) {
            transactions.add(Transaction.fromJson(item));
          }
        }

        // Sort transactions by date (newest first)
        transactions.sort((a, b) => b.date.compareTo(a.date));

        return transactions;
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error while fetching transactions: $e');
    }
  }
}
