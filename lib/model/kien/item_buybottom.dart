// BuyBottom.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_application/data/kien/address_Reader.dart';

class BuyBottom extends StatelessWidget {
  final double onTotalAmountChanged;
  final double VoucherSale;
  final Address? address; // Change the type to Address?

  const BuyBottom({Key? key, required this.onTotalAmountChanged, required this.VoucherSale, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFF8E1C68);

    return Container(
      height: 60,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink.shade100),
                minimumSize: MaterialStateProperty.all(const Size(360, 50)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async {
                if (address != null && address!.fullname.isNotEmpty) {
                  await createAndAddInvoice();
                } else {
                  showAddressDialog(context);
                }
              },
              child: Text(
                'Thanh toán',
                style: TextStyle(color: myColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lỗi"),
          content: const Text("Vui lòng chọn địa chỉ trước khi thanh toán."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> createAndAddInvoice() async {
    QuerySnapshot paymentsSnapshot = await FirebaseFirestore.instance.collection('payments').get();
    List<Map<String, dynamic>> items = paymentsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    await FirebaseFirestore.instance.collection('invoices').add({
      'confirm_state': false,
      'cancel_state': false,
      'bill_state': true,
      'name': address?.fullname,
      'phone':address?.phone.toString(),
      'address':address?.addressText,
      'items': items,
      'totalAmount': VoucherSale == 0 ? onTotalAmountChanged : onTotalAmountChanged - (onTotalAmountChanged * VoucherSale) / 100,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}