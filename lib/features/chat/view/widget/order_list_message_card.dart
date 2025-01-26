import 'package:flutter/material.dart';

class OrderMessageCard extends StatefulWidget {
  const OrderMessageCard({
    super.key,
    required this.isSender,
    required this.timestamp,
  });

  final bool isSender;
  final DateTime timestamp;

  @override
  OrderMessageCardState createState() => OrderMessageCardState();
}

class OrderMessageCardState extends State<OrderMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // Remove borders
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 4),
            color: Colors.black.withOpacity(0.06),
          ),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: const Text(
              'Transcript',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            initiallyExpanded: false,
            onExpansionChanged: (value) {},
            children: const [
              Text(
                'Wanted to place an order for a few items. Here’s what I need: First, 50 units of the Classic Leather Wallet in black. Next, 30 units of the Summer Floral Dress.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 4),
            color: Colors.black.withOpacity(0.06),
          ),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            childrenPadding: const EdgeInsets.all(0),
            title: const Text(
              'Order List',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            initiallyExpanded: false,
            onExpansionChanged: (value) {},
            children: [
              _productList(productName: "Milk", productQuanity: "5 packets"),
              const SizedBox(height: 10),
              _productList(productName: "Butter", productQuanity: "5 kg"),
              const SizedBox(height: 10),
              _productList(productName: "Butter", productQuanity: "5 kg"),
            ],
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            color: Colors.black.withOpacity(0.06),
          ),
          const Row(
            children: [
              Icon(
                Icons.receipt_long,
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Order no: 15544",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              )
            ],
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 4, bottom: 6),
            color: Colors.black.withOpacity(0.06),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Approvded by DP on 02.30pm, 15/07/2024',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              if (widget.isSender) ...[
                Text(
                  "${widget.timestamp.hour}:${widget.timestamp.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.done_all_outlined,
                  size: 12,
                  color: Colors.grey,
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Container _productList({
    required String productName,
    required String productQuanity,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 0.5,
            spreadRadius: 0.1,
            offset: const Offset(
              0,
              0.5,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            productName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              productQuanity,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '01:55',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.edit,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
