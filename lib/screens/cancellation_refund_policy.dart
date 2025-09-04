import 'package:flutter/material.dart';
import 'package:ridebooking/models/ticket_details_model.dart';

class CancellationRefundView extends StatelessWidget {
  final List<CancellationPolicy> cancellationPolicy;
  final List<CancellationRefundPolicy> cancellationRefundPolicy;

  const CancellationRefundView({
    Key? key,
    required this.cancellationPolicy,
    required this.cancellationRefundPolicy,
  }) : super(key: key);

  Widget _buildPolicySection(String title,  bool isRefund,{List<CancellationPolicy>? data,List<CancellationRefundPolicy>? refundData}) {
    List<CancellationPolicy>? data = isRefund ? null : cancellationPolicy;
    List<CancellationRefundPolicy>? refundData = isRefund ? cancellationRefundPolicy : null;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Column(
              children: data!=null?data.map((item) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.description?? ""),
                  subtitle:  Text(
                          "Refund: ${item.refundpercent}% • Charge: ${item.cancellationcharge}%"),
                );
              }).toList():refundData!.map((item) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.description?? ""),
                  subtitle: Text("Cancellation Charge: ${item.cancellationcharge}%")
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // _buildPolicySection("Cancellation Policy",data:  cancellationPolicy, false),
          _buildPolicySection("Cancellation Policy",refundData:  cancellationRefundPolicy, true),
        ],
      ),
    );
  }
}
