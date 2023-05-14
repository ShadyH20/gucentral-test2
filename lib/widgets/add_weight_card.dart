import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gucentral/utils/constants.dart';
import 'package:gucentral/utils/weight.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utils/SharedPrefs.dart';
import '../utils/weight_data.dart';
// import 'MyColors.dart';

class AddWeightCard extends StatefulWidget {
  const AddWeightCard({
    super.key,
    required this.showFunction,
    required this.showError,
  });

  final Function showFunction;
  final Function showError;

  @override
  State<AddWeightCard> createState() => _AddWeightCardState();
}

class _AddWeightCardState extends State<AddWeightCard> {
  bool checkboxState = false;
  String text = "";
  String weight = "";
  String best = "";
  String from = "";
  bool textValid = true;
  bool weightValid = true;
  bool bestValid = true;
  bool fromValid = true;
  final textController = TextEditingController();
  final weightController = TextEditingController();
  final bestController = TextEditingController();
  final fromController = TextEditingController();

  void setText(String text) {
    setState(() {
      this.text = text;
      textValid = true;
    });
  }

  void setWeight(String weight) {
    setState(() {
      this.weight = weight;
      weightValid = true;
    });
  }

  void setBest(String best) {
    setState(() {
      this.best = best;
      bestValid = true;
    });
  }

  void setFrom(String from) {
    setState(() {
      this.from = from;
      fromValid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 30),
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
          color: MyApp.isDarkMode.value
              ? MyColors.surface
              : const Color(0xFFF2F2F2),
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
                            height: 30,
                            child: Material(
                              color: MyApp.isDarkMode.value
                                  ? Colors.transparent
                                  : null,
                              child: Form(
                                child: WeightTextField(
                                  validatorText: 'Please enter title',
                                  hintText: 'e.g. Assignments',
                                  onChangeFunction: setText,
                                  isValid: textValid,
                                  textFieldController: textController,
                                  maxLength: 20,
                                  textStyle: const TextStyle(fontSize: 12.5),
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
                              color: MyApp.isDarkMode.value
                                  ? Colors.transparent
                                  : null,
                              child: Form(
                                child: WeightTextField(
                                  validatorText: 'Please enter weight',
                                  hintText: '',
                                  onChangeFunction: setWeight,
                                  isValid: weightValid,
                                  textFieldController: weightController,
                                  keyboardType: TextInputType.number,
                                  textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
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
                                  color: MyApp.isDarkMode.value
                                      ? Colors.transparent
                                      : null,
                                  child: Form(
                                    child: WeightTextField(
                                      validatorText: 'Please enter best',
                                      hintText: '',
                                      onChangeFunction: setBest,
                                      isValid: bestValid,
                                      textFieldController: bestController,
                                      keyboardType: TextInputType.text,
                                      enabled: checkboxState,
                                      textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
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
                              Container(
                                width: 35,
                                height: 35,
                                // color: Colors.blue,
                                // decoration: BoxDecoration(borderRadius: BorderRadius.all()),
                                child: Material(
                                  color: MyApp.isDarkMode.value
                                      ? Colors.transparent
                                      : null,
                                  child: Form(
                                    child: WeightTextField(
                                      validatorText: 'Please enter from',
                                      hintText: '',
                                      onChangeFunction: setFrom,
                                      isValid: fromValid,
                                      maxLength: 3,
                                      textFieldController: fromController,
                                      keyboardType: TextInputType.text,
                                      enabled: checkboxState,
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
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
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: Material(
                                color: MyApp.isDarkMode.value
                                    ? Colors.transparent
                                    : null,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  width: 100,
                  child: TextButton(
                    onPressed: () {
                      print('aaaaaaaddddd');
                      FocusManager.instance.primaryFocus?.unfocus();

                      if (text.isEmpty ||
                          weight.isEmpty ||
                          (checkboxState && (best.isEmpty || from.isEmpty))) {
                        // SHOW ERROR
                        if (text.isEmpty) {
                          setState(() {
                            textValid = false;
                          });
                        }
                        if (weight.isEmpty) {
                          setState(() {
                            weightValid = false;
                          });
                        }

                        if (checkboxState) {
                          if (best.isEmpty) {
                            setState(() {
                              bestValid = false;
                            });
                          }
                          if (from.isEmpty) {
                            setState(() {
                              fromValid = false;
                            });
                          }
                        }

                        widget.showError(true);
                        return;
                      }

                      if (best.isNotEmpty && from.isNotEmpty) {
                        Provider.of<ProviderData>(context, listen: false)
                            .addToWeights(Weight(
                                text: text,
                                weight: weight,
                                best: [best, from]));
                      } else {
                        Provider.of<ProviderData>(context, listen: false)
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

                      widget.showFunction(false);
                      widget.showError(false);
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
                const SizedBox(width: 15),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: TextButton(
                    onPressed: () {
                      widget.showFunction(false);
                      widget.showError(false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(0),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
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
    this.isValid = true,
    this.keyboardType,
  });

  final String validatorText;
  final String hintText;
  final TextStyle textStyle;
  final bool enabled;
  bool isValid;
  final int maxLength;
  final TextInputType? keyboardType;
  final dynamic textFieldController;
  final Function onChangeFunction;

  @override
  State<WeightTextField> createState() => _WeightTextFieldState();
}

class _WeightTextFieldState extends State<WeightTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      controller: widget.textFieldController,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      // maxLength: 2,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      keyboardType: widget.keyboardType,
      // autofillHints: const [AutofillHints.username],
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
        filled: true,
        fillColor: MyColors.background.withOpacity(0.6),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontFamily: "Outfit",
            fontWeight: FontWeight.w500,
            color: MyColors.secondary.withOpacity(.15)),
        enabledBorder: !MyApp.isDarkMode.value
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.5),
                borderSide: widget.isValid
                    ? BorderSide(color: Colors.grey[700]!, width: 0.7)
                    : BorderSide(color: Colors.red[700]!, width: 1),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.5),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5),
            borderSide: BorderSide(width: 2, color: MyColors.primaryVariant)),
        contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
      ),
    );
  }
}
