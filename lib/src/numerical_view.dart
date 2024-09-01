import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';

typedef KeyboardTapCallback = void Function(Object? text);

class NumericKeyboard extends StatefulWidget {
  /// Color of the text [default = Colors.black]
  final TextStyle? textStyle;

  final double? sizeNumButton;

  /// Display a custom right icon
  final Widget? rightIcon;

  /// Action to trigger when right button is pressed
  final Function()? rightButtonFn;

  final String? cancelButtonText;
  final Function()? cancelButtonFn;
  final String? doneButtonText;
  final Function()? doneButtonFn;
  final TextStyle? textButtonStyle;

  /// Action to trigger when right button is long pressed
  final Function()? rightButtonLongPressFn;
  final Function()? leftButtonLongPressFn;

  /// Display a custom left icon
  final Widget? leftIcon;
  final Widget? customTextButton;
  final EdgeInsetsGeometry? textButtonPadding;
  final bool textButtonOnTopKeys;

  /// Action to trigger when left button is pressed
  final Function()? leftButtonFn;

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  /// Main axis alignment [default = MainAxisAlignment.spaceEvenly]
  final MainAxisAlignment mainAxisAlignment;

  final List<Widget>? ctrlWidgets;
  final Widget? addWidget;
  final List<BoxShadow>? boxShadow;

  const NumericKeyboard(
      {Key? key,
      required this.onKeyboardTap,
      this.boxShadow,
      this.ctrlWidgets,
      this.addWidget,
      this.textStyle,
      this.rightButtonFn,
      this.rightButtonLongPressFn,
      this.rightIcon,
      this.sizeNumButton,
      this.textButtonStyle,
      this.cancelButtonText,
      this.doneButtonText,
      this.cancelButtonFn,
      this.doneButtonFn,
      this.customTextButton,
      this.textButtonPadding,
      this.textButtonOnTopKeys = false,
      this.leftButtonFn,
      this.leftButtonLongPressFn,
      this.leftIcon,
      // this.customTopWidget,
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardState();
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  TextStyle? myTextButtonStyle;

  @override
  Widget build(BuildContext context) {
    myTextButtonStyle = widget.textButtonStyle;
    return LayoutBuilder(builder: (ctx, cons) {
      myTextButtonStyle ??
          TextStyle(color: Colors.blue, fontSize: 6.5.parentSP(cons));
      return myView(cons);
    });
  }

  Widget myView(BoxConstraints cons) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        keyboard(cons),
        Padding(
          padding:
              EdgeInsets.only(top: 4.parentH(cons), bottom: 4.parentH(cons)),
          child: Container(
              width: widget.sizeNumButton ?? 25.parentW(cons),
              height: widget.sizeNumButton ?? 92.parentH(cons),
              color: Colors.white,
              child: keyCtrl(cons)),
        )
      ],
    );
  }

  Widget keyCtrl(BoxConstraints cons) {
    if (widget.ctrlWidgets != null) {
      List<Widget> lstCtrl = [];
      for (var e in widget.ctrlWidgets!) {
        lstCtrl.add(Expanded(child: _ctrlButton(e, cons)));
      }

      if (widget.addWidget != null) {
        lstCtrl.add(widget.addWidget!);
      }
      return Column(
          mainAxisAlignment: MainAxisAlignment.center, children: lstCtrl);
    } else {
      return const SizedBox();
    }
  }

  Widget keyboard(BoxConstraints cons) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _calcButton('1', cons),
              _calcButton('2', cons),
              _calcButton('3', cons),
            ],
            buttonPadding: const EdgeInsets.all(0),
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _calcButton('4', cons),
              _calcButton('5', cons),
              _calcButton('6', cons),
            ],
            buttonPadding: const EdgeInsets.all(0),
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _calcButton('7', cons),
              _calcButton('8', cons),
              _calcButton('9', cons),
            ],
            buttonPadding: const EdgeInsets.all(0),
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            buttonPadding: const EdgeInsets.all(0),
            children: <Widget>[
              InkWell(
                onTap: widget.leftButtonFn,
                onLongPress: widget.leftButtonLongPressFn,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black12),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      boxShadow: widget.boxShadow,
                    ),
                    alignment: Alignment.center,
                    width: widget.sizeNumButton ?? 22.parentW(cons),
                    height: widget.sizeNumButton ?? 22.parentH(cons),
                    child: widget.leftIcon,
                  ),
                ),
              ),
              _calcButton('0', cons),
              InkWell(
                  onTap: widget.rightButtonFn,
                  onLongPress: widget.rightButtonLongPressFn,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                        boxShadow: widget.boxShadow,
                      ),
                      alignment: Alignment.center,
                      width: widget.sizeNumButton ?? 22.parentW(cons),
                      height: widget.sizeNumButton ?? 22.parentH(cons),
                      child: widget.rightIcon,
                    ),
                  ))
            ],
          ),
          // widget.textButtonOnTopKeys ? SizedBox() : textButtons(),
        ],
      ),
    );
  }

  Widget _calcButton(String value, cons) {
    return InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          widget.onKeyboardTap(value);
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: widget.boxShadow,
            ),
            alignment: Alignment.center,
            width: widget.sizeNumButton ?? 22.parentW(cons),
            height: widget.sizeNumButton ?? 22.parentH(cons),
            child: Text(
              value,
              style: widget.textStyle ??
                  TextStyle(
                      color: Colors.black,
                      fontSize: 3.parentW(cons) + 3.parentH(cons)),
            ),
          ),
        ));
  }

  Widget _ctrlButton(Widget view, cons) {
    return InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          widget.onKeyboardTap(view.key);
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: widget.boxShadow,
            ),
            alignment: Alignment.center,
            // height: double.infinity,
            // width: widget.sizeNumButton ?? 22.parentW(cons),
            // height: widget.sizeNumButton ?? 70,
            child: view,
          ),
        ));
  }

  textButtons() {
    return Padding(
      padding: widget.textButtonPadding ?? const EdgeInsets.all(2.0),
      child: widget.customTextButton ??
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.cancelButtonFn != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: widget.cancelButtonFn,
                          child: Text(widget.cancelButtonText ?? "Cancel",
                              style: myTextButtonStyle)),
                    )
                  : const SizedBox(),
              widget.doneButtonFn != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: widget.doneButtonFn,
                          child: Text(widget.doneButtonText ?? "Done",
                              style: myTextButtonStyle)),
                    )
                  : const SizedBox(),
            ],
          ),
    );
  }
}
