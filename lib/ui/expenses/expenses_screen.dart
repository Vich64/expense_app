import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'expense_form.dart';
import 'expense_item.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() {
    return _ExpensesScreenState();
  }
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  Future<void> onAddClicked(BuildContext context) async {
    final created = await showModalBottomSheet<Expense>(
      isScrollControlled: true,
      context: context,
      builder: (c) => const ExpenseForm(),
    );
    if (created != null) {
      setState(() {
        _expenses.add(created);
      });
    }
  }

  void _removeExpense(int index) {
    final removed = _expenses[index];
    setState(() {
      _expenses.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => {onAddClicked(context)},
            icon: Icon(Icons.add),
          ),
        ],
        backgroundColor: Colors.blue[700],
        title: const Text('Ronan-The-Best Expenses App'),
      ),
      body: _expenses.isEmpty
          ? const Center(child: Text('No expenses found. Start adding some!'))
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(_expenses[index].id),
                onDismissed: (_) => _removeExpense(index),
                child: ExpenseItem(expense: _expenses[index]),
              ),
            ),
    );
  }
}
