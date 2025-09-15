import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BusSearchShimmer extends StatelessWidget {
  const BusSearchShimmer({super.key});

  Widget _shimmerBox({
    double? height,
    double? width,
    EdgeInsetsGeometry? margin,
    double radius = 12,
  }) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                _shimmerBox(
                  height: 40,
                  width: 280,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  radius: 8,
                ),

                const SizedBox(height: 16),

                // Search box area
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      // From field
                      Row(
                        children: [
                          const SizedBox(width: 40),
                          Expanded(
                            child: _shimmerBox(height: 50, margin: const EdgeInsets.only(bottom: 12)),
                          ),
                        ],
                      ),

                      // To field
                      Row(
                        children: [
                          const SizedBox(width: 40),
                          Expanded(
                            child: _shimmerBox(height: 50, margin: const EdgeInsets.only(bottom: 12)),
                          ),
                        ],
                      ),

                      // Today / Tomorrow / Another button
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _shimmerBox(
                              height: 40,
                              margin: const EdgeInsets.only(right: 8, bottom: 12),
                            ),
                          ),
                          Expanded(
                            child: _shimmerBox(
                              height: 40,
                              margin: const EdgeInsets.only(right: 8, bottom: 12),
                            ),
                          ),
                          Expanded(
                            child: _shimmerBox(
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Search button
                      _shimmerBox(height: 48, width: double.infinity),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Centered wide button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _shimmerBox(
                      height: 50,
                      width: 280,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      radius: 8,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // List items shimmer (repeatable)
                ...List.generate(2, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(height: 20, width: 150, radius: 5),
                        const SizedBox(height: 10),
                        _shimmerBox(height: 50),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
