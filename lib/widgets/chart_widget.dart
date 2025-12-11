import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/simulator_outputs.dart';

class ProfitChart extends StatelessWidget {
  final SimulatorOutputs outputs;

  const ProfitChart({super.key, required this.outputs});

  double _shorten(double value) {
    if (value.abs() >= 100000) return (value / 1000).roundToDouble();
    if (value.abs() >= 1000) {
      return double.parse((value / 1000).toStringAsFixed(1));
    }
    return value;
  }

  String _label(double value) {
    if (value.abs() >= 100000) return "${_shorten(value)}k";
    if (value.abs() >= 1000) return "${_shorten(value)}k";
    return value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final values = [
      outputs.revenue,
      outputs.cogs,
      outputs.grossProfit,
      outputs.totalFixedCosts,
      outputs.netProfit,
    ];

    double minY = values.reduce((a, b) => a < b ? a : b);
    double maxY = values.reduce((a, b) => a > b ? a : b);

    // Add padding to top/bottom
    minY = minY * 0.9;
    maxY = maxY * 1.1;

    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8),
      child: SizedBox(
        height: 260,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 4,
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: ((maxY - minY) / 5).clamp(1, double.infinity),
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: Colors.grey.shade400, width: 1),
                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    const labels = ["Rev", "COGS", "GP", "FC", "NP"];

                    int index = value.toInt();
                    if (index < 0 || index > 4) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: (maxY - minY) / 4,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        _label(value),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                barWidth: 3.5,
                color: Colors.blue.shade600,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: Colors.blue.shade700,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400.withOpacity(0.3),
                      Colors.blue.shade200.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                spots: [
                  FlSpot(0, outputs.revenue),
                  FlSpot(1, outputs.cogs),
                  FlSpot(2, outputs.grossProfit),
                  FlSpot(3, outputs.totalFixedCosts),
                  FlSpot(4, outputs.netProfit),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
