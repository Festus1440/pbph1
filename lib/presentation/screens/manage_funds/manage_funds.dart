import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:pb_ph1/core/widgets/app_bar.dart';
import 'package:pb_ph1/core/widgets/sliding_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:pb_ph1/core/extensions/string_extension.dart';
import 'package:pb_ph1/routers/manage_funds_router.dart';

const cardsSample = ['Visa ****-4222', 'Visa ****-4223', 'Visa ****-4224', 'Visa ****-4225', '[Add New Card]'];
const amountSample = [
  {
    'label': '\$10',
    'value': 10,
  },
  {
    'label': '\$25',
    'value': 25,
  },
  {
    'label': '\$50',
    'value': 50,
  },
  {
    'label': 'Other',
    'value': 0,
  }
];

class ManageFunds extends HookWidget {
  final _formKey = GlobalKey<FormState>();
  final _formatter = NumberTextFormatter();

  @override
  Widget build(BuildContext context) {
    final router = NuRouter.of<ManageFundsRouter>(context);
    final fundsState = useState({'cardState': cardsSample[0], 'amount': amountSample[0], 'auto-reload': false});
    return Scaffold(
      appBar: PBDefaultAppBar(
        title: 'Manage Funds',
      ),
      body: Container(
          child: VStack([
        HStack([
          Icon(FontAwesomeIcons.wallet, size: 92),
          VStack([
            'your prepaid balance'.allWordsCapitilize().text.color(context.textTheme.caption.color).make(),
            '\$ 22.85'.text.size(32).make()
          ], crossAlignment: CrossAxisAlignment.center, axisSize: MainAxisSize.min)
        ], axisSize: MainAxisSize.max, alignment: MainAxisAlignment.spaceBetween),
        SizedBox(height: 35),
        'payment method'.allWordsCapitilize().text.color(context.textTheme.caption.color).make(),
        DropdownButton(
            isExpanded: true,
            value: fundsState.value['cardState'],
            icon: Icon(Icons.chevron_right_rounded).rotate(90),
            elevation: 16,
            items: cardsSample.map((e) => DropdownMenuItem(child: e.text.make(), value: e)).toList(),
            onChanged: (value) async {
              if (!(value as String).contains('Add New Card')) {
                fundsState.value = {...fundsState.value, 'cardSelected': value};
                return;
              }
              await router.toManageCards();
            }),
        SizedBox(height: 35),
        'amount to fund'.allWordsCapitilize().text.color(context.textTheme.caption.color).make(),
        HStack([
          ...amountSample.map((e) {
            final selected = (fundsState.value['amount'] as Map)['label'] == e['label'];
            return FilterChip(
              label: (e['label'] as String).text.color(Colors.black54).make(),
              backgroundColor: Colors.transparent,
              selectedColor: selected ? context.primaryColor : Colors.transparent,
              shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
              selected: selected,
              onSelected: (value) {
                fundsState.value = {...fundsState.value, 'amount': e};
              },
            );
          }).toList()
        ], axisSize: MainAxisSize.max, alignment: MainAxisAlignment.spaceEvenly),
        Visibility(
            child: VStack([
              SizedBox(height: 35),
              Form(
                key: _formKey,
                child: VStack([
                  'custom amount'.allWordsCapitilize().text.color(context.textTheme.caption.color).make(),
                  SizedBox(height: 15),
                  TextFormField(
                    onChanged: (value) {
                      fundsState.value = {
                        ...fundsState.value,
                        'amount': {'label': 'Other', 'value': value.isEmptyOrNull ? 0 : num.tryParse(value)}
                      };
                    },
                    inputFormatters: [_formatter],
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.deepPurpleAccent,
                    validator: (value) => value.isEmptyOrNull ? 'Please input amount' : null,
                    decoration: InputDecoration(
                        focusColor: Colors.deepPurpleAccent,
                        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                        hintText: 'enter amount'.allWordsCapitilize(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        )),
                  )
                ], axisSize: MainAxisSize.max),
              ),
            ], axisSize: MainAxisSize.max),
            visible: ((fundsState.value['amount'] as Map)['label'] as String).toLowerCase().contains('other')),
        SizedBox(height: 35),
        HStack([
          'auto-reload'.allWordsCapitilize().text.color(context.textTheme.caption.color).make(),
          CupertinoSwitch(
            value: fundsState.value['auto-reload'],
            onChanged: (value) {
              fundsState.value = {...fundsState.value, 'auto-reload': value};
            },
          )
        ], axisSize: MainAxisSize.max, alignment: MainAxisAlignment.spaceBetween),
        Expanded(
            child: Center(
          child: VStack(
            [
              'total: ${((fundsState.value['amount'] as Map)['value']).toString().currencyFormat(currencyName: 'USD')}'
                  .allWordsCapitilize()
                  .text
                  .size(25)
                  .make(),
              SizedBox(height: 15),
              SlidingButton(
                  chevronColor: const Color(0xFFA0C44D),
                  thumbColor: Colors.white,
                  labelColor: Colors.white,
                  thumbPathColor: const Color(0xFFA0C44D),
                  hint: 'SLIDE TO ADD FUNDS',
                  onSlideEnd: () async {
                    if (_formKey.currentState != null && !_formKey.currentState.validate()) {
                      return;
                    }

                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'donation reminder'.allWordsCapitilize(),
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          content: Container(
                                  child: Text(
                                      'Every 30 days, your unused funds will automatically convert into a donation to support local hunger and families experiencing food insecurity in Chicago.'))
                              .wOneForth(context),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('okay, lets eat!'.toUpperCase(),
                                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)))
                          ],
                        );
                      },
                    );
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Funds Added'.allWordsCapitilize(),
                                style: TextStyle(color: const Color(0xFFA0C44D))),
                            content: Container(
                                    child: Text(
                                        'Thank you for supporting local restaurants and joining the fight against local hunger in Chicago!'))
                                .wOneForth(context),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'.toUpperCase(), style: TextStyle(color: Colors.grey)))
                            ],
                          );
                        });
                  })
            ],
            axisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.center,
            crossAlignment: CrossAxisAlignment.center,
          ),
        ))
      ])).pSymmetric(v: 20, h: 35),
    );
  }
}

class NumberTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // final value = num.tryParse(newValue.text)?.toString() ??
    //    ( !oldValue.text.isEmptyOrNull && oldValue.text.removeAllWhiteSpace().characters.last.isNumber() )
    //     ? oldValue.text.removeAllWhiteSpace()
    //     : oldValue.text.removeAllWhiteSpace().eliminateLast;
    final value = newValue.text ?? oldValue.text;
    return TextEditingValue(text: value, selection: TextSelection.collapsed(offset: value.length));
  }
}
