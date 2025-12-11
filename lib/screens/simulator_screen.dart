import 'package:flutter/material.dart';
import '../logic/profit_calculator.dart';
import '../widgets/chart_widget.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen>
    with SingleTickerProviderStateMixin {
  late final SimulatorModel model;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    model = SimulatorModel();
    model.addListener(() {
      if (mounted) setState(() {});
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    model.dispose();
    super.dispose();
  }

  Widget _metricTile(String label, String value,
      {IconData? icon, Color? color, String? subtitle}) {
    return Card(
      elevation: 3,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color?.withOpacity(0.2) ?? Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 20, color: color),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.black87,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopStats() {
    final o = model.outputs;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _metricTile("Revenue", SimulatorModel.formatCurrency(o.revenue),
            icon: Icons.attach_money_rounded, color: Colors.teal.shade600),
        _metricTile("Net Profit", SimulatorModel.formatCurrency(o.netProfit),
            icon: o.netProfit >= 0
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color:
                o.netProfit >= 0 ? Colors.green.shade600 : Colors.red.shade600),
        _metricTile("Profit Margin",
            SimulatorModel.formatPercentage(o.profitMarginPercent),
            icon: Icons.percent_rounded, color: Colors.blue.shade600),
        _metricTile(
          "Break-Even",
          SimulatorModel.formatCustomers(o.breakEvenCustomers),
          icon: Icons.speed_rounded,
          color: Colors.orange.shade600,
          subtitle: model.inputs.monthlyCustomers >= o.breakEvenCustomers
              ? '✓ Profitable!'
              : 'Need ${(o.breakEvenCustomers - model.inputs.monthlyCustomers).ceil()} more',
        ),
      ],
    );
  }

  Widget _slider(String key, String label, double min, double max, double step,
      double value,
      {String prefix = '', String suffix = '', IconData? icon}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: Colors.teal.shade700),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$prefix${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}$suffix",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.teal.shade600,
                inactiveTrackColor: Colors.teal.shade100,
                thumbColor: Colors.teal.shade700,
                overlayColor: Colors.teal.shade100,
                trackHeight: 4,
              ),
              child: Slider(
                min: min,
                max: max,
                divisions: ((max - min) / (step <= 0 ? 1 : step))
                    .round()
                    .clamp(1, 5000),
                value: value.clamp(min, max),
                onChanged: (v) => model.updateInput(key, v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderColumn() {
    final i = model.inputs;
    return Column(
      children: [
        _slider("sellingPrice", "Selling Price", 10, 10000, 5, i.sellingPrice,
            prefix: "₹", icon: Icons.shopping_bag_rounded),
        const SizedBox(height: 8),
        _slider("costPrice", "Cost Price", 1, 5000, 5, i.costPrice,
            prefix: "₹", icon: Icons.shopping_cart_rounded),
        const SizedBox(height: 8),
        _slider("monthlyCustomers", "Monthly Customers", 1, 10000, 10,
            i.monthlyCustomers.toDouble(),
            suffix: " customers", icon: Icons.people_rounded),
        const SizedBox(height: 8),
        _slider("rent", "Monthly Rent", 0, 100000, 500, i.rent,
            prefix: "₹", icon: Icons.home_rounded),
        const SizedBox(height: 8),
        _slider("utilities", "Utilities", 0, 50000, 200, i.utilities,
            prefix: "₹", icon: Icons.electric_bolt_rounded),
        const SizedBox(height: 8),
        _slider("marketingSpend", "Marketing Budget", 0, 50000, 500,
            i.marketingSpend,
            prefix: "₹", icon: Icons.campaign_rounded),
      ],
    );
  }

  Widget _suggestions() {
    final s = model.suggestions;
    if (s.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.check_circle_rounded,
                  size: 48, color: Colors.green.shade400),
              const SizedBox(height: 12),
              const Text(
                "Everything looks good!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: s.map((item) {
        Color priorityColor;
        IconData priorityIcon;

        switch (item.priority) {
          case 'high':
            priorityColor = Colors.red.shade600;
            priorityIcon = Icons.priority_high_rounded;
            break;
          case 'medium':
            priorityColor = Colors.orange.shade600;
            priorityIcon = Icons.warning_rounded;
            break;
          default:
            priorityColor = Colors.blue.shade600;
            priorityIcon = Icons.info_rounded;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(priorityIcon, color: priorityColor, size: 24),
            ),
            title: Text(
              item.action,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(item.impact),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.priority.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: priorityColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final out = model.outputs;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics_rounded, color: Colors.teal.shade700),
            const SizedBox(width: 8),
            const Text("Econova Profit Simulator"),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade400, Colors.teal.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset to defaults',
            onPressed: () {
              setState(() {
                model.inputs = model.inputs.copyWith(
                  sellingPrice: 500,
                  costPrice: 200,
                  monthlyCustomers: 100,
                  rent: 15000,
                  utilities: 5000,
                  marketingSpend: 5000,
                );
                model.updateInput('sellingPrice', 500);
              });
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade700,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📊 Business Profitability Dashboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Analyze and optimize your business performance in real-time",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Top Stats
              _buildTopStats(),
              const SizedBox(height: 24),

              // Input Controls Section
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.tune_rounded, color: Colors.teal.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            "Adjust Your Business Parameters",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _sliderColumn(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Chart Section
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.show_chart_rounded,
                              color: Colors.teal.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            "Profitability Visualization",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          height: 280,
                          child: ProfitChart(outputs: out),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Suggestions Section
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_rounded,
                              color: Colors.amber.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            "Smart Recommendations",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _suggestions(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
