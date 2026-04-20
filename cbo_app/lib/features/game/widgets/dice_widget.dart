import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class DiceWidget extends StatefulWidget {
  final int? value;
  final bool rolling;
  final VoidCallback? onTap;

  const DiceWidget({
    super.key,
    this.value,
    this.rolling = false,
    this.onTap,
  });

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.rolling) _controller.repeat();
  }

  @override
  void didUpdateWidget(DiceWidget old) {
    super.didUpdateWidget(old);
    if (widget.rolling && !old.rolling) {
      _controller.repeat();
    } else if (!widget.rolling && old.rolling) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) => Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: child,
        ),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kPrimaryContainer, kPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: kPrimary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.value != null ? '${widget.value}' : '?',
              style: const TextStyle(
                fontFamily: 'NotoSerif',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: kOnSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
