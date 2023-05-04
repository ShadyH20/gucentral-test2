import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gucentral/utils/constants.dart';
import 'package:gucentral/utils/weight.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utils/weight_data.dart';
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
  bool checkboxState = false;
  String text = "";
  String weight = "";
  String best = "";
  String from = "";
  final textController = TextEditingController();
  final weightController = TextEditingController();
  final bestController = TextEditingController();
  final fromController = TextEditingController();

  void setText(String text) {
    setState(() {
      this.text = text;
    });
  }

  void setWeight(String weight) {
    setState(() {
      this.weight = weight;
    });
  }

  void setBest(String best) {
    setState(() {
      this.best = best;
    });
  }

  void setFrom(String from) {
    setState(() {
      this.from = from;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: 160,
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(top: 1, bottom: 1),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Title',
                            style: kSubTitleStyle.copyWith(
                              color: const Color(0xFF9F9F9F),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 130,
                            height: 25,
                            child: Material(
                              child: Form(
                                child: WeightTextField(
                                  validatorText: 'Please enter title',
                                  hintText: 'e.g. Assignments',
                                  onChangeFunction: setText,
                                  textFieldController: textController,
                                  maxLength: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(width: 10),
                      Row(
                        children: [
                          Text(
                            'Weight',
                            style: kSubTitleStyle.copyWith(
                              color: const Color(0xFF9F9F9F),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: Material(
                              child: Form(
                                child: WeightTextField(
                                  validatorText: 'Please enter weight',
                                  hintText: '',
                                  onChangeFunction: setWeight,
                                  textFieldController: weightController,
                                  keyboardType: TextInputType.number,
                                  textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '%',
                            style: kSubTitleStyle.copyWith(
                              color: const Color(0xFF9F9F9F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // const SizedBox(width: 10),
                      Row(
                        // Best & From
                        children: [
                          Row(
                            children: [
                              Text(
                                'Best',
                                style: kSubTitleStyle.copyWith(
                                  color: checkboxState
                                      ? const Color(0xFF9F9F9F)
                                      : const Color(0xFF9F9F9F)
                                          .withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: Material(
                                  child: Form(
                                    child: WeightTextField(
                                      validatorText: 'Please enter best',
                                      hintText: '',
                                      onChangeFunction: setBest,
                                      textFieldController: bestController,
                                      keyboardType: TextInputType.number,
                                      enabled: checkboxState,
                                      textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Text(
                                'From',
                                style: kSubTitleStyle.copyWith(
                                  color: checkboxState
                                      ? const Color(0xFF9F9F9F)
                                      : const Color(0xFF9F9F9F)
                                          .withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: Material(
                                  child: Form(
                                    child: WeightTextField(
                                      validatorText: 'Please enter from',
                                      hintText: '',
                                      onChangeFunction: setFrom,
                                      textFieldController: fromController,
                                      keyboardType: TextInputType.number,
                                      enabled: checkboxState,
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.85,
                            child: Container(
                              height: 18,
                              width: 18,
                              color: Colors.red,
                              child: Material(
                                child: Checkbox(
                                  value: checkboxState,
                                  onChanged: (value) {
                                    setState(() {
                                      checkboxState = value!;
                                      print('checkkkeeddd');
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  activeColor: MyColors.primary,
                                  side: BorderSide(
                                      color:
                                          MyColors.secondary.withOpacity(0.6)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Best-From',
                            style: kSubTitleStyle.copyWith(
                              color: const Color(0xFF9F9F9F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 28,
              width: 45,
              child: TextButton(
                onPressed: () {
                  if (best.isNotEmpty && from.isNotEmpty) {
                    Provider.of<WeightData>(context, listen: false)
                        .addToWeights(Weight(
                            text: text, weight: weight, best: [best, from]));
                  } else {
                    Provider.of<WeightData>(context, listen: false)
                        .addToWeights(Weight(text: text, weight: weight));
                  }

                  textController.clear();
                  text = '';

                  weightController.clear();
                  weight = '';

                  bestController.clear();
                  best = '';

                  fromController.clear();
                  from = '';

                  setState(() {
                    checkboxState = false;
                  });

                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: TextButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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

class WeightTextField extends StatefulWidget {
  WeightTextField({
    super.key,
    required this.validatorText,
    required this.hintText,
    required this.onChangeFunction,
    required this.textFieldController,
    this.maxLength = 2,
    this.textStyle = const TextStyle(fontSize: 12),
    this.enabled = true,
    this.keyboardType,
  });

  final String validatorText;
  final String hintText;
  final TextStyle textStyle;
  final bool enabled;
  final int maxLength;
  final TextInputType? keyboardType;
  final dynamic textFieldController;
  Function onChangeFunction;

  @override
  State<WeightTextField> createState() => _WeightTextFieldState();
}

class _WeightTextFieldState extends State<WeightTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: widget.textFieldController,
      // maxLength: 2,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      keyboardType: widget.keyboardType,
      autofillHints: const [AutofillHints.username],
      enabled: widget.enabled,
      autocorrect: false,
      onChanged: (value) {
        widget.onChangeFunction(value);
      },
      validator: (value) =>
          value != null && value.isEmpty ? widget.validatorText : null,
      style: widget.textStyle.copyWith(
        color: widget.enabled
            ? const Color(0xFF9F9F9F)
            : const Color(0xFF9F9F9F).withOpacity(0.2),
      ),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontFamily: "Outfit",
            fontWeight: FontWeight.w500,
            color: MyColors.secondary.withOpacity(.15)),
        enabledBorder: !MyApp.isDarkMode.value
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.5),
                borderSide: BorderSide(color: Colors.grey[700]!, width: 0.7))
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.5),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5),
            borderSide:
                const BorderSide(width: 2, color: MyColors.primaryVariant)),
        contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
      ),
    );
  }
}
