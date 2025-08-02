import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/debt_model.dart';
import '../providers/debt_provider.dart';

void showAddEditDebtDialog(BuildContext context, {Debt? debt}) {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: debt?.name ?? '');
  final _amountController = TextEditingController(text: debt?.amount.toString() ?? '');
  DebtCategory _selectedCategory = debt?.category ?? DebtCategory.individual;
  DateTime _selectedDate = debt?.date ?? DateTime.now();
  bool isEditing = debt != null;

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(isEditing ? 'تعديل دين' : 'إضافة دين جديد'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'اسم المدين'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'المبلغ'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || double.tryParse(value) == null) {
                          return 'الرجاء إدخال مبلغ صحيح';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<DebtCategory>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'الفئة'),
                      items: DebtCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(categoryToString(category)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text('التاريخ: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}')),
                        TextButton(
                          child: const Text('تغيير'),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: Text(isEditing ? 'حفظ التعديلات' : 'إضافة'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newDebt = Debt(
                  id: isEditing ? debt.id : DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(999).toString(),
                  name: _nameController.text,
                  amount: double.parse(_amountController.text),
                  category: _selectedCategory,
                  date: _selectedDate,
                  isPaid: isEditing ? debt.isPaid : false,
                );
                if (isEditing) {
                  Provider.of<DebtProvider>(context, listen: false).updateDebt(newDebt);
                } else {
                  Provider.of<DebtProvider>(context, listen: false).addDebt(newDebt);
                }
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
