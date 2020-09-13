import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:provider/provider.dart';

class ItemCounter extends StatelessWidget {
  final Item item;

  ItemCounter({@required this.item, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return Counter(
      initialValue: cart.getItemCount(item),
      minValue: 0,
      maxValue: 1000000,
      decimalPlaces: 0,
      onChanged: (value) {
        if (cart.getItemCount(item) > value) {
          cart.remove(item);
        } else if (cart.getItemCount(item) < value) {
          cart.add(item);
        }
      },
      textStyle: Theme.of(context).textTheme.headline6.copyWith(color: kTextColor),
    );
  }
}

typedef void CounterChangeCallback(num value);

class Counter extends StatelessWidget {
  final CounterChangeCallback onChanged;

  Counter({
    Key key,
    @required num initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    @required this.decimalPlaces,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  final num selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// text syle
  final TextStyle textStyle;

  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(4.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: GestureDetector(
              onTap: _decrementCounter,
              child: Icon(
                FontAwesomeIcons.minus,
                size: 20,
                color: kButtonColor,
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(4.0),
            child: new Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle),
          ),
          new SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: GestureDetector(
              onTap: _incrementCounter,
              child: Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: kButtonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
