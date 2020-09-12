import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {

  final Function onPressed;

  BuyButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: RaisedButton(
        onPressed: onPressed,
        disabledColor: Colors.black12,
        child: Text('Buy', style: Theme.of(context).textTheme.headline1),
        color: Colors.indigoAccent,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.indigoAccent),
        ),
      ),
    );
  }
}
