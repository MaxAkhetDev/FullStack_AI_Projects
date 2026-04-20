import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants.dart';

class CboGrid extends StatelessWidget {
  final List<List<int>> grid;
  final List<int> highlightedNumbers;

  const CboGrid({
    super.key,
    required this.grid,
    required this.highlightedNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = (constraints.maxWidth - 24) / 3;
        return SizedBox(
          width: constraints.maxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(grid.length, (rowIdx) {
              return SizedBox(
                width: constraints.maxWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(grid[rowIdx].length, (colIdx) {
                    final number = grid[rowIdx][colIdx];
                    final isHighlighted = highlightedNumbers.contains(number);
                    return _GridCell(
                      key: ValueKey('cell_$number'),
                      number: number,
                      size: cellSize,
                      highlighted: isHighlighted,
                    );
                  }),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _GridCell extends StatelessWidget {
  final int number;
  final double size;
  final bool highlighted;

  const _GridCell({
    super.key,
    required this.number,
    required this.size,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: highlighted
            ? kPrimaryContainer.withOpacity(0.6)
            : kSurfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: kPrimary.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            fontFamily: 'NotoSerif',
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            color: highlighted ? kPrimary : kOnSurface,
          ),
        ),
      ),
    )
        .animate(target: highlighted ? 1.0 : 0.0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.08, 1.08),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}
