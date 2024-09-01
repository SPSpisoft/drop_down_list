import 'package:flutter/material.dart';

class ListHorizontal extends StatefulWidget {
  final List<double>? lastList;
  final List<double> valuesList;
  final void Function(int)? callBackRemove;
  final double? lowRange;
  final double? hiRange;

  const ListHorizontal({
    Key? key,
    required this.lastList,
    required this.valuesList,
    this.lowRange = -double.maxFinite,
    this.hiRange = double.maxFinite,
    this.callBackRemove,
  }) : super(key: key);

  @override
  State<ListHorizontal> createState() => ListHorizontalState();
}

class ListHorizontalState extends State<ListHorizontal> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<double> _items = [];

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.valuesList);
  }

  void addItem(double newValue) {
    _items.insert(0, newValue);
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
              scrollDirection: Axis.horizontal,
              initialItemCount: _items.length,
              itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                Color statusColor = _items[index] < widget.lowRange! || _items[index] > widget.hiRange!
                    ? Colors.red
                    : Colors.green;

                // bool v =  index < _items.length - widget.lastList!.length;

                bool isNew = widget.lastList == null ||
                    index < _items.length - widget.lastList!.length;
                //todo : review
                    // ||
                    // (widget.lastList!.length > index && _items[widget.lastList!.length - 1 - index] != widget.lastList![index]);

                return _buildItem(_items[index], animation, index, statusColor, isNew);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(double value, Animation<double> animation, int index, Color statusColor, bool isNew) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 8.0),
          child: InkWell(
            onTap: () {
              if (widget.callBackRemove != null) {
                widget.callBackRemove!(index);
              }
              _removeItem(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isNew ? Colors.grey.shade300 : Colors.white,
                border: Border.all(color: statusColor),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                child: Row(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 12),
                      child: Text(
                        value.toString(),
                        style: TextStyle(fontFamily: "Roboto", fontSize: 14, color: statusColor),
                      ),
                    ),
                    Icon(
                      Icons.highlight_remove,
                      size: 17,
                      color: statusColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeItem(int index) {
    double removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) {
            bool isNew = widget.lastList == null || widget.lastList!.length <= index || _items[index] != widget.lastList![index];
            return _buildItem(removedItem, animation, index, Colors.red, isNew);
          },
      duration: const Duration(milliseconds: 500),
    );
  }
}
