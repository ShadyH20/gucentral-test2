import 'package:flutter/material.dart';
import 'MyColors.dart';

class AddWeightCard extends StatefulWidget {
  const AddWeightCard({
    super.key,
    required this.onCancel,
  });

  final Function onCancel;

  @override
  State<AddWeightCard> createState() => _AddWeightCardState();
}

class _AddWeightCardState extends State<AddWeightCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: 100,
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(top: 1, bottom: 1),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onTap: () {
                      widget.onCancel(false);
                      print('deleted');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
