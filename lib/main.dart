import 'package:flutter/material.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false, // Removed the debug banner
            home: ChecklistPage(),
        );
    }
}

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

    @override
    _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
    final List<Map<String, dynamic>> _items = [];
    final TextEditingController _controller = TextEditingController();

    void _addItem(String title) {
        setState(() {
            _items.add({'title': title, 'checked': false});
        });
        _controller.clear();
    }

    void _removeItem(int index) {
        setState(() {
            _items.removeAt(index);
        });
    }

    void _toggleCheckbox(int index) {
        setState(() {
            _items[index]['checked'] = !_items[index]['checked'];
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Lista do mercado'), // Changed the title
            ),
            body: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            children: [
                                Expanded(
                                    child: TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                            labelText: 'Add Item',
                                            border: OutlineInputBorder(),
                                        ),
                                    ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                    onPressed: () {
                                        if (_controller.text.isNotEmpty) {
                                            _addItem(_controller.text);
                                        }
                                    },
                                    child: Text('Add'),
                                ),
                            ],
                        ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                                return ListTile(
                                    leading: Checkbox(
                                        value: _items[index]['checked'],
                                        onChanged: (value) {
                                            _toggleCheckbox(index);
                                        },
                                    ),
                                    title: Text(
                                        _items[index]['title'],
                                        style: TextStyle(
                                            decoration: _items[index]['checked']
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                        ),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => _removeItem(index),
                                    ),
                                );
                            },
                        ),
                    ),
                ],
            ),
        );
    }
}