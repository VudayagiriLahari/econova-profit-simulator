import 'package:flutter/material.dart';

class InputSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String prefix;
  final String suffix;
  final ValueChanged<double> onChanged;

  const InputSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.step = 1,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final display =
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                  child: Text(label,
                      style: const TextStyle(fontWeight: FontWeight.w600))),
              Text('$prefix$display$suffix',
                  style: const TextStyle(
                      fontFamily: 'monospace', fontWeight: FontWeight.w700)),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: ((max - min) / step).round(),
            label: '$prefix$display$suffix',
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$prefix${min.toStringAsFixed(0)}$suffix'),
              Text('$prefix${max.toStringAsFixed(0)}$suffix')
            ],
          ),
        ]),
      ),
    );
  }
}
