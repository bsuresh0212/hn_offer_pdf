import 'package:flutter/material.dart';

class PrepareList extends StatefulWidget {
  const PrepareList({Key? key}) : super(key: key);

  @override
  State<PrepareList> createState() => _PrepareListState();
}

class _PrepareListState extends State<PrepareList> {
  List printingList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printing List'),
      ),
      body: printingList.isEmpty
          ? const Center(
              child: Text('No Printed list'),
            )
          : Center(child: Text('Hello')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {bottomSheet(context)},
        child: Icon(Icons.add),
      ),
    );
  }
}

Future bottomSheet(context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return (const Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
            ),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text('Copy Link'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            ),
          ],
        ));
      });
}
