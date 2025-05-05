import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.all(Colors.green),
          fillColor: WidgetStateProperty.all(Colors.black),
        ),
      ),
      home: ChecklistPage(),
    );
  }
}

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  ChecklistPageState createState() => ChecklistPageState();
}

class ChecklistPageState extends State<ChecklistPage> {
  final List<String> _items = [];
  final TextEditingController _controller = TextEditingController();
  final Map<String, List<Map<String, dynamic>>> _listsData = {};

  void _addItem(String title) {
    setState(() {
      _items.add(title);
      _listsData[title] = _listsData[title] ?? [];
    });
    _controller.clear();
  }

  void _removeItem(int index) {
    setState(() {
      _listsData.remove(_items[index]);
      _items.removeAt(index);
    });
  }

  void _navigateToNewList(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewListPage(
          title: title,
          listItems: _listsData[title]!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seu Checklist'),
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
                      labelText: 'Adicionar nova lista',
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
                  child: Text('Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
                  onTap: () {
                    _navigateToNewList(context, _items[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewListPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> listItems;

  const NewListPage({
    super.key,
    required this.title,
    required this.listItems,
  });

  @override
  NewListPageState createState() => NewListPageState();
}

class NewListPageState extends State<NewListPage> {
  late List<Map<String, dynamic>> _newListItems;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newListItems = widget.listItems;
  }

  void _addNewItem(String item) {
    setState(() {
      _newListItems.add({'title': item, 'checked': false});
    });
    _controller.clear();
  }

  void _removeNewItem(int index) {
    setState(() {
      _newListItems.removeAt(index);
    });
  }

  void _toggleCheckbox(int index) {
    setState(() {
      _newListItems[index]['checked'] = !_newListItems[index]['checked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                      labelText: 'Item do ${widget.title}',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addNewItem(_controller.text);
                    }
                  },
                  child: Text('Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _newListItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _newListItems[index]['checked'],
                    onChanged: (value) {
                      _toggleCheckbox(index);
                    },
                  ),
                  title: Text(
                    _newListItems[index]['title'],
                    style: TextStyle(
                      decoration: _newListItems[index]['checked']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeNewItem(index),
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