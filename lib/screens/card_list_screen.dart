import 'package:flutter/material.dart';
import '../main.dart';

class Item {
  final String title;
  final String description;

  Item({required this.title, required this.description});
}

class CardListScreen extends StatefulWidget {
  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  List<Item> items = List.generate(
    5,
        (index) => Item(
      title: 'Item ${index + 1}',
      description: 'Description for item ${index + 1}',
    ),
  );

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card & List", style: AppTextStyles.header)),
      body: Padding(
        padding: AppDimens.padding,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(items[index].title),
                subtitle: Text(items[index].description),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
