import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/debt_model.dart';
import '../providers/debt_provider.dart';
import 'add_edit_debt_dialog.dart';

class DebtListItem extends StatelessWidget {
  final Debt debt;

  const DebtListItem({Key? key, required this.debt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context, listen: false);
    final isPaid = debt.isPaid;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isPaid ? Colors.green.withOpacity(0.5) : theme.colorScheme.outline.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => showAddEditDebtDialog(context, debt: debt),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      debt.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isPaid ? TextDecoration.lineThrough : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${debt.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      decoration: isPaid ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(categoryToString(debt.category), style: theme.textTheme.bodySmall),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(debt.date),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: Icon(isPaid ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isPaid ? Colors.green : null),
                    label: Text(isPaid ? 'تم التسديد' : 'شطب الدين'),
                    onPressed: () => debtProvider.togglePaidStatus(debt.id),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: const Text('هل أنت متأكد من رغبتك في حذف هذا الدين؟'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('إلغاء')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('حذف')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        debtProvider.deleteDebt(debt.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
