import 'package:flutter/material.dart';
import 'package:gucentral/utils/constants.dart';
import 'package:provider/provider.dart';
import '../utils/weight.dart';
import '../utils/weight_data.dart';
import 'MyColors.dart';

class WeightCard extends StatelessWidget {
  const WeightCard({
    super.key,
    required this.weightData,
    this.addRemove = false,
    this.addReorder = false,
  });

  final Weight weightData;
  final bool addRemove;
  final bool addReorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          addReorder
              ? Icon(
                  Icons.menu,
                  color: MyColors.secondary.withOpacity(0.3),
                )
              : Container(),
          addReorder ? const SizedBox(width: 10) : Container(),
          Container(
            constraints: addRemove ? const BoxConstraints(maxWidth: 120) : null,
            // color: Colors.red,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                weightData.text,
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: kSubTitleStyle,
              ),
            ),
          ),
          Text(
            weightData.best[0].isEmpty || weightData.best[1].isEmpty
                ? ''
                : ' | Best ${weightData.best[0]} from ${weightData.best[1]}',
            style: kSubTitleStyle,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              color: const Color.fromARGB(30, 0, 0, 0),
              height: 1,
              // width: 30,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${weightData.weight}%',
            style: const TextStyle(
              fontFamily: "Outfit",
              fontWeight: FontWeight.w700,
              fontSize: 15,
              decoration: TextDecoration.none,
              color: MyColors.secondary,
            ),
          ),
          const SizedBox(width: 10),
          addRemove
              ? GestureDetector(
                  onTap: () {
                    print('deleeeeete weight');
                    Provider.of<WeightData>(context, listen: false)
                        .removeWeight(weightData);
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: MyColors.primary,
                    size: 23,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
