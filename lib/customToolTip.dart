import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class CustomToolTip extends StatelessWidget {
  final CreditCardTheme theme;
  CustomToolTip({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.help, color: theme.borderColor),
      onPressed: () {
        showPopover(
            context: context,
            direction: PopoverDirection.bottom,
            arrowHeight: 0,
            arrowWidth: 0,
            onPop: () => FocusManager.instance.primaryFocus!.unfocus(),
            bodyBuilder: (context) => Container(
                  width: 140,
                  height: 116,
                  padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                  child: Column(
                    children: [
                      Text(
                          '3-digit security code found on the back of your card',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Nunito')),
                      Image.asset(
                        'images/cvvcode.png',
                        package: 'credit_card_form',
                        height: 80,
                      )
                    ],
                  ),
                ));
      },
    );
  }
}
