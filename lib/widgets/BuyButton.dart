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
        child: Text('Buy', style: Theme.of(context).textTheme.display4),
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
