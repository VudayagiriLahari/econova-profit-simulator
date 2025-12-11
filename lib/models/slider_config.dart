class SliderConfig {
  final String key;
  final double min;
  final double max;
  final double step;
  final String label;
  final String prefix;
  final String suffix;

  const SliderConfig({
    required this.key,
    required this.min,
    required this.max,
    required this.step,
    required this.label,
    this.prefix = '',
    this.suffix = '',
  });
}

const sliderConfigs = [
  SliderConfig(
    key: 'sellingPrice',
    min: 10,
    max: 10000,
    step: 10,
    label: 'Selling Price / Customer',
    prefix: '₹',
  ),
  SliderConfig(
    key: 'costPrice',
    min: 1,
    max: 5000,
    step: 5,
    label: 'Cost Price / Customer',
    prefix: '₹',
  ),
  SliderConfig(
    key: 'monthlyCustomers',
    min: 1,
    max: 10000,
    step: 10,
    label: 'Monthly Customers',
    suffix: ' customers',
  ),
  SliderConfig(
    key: 'rent',
    min: 0,
    max: 100000,
    step: 500,
    label: 'Monthly Rent',
    prefix: '₹',
  ),
  SliderConfig(
    key: 'utilities',
    min: 0,
    max: 50000,
    step: 500,
    label: 'Monthly Utilities',
    prefix: '₹',
  ),
  SliderConfig(
    key: 'marketingSpend',
    min: 0,
    max: 50000,
    step: 500,
    label: 'Marketing Spend',
    prefix: '₹',
  ),
];
