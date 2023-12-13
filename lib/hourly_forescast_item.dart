import 'package:flutter/material.dart';

class HourlyForeCastItem extends StatelessWidget {
  const HourlyForeCastItem({
    super.key,
    required this.time,
    required this.climate,
    required this.skyIcon,
  });

final String time;
final IconData skyIcon;
final String climate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 130,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
           Icon(
              skyIcon,
              size: 30,
            ),
            const Spacer(),
            Text(
              climate,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}