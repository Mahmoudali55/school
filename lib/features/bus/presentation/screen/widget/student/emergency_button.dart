import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  final VoidCallback showDialogCallback;

  const EmergencyButton({super.key, required this.showDialogCallback});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: showDialogCallback,
      child: const Icon(Icons.emergency_rounded, color: Colors.white),
    );
  }
}
