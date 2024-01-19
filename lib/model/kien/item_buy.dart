import 'package:flutter/material.dart';
import '../../data/kien/payment_Reader.dart';

class item_buy extends StatefulWidget {
  final Payments payment; 
  const item_buy({super.key, required this.payment});

  @override
  State<item_buy> createState() => _item_buyState();
}

class _item_buyState extends State<item_buy> {
  Color myLightGrayColor = const Color.fromRGBO(243, 243, 243, 1.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      
      child: Row(
        children: [
        Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 1.2,
        height: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          color: myLightGrayColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
      
        ),
        child: Row(
          children: [
          Image.network(
            widget.payment.image,
              width: MediaQuery.of(context).size.width / 6,
              height: MediaQuery.of(context).size.height /6,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                Text(widget.payment.name,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                const SizedBox(height: 5,),
                Text("Size: ${widget.payment.size}",style: const TextStyle(fontSize: 16,)),
                const SizedBox(height: 5,),
                
                Text(widget.payment.price,style: const TextStyle(fontSize: 16,),),
                const SizedBox(height: 5,),
                Text("số lượng: ${widget.payment.quality}",style: const TextStyle(fontSize: 16,)),
                
              ],
            )
        ]),
     
    )
        ],
      ));
  }
}