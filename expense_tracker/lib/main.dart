import 'package:flutter/material.dart';
import 'theme.dart';

void main() => runApp(const ExpenseApp());

class Expense {
  String name, category;
  double amount;
  DateTime date;

  Expense(this.name, this.amount, this.category, this.date);
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: AppTheme.theme,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final expenses = <Expense>[];
  final name = TextEditingController();
  final amount = TextEditingController();

  final categories = [
    'Food',
    'Transport',
    'School',
    'Shopping',
    'Bills',
    'Other'
  ];

  String category = 'Food';
  String filter = 'All';
  DateTime date = DateTime.now();

  void addExpense() {
    final value = double.tryParse(amount.text);

    if (name.text.isEmpty || value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid expense.'),
        ),
      );
      return;
    }

    setState(() {
      expenses.add(
        Expense(
          name.text,
          value,
          category,
          date,
        ),
      );

      name.clear();
      amount.clear();
      category = 'Food';
      date = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense added successfully!'),
      ),
    );
  }

  String formatDate(DateTime d) {
    return '${d.month}/${d.day}/${d.year}';
  }

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: Text('Remove "${expense.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        expenses.remove(expense);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense deleted.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    name.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = filter == 'All'
        ? expenses
        : expenses.where((e) => e.category == filter).toList();

    final total = list.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Total Expenses',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₱${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.green,
                      ),
                    ),
                    Text('${list.length} expense(s)'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Expense Name',
                prefixIcon: Icon(Icons.shopping_bag),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount (₱)',
                prefixIcon: Icon(Icons.payments),
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    category = v;
                  });
                }
              },
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${formatDate(date)}',
                  ),
                ),
                TextButton(
                  onPressed: selectDate,
                  child: const Text('Select Date'),
                ),
              ],
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: addExpense,
                icon: const Icon(Icons.add),
                label: const Text('Add Expense'),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: filter,
              decoration: const InputDecoration(
                labelText: 'Filter',
              ),
              items: ['All', ...categories]
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    filter = v;
                  });
                }
              },
            ),

            const SizedBox(height: 10),

            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('No expenses found.'),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final e = list[i];

                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppTheme.lightGreen,
                              child: Icon(
                                Icons.receipt_long,
                                color: AppTheme.dark,
                              ),
                            ),
                            title: Text(e.name),
                            subtitle: Text(
                              '${e.category} • ${formatDate(e.date)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₱${e.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.green,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => deleteExpense(e),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}