
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/seate_selection_bloc.dart';
import 'package:ridebooking/services/seat_services.dart';
import 'package:ridebooking/widgets/seat_layout_widget.dart';
import '../bloc/events/seat_selection_event.dart';
import '../bloc/states/seat_selection_state.dart';

class SeatSelectionScreen extends StatelessWidget {
  const SeatSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SeatSelectionBloc(SeatService())..add(const LoadSeats()),
      child: const _SeatSelectionView(),
    );
  }
}

class _SeatSelectionView extends StatelessWidget {
  const _SeatSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<SeatSelectionBloc, SeatSelectionState>(
        listener: (context, state) {
          if (state is SeatSelectionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // _buildBusInfo(),
              // const SeatLegend(),
              Expanded(
                child: _buildBody(context, state),
              ),
              _buildBottomBar(context, state),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Select Seats',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        BlocBuilder<SeatSelectionBloc, SeatSelectionState>(
          builder: (context, state) {
            if (state is SeatSelectionLoaded &&
                state.selectedSeatIds.isNotEmpty) {
              return TextButton(
                onPressed: () {
                  context.read<SeatSelectionBloc>().add(const ClearSelection());
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBusInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'AC SLEEPER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.star,
                color: Color(0xFFFFB300),
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                '4.2',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'RedBus Travels',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF666666),
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                'Bangalore',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xFF666666),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Chennai',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '8h 30m',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                '10:00 PM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(width: 16),
              Icon(
                Icons.more_horiz,
                color: Color(0xFF666666),
                size: 20,
              ),
              SizedBox(width: 16),
              Text(
                '6:30 AM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, SeatSelectionState state) {
    if (state is SeatSelectionLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD84E55)),
        ),
      );
    }

    if (state is SeatSelectionError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<SeatSelectionBloc>().add(const LoadSeats());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is SeatSelectionLoaded) {
      return SingleChildScrollView(
        child: SeatLayout(
          seats: state.seats,
          selectedSeatIds: state.selectedSeatIds,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBottomBar(BuildContext context, SeatSelectionState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BlocBuilder<SeatSelectionBloc, SeatSelectionState>(
          builder: (context, state) {
            if (state is SeatSelectionLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.selectedSeatIds.isNotEmpty) ...[
                    _buildSelectionInfo(state),
                    const SizedBox(height: 16),
                  ],
                  _buildProceedButton(context, state),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSelectionInfo(SeatSelectionLoaded state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Seats: ${state.selectedSeatIds.join(", ")}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.selectedSeatCount} seat${state.selectedSeatCount > 1 ? 's' : ''} selected',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${state.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD84E55),
                ),
              ),
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton(BuildContext context, SeatSelectionLoaded state) {
    final isEnabled = state.selectedSeatIds.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                _showBookingDialog(context, state);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD84E55),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE0E0E0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isEnabled
              ? 'Proceed to Payment (₹${state.totalPrice.toStringAsFixed(0)})'
              : 'Select Seats to Continue',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, SeatSelectionLoaded state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Seats: ${state.selectedSeatIds.join(", ")}'),
            const SizedBox(height: 8),
            Text('Total Amount: ₹${state.totalPrice.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            const Text('Route: Bangalore → Chennai'),
            const Text('Time: 10:00 PM - 6:30 AM'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Booking confirmed for seats ${state.selectedSeatIds.join(", ")}!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD84E55),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}
