import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  DateTime? _selectedDate;

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _amountController.dispose();
  }

  void onCreate() {
    // Read values
    final title = _titleController.text.trim();
    final parsedAmount = double.tryParse(_amountController.text.trim());
    final date = _selectedDate ?? DateTime.now();

    if (title.isEmpty || parsedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and amount')),
      );
      return;
    }

    final newExpense = Expense(
      title: title,
      amount: parsedAmount,
      date: date,
      category: _selectedCategory,
    );

    // Return the expense to the parent and close modal
    Navigator.pop(context, newExpense);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void onCancel() {
    // Close the modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(label: Text("Title")),
              maxLength: 50,
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(label: Text("Amount")),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<Category>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: Category.values
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (c) {
                      if (c == null) return;
                      setState(() => _selectedCategory = c);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No date selected'
                            : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCreate,
                    child: const Text('Save Expense'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
