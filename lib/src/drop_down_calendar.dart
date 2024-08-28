import 'package:flutter/material.dart';

typedef ChangeValueCallBack = Function(DateTime selectedItems);

typedef BottomSheetCalListener = bool Function(
    DraggableScrollableNotification draggableScrollableNotification);

class DropDownDate {
  /// The initially selected [DateTime] that the picker should display.
  ///
  /// Subsequently changing this has no effect. To change the selected date,
  /// change the [key] to create a new instance of the [CalendarDatePicker], and
  /// provide that widget the new [initialDate]. This will reset the widget's
  /// interactive state.
  final DateTime? initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime? currentDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime> onDateChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The initial display of the calendar picker.
  ///
  /// Subsequently changing this has no effect. To change the calendar mode,
  /// change the [key] to create a new instance of the [CalendarDatePicker], and
  /// provide that widget a new [initialCalendarMode]. This will reset the
  /// widget's interactive state.
  final DatePickerMode initialCalendarMode;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  final bool showDoneOnHeader;

  /// This gives the bottom sheet title.
  final Widget? bottomSheetTitle;

  /// You can set your custom submit button when the multiple selection is enabled.
  final Widget? submitButtonChild;
  final int? submitButtonFlex;
  final Widget? cancelButtonChild;

  final EdgeInsets? buttonPadding;

  final TextStyle? textStyle;

  final TextStyle? textStyleSelected;

  final Color? selectedColor;

  final Color? color;

  /// This will set the background color to the dropdown.
  final Color dropDownBackgroundColor;

  /// [searchHintText] is use to show the hint text into the search widget.
  /// by default it is [Search] text.
  final String? searchHintText;
  final String? labelText;
  final String? hintText;

  /// [isDismissible] Specifies whether the bottom sheet will be dismissed when user taps on the scrim.
  /// If true, the bottom sheet will be dismissed when user taps on the scrim.
  /// by default it is [True].
  final bool isDismissible;
  final bool fromSide;
  final bool noCloseDialog;
  final double? widthSide;

  EdgeInsetsGeometry? margin;

  final Widget? customTopWidget;

  /// [bottomSheetListener] that listens for BottomSheet bubbling up the tree.
  final BottomSheetCalListener? bottomSheetListener;

  Widget? inputDescriptionWidget;

  DropDownDate({
    Key? key,
    this.currentDate,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.onDisplayedMonthChanged,
    this.initialCalendarMode = DatePickerMode.day,
    this.selectableDayPredicate,
    this.customTopWidget,
    this.hintText,
    this.labelText,
    this.inputDescriptionWidget,
    this.showDoneOnHeader = false,
    this.bottomSheetTitle,
    this.isDismissible = true,
    this.submitButtonChild,
    this.submitButtonFlex,
    this.cancelButtonChild,
    this.buttonPadding,
    this.searchHintText = 'Search',
    this.fromSide = false,
    this.widthSide,
    this.margin,
    this.color,
    this.textStyle,
    this.textStyleSelected,
    this.selectedColor,
    this.dropDownBackgroundColor = Colors.transparent,
    this.bottomSheetListener,
    this.noCloseDialog = false,
  });
}

class DropDownDateState {
  DropDownDate dropDownDate;

  DropDownDateState(this.dropDownDate);

  /// This gives the bottom sheet widget.
  void showModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: dropDownDate.fromSide
          ? Colors.transparent
          : dropDownDate.dropDownBackgroundColor,
      enableDrag: dropDownDate.isDismissible,
      isDismissible: dropDownDate.isDismissible,
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return dropDownDate.fromSide
                  ? Row(
                      // alignment: Alignment.topRight,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            if (dropDownDate.isDismissible) {
                              Navigator.maybePop(context);
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                        Container(
                          margin: dropDownDate.margin,
                          width: dropDownDate.widthSide ??
                              MediaQuery.of(context).size.width / 2,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: dropDownDate.dropDownBackgroundColor,
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: MainBodyCal(
                                dropDownDate: dropDownDate,
                                fromSide: dropDownDate.fromSide,
                                noCloseDialog: dropDownDate.noCloseDialog),
                          ),
                        ),
                      ],
                    )
                  : MainBodyCal(
                      dropDownDate: dropDownDate,
                      fromSide: dropDownDate.fromSide,
                      noCloseDialog: dropDownDate.noCloseDialog);
            },
          ),
        );
      },
    );
  }
}

/// This is main class to display the bottom sheet body.
class MainBodyCal extends StatefulWidget {
  final DropDownDate dropDownDate;
  final bool fromSide;
  final bool? noCloseDialog;

  const MainBodyCal(
      {required this.dropDownDate,
      required this.fromSide,
      this.noCloseDialog = false,
      Key? key})
      : super(key: key);

  @override
  State<MainBodyCal> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBodyCal> {
  /// This list will set when the list of data is not available.

  Color myControlColor = Colors.black87;
  TextStyle myTextStyle = const TextStyle(fontSize: 15, color: Colors.black87);

  double minHeight = 0.7;
  double maxHeight = 0.7;
  double initHeight = 0.55;

  @override
  void initState() {
    super.initState();
    maxHeight = widget.fromSide ? 1 : 0.7;
    minHeight = widget.fromSide ? 1 : 0.3;
  }

  @override
  Widget build(BuildContext context) {
    if (initHeight > maxHeight) initHeight = maxHeight;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: widget.dropDownDate.bottomSheetListener,
      child: DraggableScrollableSheet(
        initialChildSize: initHeight,
        minChildSize: minHeight,
        maxChildSize: maxHeight,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Bottom sheet title text
                    Expanded(
                        child: widget.dropDownDate.bottomSheetTitle ??
                            Container()),

                    /// Done button
                    Visibility(
                      visible:
                          // widget.dropDownDate.enableMultipleSelection &&
                          widget.dropDownDate.showDoneOnHeader,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: widget.dropDownDate.submitButtonChild ??
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(
                                      color: Colors.transparent, width: 0)),
                              color: Colors.green.shade300,
                              onPressed: () {
                                // widget.dropDownDate.selectedItems
                                //     ?.call(selectedNameList);
                                // _onUnFocusKeyboardAndPop();
                              },
                              child: const Text('Done'),
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Calendar

              CalendarDatePicker(
                initialDate: widget.dropDownDate.initialDate,
                firstDate:
                widget.dropDownDate.firstDate,
                lastDate: widget.dropDownDate.lastDate,
                onDateChanged: (value) {
                  widget.dropDownDate.onDateChanged(value);
                  if (!widget.noCloseDialog!) {
                    _onUnFocusKeyboardAndPop();
                  }
                },
              ),

              /// Controller Button
              Visibility(
                visible:
                    // widget.dropDownDate.enableMultipleSelection &&
                    !widget.dropDownDate.showDoneOnHeader,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: widget.dropDownDate.buttonPadding ??
                        const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        widget.dropDownDate.cancelButtonChild != null
                            ? Expanded(
                                flex: 1,
                                child: widget.dropDownDate.cancelButtonChild!,
                              )
                            : const SizedBox(),
                        Expanded(
                          flex: widget.dropDownDate.submitButtonFlex ?? 2,
                          child: widget.dropDownDate.submitButtonChild ??
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: Colors.transparent, width: 0)),
                                color: Colors.green.shade500,
                                onPressed: () {

                                },
                                child: const Text('Done',
                                    style: TextStyle(color: Colors.white)),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  /// This helps to UnFocus the keyboard & pop from the bottom sheet.
  _onUnFocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }
}
