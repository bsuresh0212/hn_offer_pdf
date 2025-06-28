import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hn_pdf/print.dart';
import 'package:hn_pdf/printPage.dart';
import 'package:hn_pdf/services/storage.dart';
import 'package:hn_pdf/widgets/circular.dart';

import 'models/priceList.dart';
import 'models/storageItem.dart';

class PrepareList extends StatefulWidget {
  const PrepareList({Key? key}) : super(key: key);

  @override
  State<PrepareList> createState() => _PrepareListState();
}

class _PrepareListState extends State<PrepareList> {
  List<PriceListData> printingList = [];
  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;
  bool loader = true;
  final StorageService _storeService = StorageService();

  @override
  void initState() {
    getPriceList();
    super.initState();
  }

  getPriceList() async {
    final savedList = await _storeService.readSecureData('printingList');
    if (savedList != null && savedList.isNotEmpty) {
    final res = PriceListDataFromJson(json.decode(savedList));
      if (res.isNotEmpty) {
        setState(() {
          printingList = res;
          loader  = false;
        });
      } else {
        setState(() {
          printingList = [];
          loader  = false;
        });
      }
    } else {
      setState(() {
        printingList = [];
        loader  = false;
      });
    }
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = true;
      });
      // Open Detail Page
    }
  }

  void printPreview() {
      List<PriceListData> finalPList = [];
      for(final item in selectedFlag.entries) {
        if(item.value) {
          finalPList.add(printingList[item.key]);
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => printPage(printingList: finalPList)),
      );
  }

  updateItem(PriceListData data, int index) {
    bottomSheet(context, data).then((value) {
      setState(() {
        if(value != null) {
          printingList[index] = value;
          _storeService
              .writeSecureData(StorageItem('printingList', jsonEncode(PriceListDataToJson(printingList))));
        }

      });
    });
  }

  Widget _buildSelectIcon(bool isSelected, int index) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text('${index + 1}'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printing List'),
        actions: [
          IconButton(
              onPressed: !isSelectionMode ? null : printPreview,
              icon: const Icon(Icons.print))
        ],
      ),
      body: loader ? const Circular() : printingList.isEmpty
          ? const Center(
              child: Text('No Printed list'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: printingList.length,
              itemBuilder: (BuildContext context, int index) {
                var actualObj = printingList[index];
                Product data = Product(actualObj.name, actualObj.weight,
                    actualObj.mrp, actualObj.selling);
                selectedFlag[index] = selectedFlag[index] ?? false;
                bool? isSelected = selectedFlag[index];
                return SizedBox(
                    height: 75,
                    child: ListTile(
                      title: Text('${data.name} (${data.weight})'),
                      onTap: () => onTap(isSelected, index),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('MRP:'),
                              Text('\u{20B9}${data.mrp}', style: const TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Our Price:'),
                              Text('\u{20B9}${data.selling}', style: const TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(onPressed: () => updateItem(actualObj, index), icon: const Icon(Icons.update)),
                      leading: _buildSelectIcon(isSelected!, index),
                    ));
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          bottomSheet(context, PriceListData(name: '', weight: '', mrp: 0, selling: 0)).then((value) {
            setState(() {
              if(value != null) {
                printingList.add(value);
                _storeService
                    .writeSecureData(StorageItem('printingList', jsonEncode(PriceListDataToJson(printingList))));
              }

            });
          })
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<dynamic> bottomSheet(context, PriceListData priceListData) {
  final itemController = TextEditingController();
  final itemWtController = TextEditingController();
  final itemMRPController = TextEditingController();
  final itemSellingController = TextEditingController();


  itemController.text = priceListData.name;
  itemWtController.text = priceListData.weight;
  itemMRPController.text = priceListData.mrp == 0 ?  '' : priceListData.mrp.toString();
  itemSellingController.text = priceListData.selling == 0 ? '' : priceListData.selling.toString();

  errDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Field are mandatory'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Ok'),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  submit() {
    if (itemController.text.trim().isEmpty ||
        itemWtController.text.trim().isEmpty ||
        itemMRPController.text.trim().isEmpty ||
        itemSellingController.text.trim().isEmpty) {
      errDialog();
    } else {
      try {
        String inputSentence = itemController.text.trim();
        List<String> words = inputSentence.split(' ');
        List<String> capitalizedWords = [...words.map((s) => s[0].toUpperCase() + s.substring(1))];
        inputSentence = capitalizedWords.join(' ');
        final PriceListData newProduct = PriceListData(name: inputSentence, weight: itemWtController.text, mrp: int.parse(itemMRPController.text), selling: int.parse(itemSellingController.text));
        Navigator.pop(context, newProduct);
      } catch(e) {
        print(itemController.text);
        print(e);
      }

    }
  }

  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return (Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 47, right: 3, top: 14, bottom: 14),
                      hintText: 'Item Name',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF4A90E2))),
                      prefixIcon: Icon(Icons.add_shopping_cart),
                      // fillColor: const Color(0xFFF4F3F8)
                    ),
                    controller: itemController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 47, right: 3, top: 14, bottom: 14),
                      hintText: 'Item Weight',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF4A90E2))),
                      prefixIcon: Icon(Icons.line_weight),
                      // fillColor: const Color(0xFFF4F3F8)
                    ),
                    controller: itemWtController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.only(
                          left: 47, right: 3, top: 14, bottom: 14),
                      hintText: 'M.R.P',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF4A90E2))),
                      prefixIcon: Icon(Icons.currency_rupee),
                      // fillColor: const Color(0xFFF4F3F8)
                    ),
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    controller: itemMRPController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.only(
                          left: 47, right: 3, top: 14, bottom: 14),
                      hintText: 'Selling Price',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF4A90E2))),
                      prefixIcon: Icon(Icons.currency_rupee),
                      // fillColor: const Color(0xFFF4F3F8)
                    ),
                    controller: itemSellingController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    textInputAction: TextInputAction.next,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 2),
                    onPressed: submit,
                    child: const Text('Add'),
                  )
                ],
              ),
            )));
      });
}
