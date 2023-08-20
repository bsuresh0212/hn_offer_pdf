/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> generateInvoice() async {
  List<Product> data = [];
  data.add(const Product('Sakthi Kolumbu Milaigai thool', '50g', 28, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 50, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  data.add(const Product('Sakthi Coriander Power', '50g', 19, 16));
  final priceList = PriceList(list: data);

  return await priceList.buildPdf(PdfPageFormat.standard);
}

class PriceList {
  PriceList({required this.list});
  final List<Product> list;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();
    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.overpassRegular(),
          await PdfGoogleFonts.overpassBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        build: (context) => [
          gridViewPrepare(list)
        ],
      ),
    );
    // Return the PDF file content
    return doc.save();
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
        pageFormat: pageFormat,
        margin: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        theme: pw.ThemeData.withFont(
          base: base,
          bold: bold,
          italic: italic,
        ));
  }
}

pw.Widget gridViewPrepare(List<Product> list) {
  return pw.Container(
    width: double.infinity,
    child:  pw.Wrap(

        children: [
          ...list.map((c) => grid(c))
        ]
    )
  );



}

pw.Widget grid(Product e) {
  return
      pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all()
        ),
        height: 250,
        width: 180,
        child: pw.Expanded(
            child : pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('\u{20B9}',
                          style: pw.TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        pw.SizedBox(width: 3),
                        pw.Text(e.discount.toInt().toString(),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic,
                            fontSize: 40,
                          ),
                        ),
                        pw.SizedBox(width: 5),
                        pw.Text('Off',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ]
                  ),
                  pw.SizedBox(height: 25),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                    child: pw.RichText(
                        textAlign: pw.TextAlign.center,
                        text: pw.TextSpan(
                            text: '${e.name} ',
                            style: pw.TextStyle(
                              fontSize: 19,
                            ),
                            children: [
                              pw.TextSpan(
                                text: e.weight,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                            ]

                        )
                    ),
                  ),
                  pw.SizedBox(height: 50),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('MRP :-',
                            style: pw.TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          pw.Text('\u{20B9} ${e.mrp.toInt().toString()}',
                            style: pw.TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ]
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Our Price :-',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          pw.Text('\u{20B9} ${e.selling.toInt().toString()}',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ]
                    ),
                  ),

                ]
            )
        )

  );
}

class Product {
  const Product(
    this.name,
    this.weight,
    this.mrp,
    this.selling,
  );

  final String name;
  final String weight;
  final double mrp;
  final int selling;

  double get discount => mrp - selling;

  @override
  String toString() {
    return 'Product: {name: ${name}, weight: ${weight} , mrp: ${mrp}, selling: ${selling}, discount : ${discount}';
  }
}
