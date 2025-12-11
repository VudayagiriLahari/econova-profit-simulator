import 'package:flutter/foundation.dart';
import '../models/simulator_inputs.dart';
import '../models/simulator_outputs.dart';

enum ScenarioType { base, optimistic, pessimistic }

class ProfitSuggestion {
  final String id;
  final String action;
  final String impact;
  final String type;
  final String priority;

  ProfitSuggestion({
    required this.id,
    required this.action,
    required this.impact,
    required this.type,
    required this.priority,
  });
}

class ChartPoint {
  final double customers;
  final double revenue;
  final double totalCost;
  final double profit;

  ChartPoint({
    required this.customers,
    required this.revenue,
    required this.totalCost,
    required this.profit,
  });
}

class SimulatorModel extends ChangeNotifier {
  late SimulatorInputs inputs;
  late SimulatorOutputs outputs;
  late List<ProfitSuggestion> suggestions;
  ScenarioType activeScenario = ScenarioType.base;

  SimulatorModel() {
    inputs = SimulatorInputs(
      sellingPrice: 500.0,
      costPrice: 250.0,
      monthlyCustomers: 100,
      rent: 10000.0,
      utilities: 2000.0,
      marketingSpend: 5000.0,
    );
    _calculate();
  }

  void updateInput(String key, double value) {
    switch (key) {
      case 'sellingPrice':
        inputs = inputs.copyWith(sellingPrice: value);
        break;
      case 'costPrice':
        inputs = inputs.copyWith(costPrice: value);
        break;
      case 'monthlyCustomers':
        inputs = inputs.copyWith(monthlyCustomers: value.toInt());
        break;
      case 'rent':
        inputs = inputs.copyWith(rent: value);
        break;
      case 'utilities':
        inputs = inputs.copyWith(utilities: value);
        break;
      case 'marketingSpend':
        inputs = inputs.copyWith(marketingSpend: value);
        break;
    }
    _calculate();
    notifyListeners();
  }

  void setScenario(ScenarioType scenario) {
    activeScenario = scenario;
    _applyScenario();
    _calculate();
    notifyListeners();
  }

  void _applyScenario() {
    switch (activeScenario) {
      case ScenarioType.base:
        break;
      case ScenarioType.optimistic:
        inputs = inputs.copyWith(
          sellingPrice: inputs.sellingPrice * 1.1,
          monthlyCustomers: (inputs.monthlyCustomers * 1.2).toInt(),
        );
        break;
      case ScenarioType.pessimistic:
        inputs = inputs.copyWith(
          sellingPrice: inputs.sellingPrice * 0.9,
          monthlyCustomers: (inputs.monthlyCustomers * 0.8).toInt(),
        );
        break;
    }
  }

  void _calculate() {
    final double revenue = inputs.sellingPrice * inputs.monthlyCustomers;
    final double cogs = inputs.costPrice * inputs.monthlyCustomers;
    final double grossProfit = revenue - cogs;
    final double totalFixedCosts =
        inputs.rent + inputs.utilities + inputs.marketingSpend;
    final double netProfit = grossProfit - totalFixedCosts;
    final double profitMarginPercent =
        revenue > 0 ? (netProfit / revenue) * 100 : 0;
    final double contributionMarginPerCustomer =
        inputs.sellingPrice - inputs.costPrice;
    final double breakEvenCustomers = contributionMarginPerCustomer > 0
        ? totalFixedCosts / contributionMarginPerCustomer
        : 0;

    outputs = SimulatorOutputs(
      revenue: revenue,
      cogs: cogs,
      grossProfit: grossProfit,
      totalFixedCosts: totalFixedCosts,
      netProfit: netProfit,
      profitMarginPercent: profitMarginPercent,
      contributionMarginPerCustomer: contributionMarginPerCustomer,
      breakEvenCustomers: breakEvenCustomers,
    );

    _generateSuggestions();
  }

  void _generateSuggestions() {
    suggestions = [];
    if (outputs.profitMarginPercent < 10) {
      suggestions.add(ProfitSuggestion(
        id: '1',
        action: 'Increase Selling Price',
        impact: 'Boost profit margin by 5-10%',
        type: 'increase',
        priority: 'high',
      ));
    }
    if (inputs.costPrice > inputs.sellingPrice * 0.6) {
      suggestions.add(ProfitSuggestion(
        id: '2',
        action: 'Reduce Cost Price',
        impact: 'Find cheaper suppliers or optimize production',
        type: 'decrease',
        priority: 'high',
      ));
    }
    if (inputs.marketingSpend < outputs.revenue * 0.05) {
      suggestions.add(ProfitSuggestion(
        id: '3',
        action: 'Increase Marketing Spend',
        impact: 'Boost customer acquisition by 15-20%',
        type: 'increase',
        priority: 'medium',
      ));
    }
  }

  static String formatCurrency(double value) => '₹${value.toStringAsFixed(0)}';
  static String formatPercentage(double value) =>
      '${value.toStringAsFixed(1)}%';
  static String formatCustomers(double value) => '${value.toStringAsFixed(0)}';
}
