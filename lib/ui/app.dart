import 'package:flutter/material.dart';
import 'expenses/expenses.dart';
import 'expenses/expenses_form.dart';

class App extends StatelessWidget {
  const App({super.key});

  void onAddClicked(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (c) => ExpenseForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text('Ronan-The-Best Expenses App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              onAddClicked(context);
            },
          ),
        ],
      ),
      body: ExpensesView(),
    );
  }
}
