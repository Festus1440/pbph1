import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:pb_ph1/core/widgets/app_bar.dart';
import 'package:pb_ph1/core/widgets/sliding_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:pb_ph1/core/extensions/string_extension.dart';
import 'package:pb_ph1/routers/manage_funds_router.dart';

const cardsSample = ['Visa ****-4222', 'Visa ****-4223', 'Visa ****-4224', 'Visa ****-4225', 'Add New Card'];
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
    'value': -1,
  }
];

class ManageFunds extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = NuRouter.of<ManageFundsRouter>(context);
    final fundsState = useState({
      'cardState': cardsSample[0],
      'amount': amountSample[0],
      'auto-reload': false
    });
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
              if(value != 'Add New Card') {
                fundsState.value = {
                  ...fundsState.value,
                  'cardSelected': value
                };
                return;
              }
              await router.popAndPushToManageCards();

            }),
        SizedBox(height: 35),
        'amount to fund'.allWordsCapitilize().text.color(context.textTheme.caption.color).make(),
        HStack([
         ...amountSample.map((e) => ActionChip(label: (e['label'] as String).text.color(Colors.white).make(), backgroundColor: context.primaryColor, onPressed: () {
           fundsState.value = {
             ...fundsState.value,
             'amount': e
           };
         },)).toList()
        ], axisSize: MainAxisSize.max, alignment: MainAxisAlignment.spaceEvenly),
        SizedBox(height: 35),
        HStack([
          'auto-reload'.allWordsCapitilize().text.color(context.textTheme.caption.color).make(),
          CupertinoSwitch(
            value: fundsState.value['auto-reload'],
            onChanged: (value) {
              fundsState.value = {
                ...fundsState.value,
                'auto-reload': value
              };
            },
          )
        ], axisSize: MainAxisSize.max, alignment: MainAxisAlignment.spaceBetween),
        Expanded(child: Center(child: VStack([
          'total: ${((fundsState.value['amount'] as Map)['value']).toString().currencyFormat(currencyName: 'USD')}'.allWordsCapitilize().text.size(25).make(),
          SizedBox(height: 15),
          SlidingButton(hint: 'SLIDE TO ADD FUNDS' ,onSlideEnd: (){

          })
        ], axisSize: MainAxisSize.max, alignment: MainAxisAlignment.center, crossAlignment: CrossAxisAlignment.center,),))
      ])).pSymmetric(v: 20, h: 35),
      
    );
  }
}
