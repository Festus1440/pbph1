import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:pb_ph1/core/widgets/app_bar.dart';
import 'package:pb_ph1/core/widgets/sliding_button.dart';
import 'package:pb_ph1/routers/manage_funds_router.dart';
import 'package:velocity_x/velocity_x.dart';

class ManageCards extends HookWidget {
  final _formKey = GlobalKey<FormState>();
  final _expController = TextEditingController();
  final _expFormatter = _ExpirationTextFormatter();
  final _cardNumberFormatter = _CardNumberTextFormatter();

  @override
  Widget build(BuildContext context) {
    final _cvvFocus = useFocusNode();
    final router = NuRouter.of<ManageFundsRouter>(context);
    final formState = useState({'card_name':'', 'card_number': '', 'exp': '', 'cvv': '', 'postal': '', 'save': false, 'show_back': false});
    useEffect(() {
      _cvvFocus.addListener(() {
        formState.value = {
          ...formState.value,
          'show_back': _cvvFocus.hasFocus
        };
      });
      return _cvvFocus.dispose;
    }, [_cvvFocus]);

    return Scaffold(
      appBar: PBDefaultAppBar(
        title: 'Manage Cards',
      ),
      // body: FlatButton(
      //   onPressed: () async {
      //     // router.pushAndRemoveUntilToManageFundsMain(predicate: (route) => route.settings.name == ManageFundsRoutes.manageFundsMain);
      //     Nuvigator.of(context).popUntil((route) => route.settings.name == ManageFundsRoutes.manageFundsMain);
      //   },
      //   child: 'test'.text.makeCentered(),
      body: Container(
          child: Form(
        key: _formKey,
        child: VStack(
          [
            CreditCardWidget(
              cardBgColor: context.primaryColor,
              labelCardHolder: '[Your Name]',
              labelExpiredDate: 'MM/YY',
              cardHolderName: formState.value['card_name'],
              cardNumber: formState.value['card_number'],
              // '5555 5555 5555 5555',
              obscureCardCvv: true,
              obscureCardNumber: true,
              cvvCode: formState.value['cvv'],
              expiryDate: formState.value['exp'],
              showBackView: formState.value['show_back'],
              textStyle: context.textTheme.bodyText2.copyWith(color: formState.value['show_back'] ? Colors.black38 : Colors.white, fontSize: 18),
            ),
            SizedBox(height: 15),
            'card name'
                .allWordsCapitilize()
                .text
                .textStyle(context.textTheme.bodyText1.copyWith(fontSize: 18))
                .make(),
            SizedBox(height: 5),
            TextFormField(
              onChanged: (value) {
                formState.value = {
                  ...formState.value,
                  'card_name': value.trim()
                };
              },
              validator: (value) => value.isEmptyOrNull ? 'Please input card name' : null,
              decoration: InputDecoration(
                  hintText: 'Enter Card Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
            ),
            SizedBox(height: 20),
            'card number'
                .allWordsCapitilize()
                .text
                .textStyle(context.textTheme.bodyText1.copyWith(fontSize: 18))
                .make(),
            SizedBox(height: 5),
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16), _cardNumberFormatter,],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                formState.value = {
                  ...formState.value,
                  'card_number': value
                };
              },
              validator: (value) => value.isEmptyOrNull ? 'Please input card number' : null,
              decoration: InputDecoration(
                  hintText: 'Enter Card Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
            ),
            SizedBox(height: 20),
            'Expiration'.allWordsCapitilize().text.textStyle(context.textTheme.bodyText1.copyWith(fontSize: 18)).make(),
            SizedBox(height: 5),
            TextFormField(
              controller: _expController,
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
                _expFormatter
              ],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // final tempValue = value.replaceAllMapped(RegExp(r'.{2}'), (match) => '${match.group(0)}/');
                // final expValue = value.length == 4 ? tempValue.eliminateLast : tempValue;

                // _expController.text = expValue;
                // _expController.selection = new TextSelection(
                //     baseOffset: expValue.length,
                //     extentOffset: expValue.length
                // );
                formState.value = {...formState.value, 'exp': value.trim()};
              },
              validator: (value) => value.isEmptyOrNull ? 'Please input expiration' : null,
              decoration: InputDecoration(
                  hintText: 'Enter Expiration (MM/YY)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
            ),
            SizedBox(height: 20),
            '3-digit ccv code'
                .allWordsCapitilize()
                .text
                .textStyle(context.textTheme.bodyText1.copyWith(fontSize: 18))
                .make(),
            SizedBox(height: 5),
            TextFormField(
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // final tempValue = value.replaceAllMapped(RegExp(r'.{2}'), (match) => '${match.group(0)}/');
                // final expValue = value.length == 4 ? tempValue.eliminateLast : tempValue;

                // _expController.text = expValue;
                // _expController.selection = new TextSelection(
                //     baseOffset: expValue.length,
                //     extentOffset: expValue.length
                // );
                formState.value = {...formState.value, 'cvv': value.trim()};
              },
              validator: (value) => value.isEmptyOrNull ? 'Please input cvv code' : null,
              decoration: InputDecoration(
                  hintText: 'enter 3-digit cvv code'.allWordsCapitilize(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
              focusNode: _cvvFocus,
            ),
            SizedBox(height: 20),
            'billing postal code'
                .allWordsCapitilize()
                .text
                .textStyle(context.textTheme.bodyText1.copyWith(fontSize: 18))
                .make(),
            SizedBox(height: 5),
            TextFormField(
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onChanged: (value) {
                // final tempValue = value.replaceAllMapped(RegExp(r'.{2}'), (match) => '${match.group(0)}/');
                // final expValue = value.length == 4 ? tempValue.eliminateLast : tempValue;

                // _expController.text = expValue;
                // _expController.selection = new TextSelection(
                //     baseOffset: expValue.length,
                //     extentOffset: expValue.length
                // );
                formState.value = {...formState.value, 'postal': value.trim()};
              },
              validator: (value) => value.isEmptyOrNull ? 'Please input billing postal code' : null,
              decoration: InputDecoration(
                  hintText: 'enter billing postal code'.allWordsCapitilize(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
            ),
            SizedBox(height: 25),
            CheckboxListTile(
                title: 'save this credit card for future fund reload'.firstLetterUpperCase().text.make(),
                value: formState.value['save'],
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.only(left: 0),
                onChanged: (value) {
                  formState.value = {...formState.value, 'save': value};
                }),
            SizedBox(height: 25),
            RaisedButton(
              child: 'save and proceed'.allWordsCapitilize().text.size(18).color(Colors.white).make(),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                // _formKey.currentState.save();

              },
            ).w(context.screenWidth)
          ],
          axisSize: MainAxisSize.max,
        ),
      )).pSymmetric(h: 15, v: 15).scrollVertical(physics: BouncingScrollPhysics()),
    );
  }
}

class _ExpirationTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newVal = newValue.text;
    final tempValue = oldValue.text.contains('/') && newVal.length == 2
        ? newVal
        : newVal.replaceAllMapped(RegExp(r'.{2}'), (match) => '${match.group(0)}/');
    final expValue = newVal.length == 4 ? tempValue.eliminateLast : tempValue;
    return TextEditingValue(text: expValue, selection: TextSelection.collapsed(offset: expValue.length));
  }
}

class _CardNumberTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newVal = newValue.text;
    final oldVal = oldValue.text;
    final val = newVal.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ').trim();
    return TextEditingValue(text: val, selection: TextSelection.collapsed(offset: val.length));
  }

}