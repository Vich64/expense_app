import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key, required this.onExpenseCreated});

  final Function(Expense) onExpenseCreated;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleControler = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _titleControler.dispose();
    _valueController.dispose();
  }

  void onCreate() {
    // 1- Get the values from inputs
    String title = _titleControler.text;
    double amount = double.parse(_valueController.text);

    // 2- Create the expense
    Expense expense = Expense(
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: Category.food,
    );

    // 3- Call the callback to add expense to parent widget
    widget.onExpenseCreated(expense);
  }

  void onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleControler,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: _valueController,
            decoration: InputDecoration(
              prefix: Text('\$ '),
              label: Text("Amount"),
            ),
            maxLength: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => onCancel(context),
                child: Text("Cancel"),
              ),
              SizedBox(width: 20),
              ElevatedButton(onPressed: onCreate, child: Text("Create")),
            ],
          ),
        ],
      ),
    );
  }
}
