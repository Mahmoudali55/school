
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/payment/card_back_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/payment/card_front_widget.dart';
class AnimatedCreditCard extends StatefulWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiry;
  final String cvv;
  final bool isFlipped;

  const AnimatedCreditCard({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiry,
    required this.cvv,
    required this.isFlipped,
  });

  @override
  State<AnimatedCreditCard> createState() => _AnimatedCreditCardState();
}

class _AnimatedCreditCardState extends State<AnimatedCreditCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(AnimatedCreditCard old) {
    super.didUpdateWidget(old);
    if (widget.isFlipped != old.isFlipped) {
      widget.isFlipped ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────────────────────

  String get _formattedNumber {
    final raw = widget.cardNumber.replaceAll(' ', '');
    final padded = raw.padRight(16, '*');
    final groups = <String>[];
    for (int i = 0; i < 16; i += 4) {
      groups.add(padded.substring(i, i + 4));
    }
    return groups.join('  ');
  }

  String get _displayHolder {
    final v = widget.cardHolder.trim();
    return v.isEmpty ? 'CARDHOLDER NAME' : v.toUpperCase();
  }

  String get _displayExpiry {
    final v = widget.expiry.trim();
    return v.isEmpty ? 'MM/YY' : v;
  }

  // ─── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, _) {
        final angle = _flipAnimation.value * pi;
        final isFront = angle <= pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isFront
              ? CardFront(
                  formattedNumber: _formattedNumber,
                  displayHolder: _displayHolder,
                  displayExpiry: _displayExpiry,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: CardBack(cvv: widget.cvv),
                ),
        );
      },
    );
  }
}







