import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapSection extends StatelessWidget {
  final List<Map<String, dynamic>> stops;
  final Animation<double> busAnimation;
  final bool isBusMoving;

  const MapSection({
    super.key,
    required this.stops,
    required this.busAnimation,
    required this.isBusMoving,
  });

  @override
  Widget build(BuildContext context) {
    int currentIndex = stops.indexWhere((stop) => stop['current'] == true);
    double progress = currentIndex / (stops.length - 1);
    double position = progress * (MediaQuery.of(context).size.width - 100.w);

    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          ...stops.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> stop = entry.value;
            double stopPos =
                (index / (stops.length - 1)) * (MediaQuery.of(context).size.width - 80.w);
            return Positioned(
              left: 20.w + stopPos,
              top: 70.h,
              child: Column(
                children: [
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: stop['current']
                          ? const Color(0xFF4CAF50)
                          : stop['passed']
                          ? const Color(0xFF4CAF50).withOpacity(0.5)
                          : const Color(0xFF9CA3AF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    stop['name'],
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            left: 20.w + position,
            top: 60.h,
            child: AnimatedBuilder(
              animation: busAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, isBusMoving ? busAnimation.value : 0),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.directions_bus_rounded,
                      color: const Color(0xFF4CAF50),
                      size: 32.w,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
