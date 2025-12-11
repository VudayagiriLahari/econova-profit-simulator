class SimulatorInputs {
  double sellingPrice;
  double costPrice;
  int monthlyCustomers;
  double rent;
  double utilities;
  double marketingSpend;

  SimulatorInputs({
    required this.sellingPrice,
    required this.costPrice,
    required this.monthlyCustomers,
    required this.rent,
    required this.utilities,
    required this.marketingSpend,
  });

  SimulatorInputs copyWith({
    double? sellingPrice,
    double? costPrice,
    int? monthlyCustomers,
    double? rent,
    double? utilities,
    double? marketingSpend,
  }) {
    return SimulatorInputs(
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      monthlyCustomers: monthlyCustomers ?? this.monthlyCustomers,
      rent: rent ?? this.rent,
      utilities: utilities ?? this.utilities,
      marketingSpend: marketingSpend ?? this.marketingSpend,
    );
  }
}

final defaultInputs = SimulatorInputs(
  sellingPrice: 500,
  costPrice: 200,
  monthlyCustomers: 100,
  rent: 15000,
  utilities: 5000,
  marketingSpend: 5000,
);
