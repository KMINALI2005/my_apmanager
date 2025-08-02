import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/debt_model.dart';
import '../providers/debt_provider.dart';
import '../services/export_service.dart';
import '../widgets/add_edit_debt_dialog.dart';
import '../widgets/debt_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  DebtCategory? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدير الديون'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              final debts = _getFilteredAndSearchedDebts();
              if (value == 'pdf') {
                await ExportService.exportToPdf(debts, 'تقرير الديون');
              } else if (value == 'csv') {
                await ExportService.exportToCsv(debts, 'تقرير الديون');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'pdf', child: Text('تصدير إلى PDF')),
              const PopupMenuItem(value: 'csv', child: Text('تصدير إلى Excel')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBarAndFilter(),
          Expanded(child: _buildDebtList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddEditDebtDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('دين جديد'),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<DebtProvider>(
      builder: (context, debtProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('إجمالي الديون', style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        '${debtProvider.totalUnpaidDebt.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                   Column(
                    children: [
                      Text('تم تسديده', style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        '${debtProvider.totalPaidDebt.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBarAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              labelText: 'بحث بالاسم، المبلغ أو التاريخ...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('الكل'),
                  selected: _selectedFilter == null,
                  onSelected: (selected) => setState(() => _selectedFilter = null),
                ),
                ...DebtCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(categoryToString(category)),
                      selected: _selectedFilter == category,
                      onSelected: (selected) => setState(() => _selectedFilter = selected ? category : null),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Debt> _getFilteredAndSearchedDebts() {
    final debtProvider = Provider.of<DebtProvider>(context, listen: false);
    return debtProvider.debts.where((debt) {
      final matchesFilter = _selectedFilter == null || debt.category == _selectedFilter;
      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          debt.name.toLowerCase().contains(query) ||
          debt.amount.toString().contains(query) ||
          DateFormat('yyyy-MM-dd').format(debt.date).contains(query);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Widget _buildDebtList() {
    return Consumer<DebtProvider>(
      builder: (context, debtProvider, child) {
        if (debtProvider.debts.isEmpty) {
          return const Center(child: Text('لا توجد ديون مسجلة. قم بإضافة دين جديد.'));
        }

        final displayedDebts = _getFilteredAndSearchedDebts();

        if (displayedDebts.isEmpty) {
          return const Center(child: Text('لا توجد نتائج مطابقة للبحث أو التصفية.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // لإعطاء مساحة للـ FAB
          itemCount: displayedDebts.length,
          itemBuilder: (context, index) {
            return DebtListItem(debt: displayedDebts[index]);
          },
        );
      },
    );
  }
}
