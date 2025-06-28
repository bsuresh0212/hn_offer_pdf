import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:hn_pdf/print.dart';

import 'models/priceList.dart';

class printPage extends StatefulWidget {
  const printPage({Key? key, required this.printingList}) : super(key: key);
  final List<PriceListData> printingList;

  @override
  State<printPage> createState() => _printPageState();
}

class _printPageState extends State<printPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print'),
      ),
      body: PdfPreview(
          maxPageWidth: 700,
          build: (format) => generateInvoice(widget.printingList)
      ),

      // body: PrepareList(),
    );
  }
}