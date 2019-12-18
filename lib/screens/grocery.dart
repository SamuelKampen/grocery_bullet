import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/grocery.dart';
import 'package:intl/intl.dart';

// Used to format doubles as currency
final oCcy = new NumberFormat("#,##0.00", "en_US");

class Grocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var catalog = Provider.of<GroceryModel>(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= catalog.getCatalogSize()) return null;
              return _GroceryItem(index);
            },
          ),
        )
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final Item item;
  const _AddButton({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return IconButton(
      onPressed: () => cart.add(item),
      icon: Icon(Icons.add),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final Item item;
  const _RemoveButton({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return IconButton(
      onPressed: () => cart.remove(item),
      icon: Icon(Icons.remove),
    );
  }
}

class _GroceryItem extends StatelessWidget {
  final int index;
  _GroceryItem(this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var catalog = Provider.of<GroceryModel>(context);
    var cart = Provider.of<CartModel>(context);
    var item = catalog.getByPosition(index);
    var textTheme = Theme.of(context).textTheme.title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(item.name, style: textTheme),
            ),
            Expanded(
              child: Text(oCcy.format(item.price), style: textTheme),
            ),
            _RemoveButton(item: item),
            Text(cart.getItemCount(item).toString(), style: textTheme),
            _AddButton(item: item),
          ],
        ),
      ),
    );
  }
}
