import 'package:flutter/material.dart';
// If the package import causes "Target of URI doesn't exist" use the relative import below.
// import 'package:econova/logic/profit_calculator.dart';
import '../logic/profit_calculator.dart';

// ...existing code...
class SuggestionTile extends StatelessWidget {
  final ProfitSuggestion suggestion;
  const SuggestionTile({super.key, required this.suggestion});

  Color _getColor() {
    final String priority = (suggestion.priority ?? '').toLowerCase();
    switch (priority) {
      case 'high':
        return Colors.orange.shade700;
      case 'medium':
        return Colors.amber.shade700;
      default:
        return Colors.grey.shade500;
    }
  }

  IconData _getIcon() {
    final String type = (suggestion.type ?? '').toLowerCase();
    switch (type) {
      case 'increase':
        return Icons.trending_up;
      case 'decrease':
        return Icons.trending_down;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color)),
        title: Text(suggestion.action ?? 'No action',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(suggestion.impact ?? ''),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.grey.shade500),
      ),
    );
  }
}
// ...existing code...