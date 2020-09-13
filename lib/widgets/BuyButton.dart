import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/Constants.dart';

class BuyButton extends StatelessWidget {
  final Function onPressed;

  BuyButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: RaisedButton(
        onPressed: onPressed,
        disabledColor: Colors.grey[130],
        child: Text('Buy',
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: kTextColor)),
        color: kButtonColor,
        textColor: kTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
  }
}
