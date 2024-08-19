import 'package:flutter/material.dart';

class ListHorizontal extends StatefulWidget {
  final AnimationController? animationController;
  final List<double> valuesList;
  final void Function(int)? callBackRemove;
  final double? lowRange;
  final double? hiRange;

  const ListHorizontal({
    Key? key,
    required this.valuesList,
    required this.animationController,
    this.lowRange = -double.maxFinite,
    this.hiRange = double.maxFinite,
    this.callBackRemove,
  }) : super(key: key);

  @override
  State<ListHorizontal> createState() => _ListHorizontalState();
}

class _ListHorizontalState extends State<ListHorizontal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent
          ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
          itemCount: widget.valuesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / widget.valuesList.length) * index, 1.0,
                        curve: Curves.fastOutSlowIn)));
            widget.animationController!.forward();

            Color statusColor = widget.valuesList[index] < widget.lowRange! || widget.valuesList[index] > widget.hiRange! ?  Colors.red : Colors.green;
            return AnimatedBuilder(
              animation: widget.animationController!,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 50 * (1.0 - animation.value), 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 8.0),
                      child: InkWell(
                        onTap: () {
                          // widget.valuesList.removeAt(index);
                          if (widget.callBackRemove != null) {
                            widget.callBackRemove!(index);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: statusColor),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            // boxShadow: <BoxShadow>[
                            //   BoxShadow(
                            //       color: Colors.grey,
                            //       offset: Offset(-1, 2),
                            //       blurRadius: 2.0),
                            // ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, right: 8, left: 8),
                            child: Row(
                              textDirection: TextDirection.ltr,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 12),
                                  child: Text(
                                    widget.valuesList[index].toString(),
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        color: statusColor),
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
              },
            );
          },
        ),
      ),
    );
  }
}
