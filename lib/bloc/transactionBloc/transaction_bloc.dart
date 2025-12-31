import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
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
      final walletBalance = await _fetchWalletBalance();
      final transactions = await _fetchTransactionsFromAPI();

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

      final walletBalance = await _fetchWalletBalance();
      final transactions = await _fetchTransactionsFromAPI();

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

  Future<double> _fetchWalletBalance() async {
    try {
      final response = await ApiRepository.getAPI(
        ApiConst.walletBalance,
        basurl2: ApiConst.baseUrl2,
      );

      print("Wallet API Response Status: ${response.statusCode}");
      print("Wallet API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data =
            response.data; // Use .data instead of json.decode(response.body)

        if (data['status'] == 1 && data['data'] != null) {
          return double.tryParse(data['data']['balance']?.toString() ?? '0') ??
              0.0;
        } else {
          throw Exception(
            'Invalid wallet balance response format: ${data['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception(
          'Failed to fetch wallet balance: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Wallet balance error details: $e");
      throw Exception('Network error while fetching wallet balance: $e');
    }
  }

  Future<List<Transaction>> _fetchTransactionsFromAPI() async {
    try {
      final response = await ApiRepository.getAPI(
        ApiConst.getTransactions,
        basurl2: ApiConst.baseUrl2,
      );

      print("Transactions API Response Status: ${response.statusCode}");
      print("Transactions API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data =
            response.data; // Use .data instead of json.decode(response.body)

        List<Transaction> transactions = [];

        if (data['status'] == 1) {
          if (data['data'] != null && data['data']['transactions'] != null) {
            for (var item in data['data']['transactions']) {
              try {
                transactions.add(Transaction.fromJson(item));
              } catch (parseError) {
                print("Failed to parse transaction: $item, error: $parseError");
                // Continue with other transactions
              }
            }
          } else {
            print("No transactions found in response");
          }
        } else {
          throw Exception(
            'API Error: ${data['message'] ?? 'Unknown error'} (Status: ${data['status']})',
          );
        }

        // Sort transactions by date (newest first)
        transactions.sort((a, b) => b.date.compareTo(a.date));
        print("Successfully parsed ${transactions.length} transactions");

        return transactions;
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      print("Transactions fetch error details: $e");
      throw Exception('Network error while fetching transactions: $e');
    }
  }
}
