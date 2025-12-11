class SimulatorOutputs {
  final double revenue;
  final double cogs;
  final double grossProfit;
  final double totalFixedCosts;
  final double netProfit;
  final double profitMarginPercent;
  final double contributionMarginPerCustomer;
  final double breakEvenCustomers;

  SimulatorOutputs({
    required this.revenue,
    required this.cogs,
    required this.grossProfit,
    required this.totalFixedCosts,
    required this.netProfit,
    required this.profitMarginPercent,
    required this.contributionMarginPerCustomer,
    required this.breakEvenCustomers,
  });
}
