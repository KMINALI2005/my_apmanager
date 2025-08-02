import 'package:flutter/material.dart';

// تعريف فئات الديون
enum DebtCategory {
  individual, // مفرد
  wholesale,  // جملة
  delegate    // مندوبين
}

// دالة لترجمة الفئة إلى نص عربي
String categoryToString(DebtCategory category) {
  switch (category) {
    case DebtCategory.individual:
      return 'دين مفرد';
    case DebtCategory.wholesale:
      return 'دين جملة';
    case DebtCategory.delegate:
      return 'دين مندوبين';
  }
}

class Debt {
  String id;
  String name;
  double amount;
  DebtCategory category;
  DateTime date;
  bool isPaid;

  Debt({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.isPaid = false,
  });

  // لتحويل بيانات الدين إلى JSON لحفظها في ملف
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'category': category.index, // نحفظ الـ index الخاص بالفئة
        'date': date.toIso8601String(),
        'isPaid': isPaid,
      };

  // لإنشاء كائن دين من بيانات JSON
  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
        id: json['id'],
        name: json['name'],
        amount: json['amount'],
        category: DebtCategory.values[json['category']], // نسترجع الفئة من الـ index
        date: DateTime.parse(json['date']),
        isPaid: json['isPaid'],
      );
}
