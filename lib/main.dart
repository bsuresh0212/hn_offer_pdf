import 'package:flutter/material.dart';
import 'package:hn_pdf/prepareList.dart';
import 'package:hn_pdf/print.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const printPage(),
    );
  }
}

class printPage extends StatefulWidget {
  const printPage({Key? key}) : super(key: key);

  @override
  State<printPage> createState() => _printPageState();
}

class _printPageState extends State<printPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print'),
      ),
 body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => generateInvoice()
      ),

      // body: PrepareList(),
    );
  }
}



