import 'package:flutter/material.dart';

class AdditionalInformationItem extends StatelessWidget {
  const AdditionalInformationItem({
    super.key,
    required this.info,
    required this.skyIcon,
    required this.value
  });
final String info;
final IconData skyIcon;
final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            const SizedBox(height: 14),
             Icon(
              skyIcon,
              size: 30,
            ),
            const Spacer(),
            Text(
              info,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              value,
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
