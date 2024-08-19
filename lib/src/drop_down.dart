
import 'package:flutter/material.dart';

import '../model/selected_list_item.dart';
import 'app_text_field.dart';

typedef SelectedItemsCallBack = Function(List<SelectedListItem> selectedItems);

typedef ListItemBuilder = Widget Function(int index);

typedef BottomSheetListener = bool Function(
    DraggableScrollableNotification draggableScrollableNotification);

class DropDown {
  /// This will give the list of data.
  final List<SelectedListItem> data;

  /// This will give the call back to the selected items from list.
  final SelectedItemsCallBack? selectedItems;

  /// [listItemBuilder] will gives [index] as a function parameter and you can return your own widget based on [index].
  final ListItemBuilder? listItemBuilder;

  /// This will give selection choice for single or multiple for list.
  final bool enableMultipleSelection;
  final bool showDoneOnHeader;

  /// This gives the bottom sheet title.
  final Widget? bottomSheetTitle;

  /// You can set your custom submit button when the multiple selection is enabled.
  final Widget? submitButtonChild;
  final int? submitButtonFlex;
  final Widget? cancelButtonChild;

  final EdgeInsets? buttonPadding;

  /// [searchWidget] is use to show the text box for the searching.
  /// If you are passing your own widget then you must have to add [TextEditingController] for the [TextFormField].
  final TextFormField? searchWidget;

  /// [isSearchVisible] flag use to manage the search widget visibility
  /// by default it is [True] so widget will be visible.
  final bool isSearchVisible;

  /// [showRadioButton]
  /// by default it is [True] so widget will be visible.
  final bool showRadioButton;

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
  final BottomSheetListener? bottomSheetListener;

  Widget? inputDescriptionWidget;

  DropDown({
    Key? key,
    required this.data,
    this.selectedItems,
    this.customTopWidget,
    this.listItemBuilder,
    this.hintText,
    this.labelText,
    this.inputDescriptionWidget,
    this.enableMultipleSelection = false,
    this.showDoneOnHeader = false,
    this.bottomSheetTitle,
    this.isDismissible = true,
    this.submitButtonChild,
    this.submitButtonFlex,
    this.cancelButtonChild,
    this.buttonPadding,
    this.searchWidget,
    this.searchHintText = 'Search',
    this.isSearchVisible = true,
    this.showRadioButton = true,
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

class DropDownState {
  DropDown dropDown;

  DropDownState(this.dropDown);

  /// This gives the bottom sheet widget.
  void showModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: dropDown.fromSide
          ? Colors.transparent
          : dropDown.dropDownBackgroundColor,
      enableDrag: dropDown.isDismissible,
      isDismissible: dropDown.isDismissible,
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return dropDown.fromSide
                  ? Row(
                      // alignment: Alignment.topRight,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            if (dropDown.isDismissible) {
                              Navigator.maybePop(context);
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                        Container(
                          margin: dropDown.margin,
                          width: dropDown.widthSide ??
                              MediaQuery.of(context).size.width / 2,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: dropDown.dropDownBackgroundColor,
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child:  MainBody(
                                    dropDown: dropDown,
                                    fromSide: dropDown.fromSide,
                                    noCloseDialog: dropDown.noCloseDialog),
                          ),
                        ),
                      ],
                    )
                  :  MainBody(
                          dropDown: dropDown,
                          fromSide: dropDown.fromSide,
                          noCloseDialog: dropDown.noCloseDialog);
            },
          ),
        );
      },
    );
  }
}

/// This is main class to display the bottom sheet body.
class MainBody extends StatefulWidget {
  final DropDown dropDown;
  final bool fromSide;
  final bool? noCloseDialog;

  const MainBody(
      {required this.dropDown,
      required this.fromSide,
      this.noCloseDialog = false,
      Key? key})
      : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  /// This list will set when the list of data is not available.
  List<SelectedListItem> mainList = [];

  Color myControlColor = Colors.black87;
  TextStyle myTextStyle = const TextStyle(fontSize: 15, color: Colors.black87);

  double minHeight = 0.3;
  double maxHeight = 0.7;
  double initHeight = 0.4;

  @override
  void initState() {
    super.initState();
    mainList = widget.dropDown.data;
    maxHeight = widget.fromSide ? 1 : 0.7;
    minHeight = widget.fromSide ? 1 : 0.3;
    _setSearchWidgetListener();
  }

  @override
  Widget build(BuildContext context) {
    initHeight = minHeight + 0.1 * mainList.length;
    if (initHeight > maxHeight) initHeight = maxHeight;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: widget.dropDown.bottomSheetListener,
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
                        child: widget.dropDown.bottomSheetTitle ?? Container()),

                    /// Done button
                    Visibility(
                      visible:
                          // widget.dropDown.enableMultipleSelection &&
                          widget.dropDown.showDoneOnHeader,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: widget.dropDown.submitButtonChild ??
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(
                                      color: Colors.transparent, width: 0)),
                              color: Colors.green.shade300,
                              onPressed: () {
                                List<SelectedListItem> selectedList = widget
                                    .dropDown.data
                                    .where((element) =>
                                        element.isSelected ?? false)
                                    .toList();
                                List<SelectedListItem> selectedNameList = [];

                                for (var element in selectedList) {
                                  selectedNameList.add(element);
                                }

                                widget.dropDown.selectedItems
                                    ?.call(selectedNameList);
                                _onUnFocusKeyboardAndPop();
                              },
                              child: const Text('Done'),
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              /// A [TextField] that displays a list of suggestions as the user types with clear button.
              Visibility(
                visible: widget.dropDown.isSearchVisible,
                child: widget.dropDown.searchWidget ??
                    AppTextField(
                      dropDown: widget.dropDown,
                      onTextChanged: _buildSearchList,
                      searchHintText: widget.dropDown.searchHintText,
                    ),
              ),

              /// Listview (list of data with check box for multiple selection & on tile tap single selection)
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: mainList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    bool isSelected = mainList[index].isSelected ?? false;
                    return InkWell(
                      child: Container(
                        color: widget.dropDown.dropDownBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (widget.dropDown.enableMultipleSelection) {
                                  mainList[index].isSelected = !isSelected;
                                } else {
                                  for (var element in mainList) {
                                    element.isSelected = false;
                                  }
                                  mainList[index].isSelected = !isSelected;
                                  if (!widget.noCloseDialog!) {
                                    _onUnFocusKeyboardAndPop();
                                  }
                                }
                                widget.dropDown.selectedItems
                                    ?.call([mainList[index]]);
                              });
                            },
                            child: ListTile(
                              title: widget.dropDown.listItemBuilder
                                      ?.call(index) ??
                                  // (widget.dropDown.textMarquee ?
                                  // Marquee(
                                  //   text: mainList[index].name,
                                  //   style:
                                  //   (mainList[index].isSelected?? false) ?
                                  //   widget.dropDown.textStyleSelected?? widget.dropDown.textStyle?? myTextStyle :
                                  //   widget.dropDown.textStyle?? myTextStyle,
                                  //   scrollAxis: Axis.horizontal,
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   blankSpace: 20.0,
                                  //   velocity: 100.0,
                                  //   pauseAfterRound: Duration(seconds: 1),
                                  //   startPadding: 10.0,
                                  //   accelerationDuration: Duration(seconds: 1),
                                  //   accelerationCurve: Curves.linear,
                                  //   decelerationDuration: Duration(milliseconds: 500),
                                  //   decelerationCurve: Curves.easeOut,
                                  // )      ,
                                  // :
                                  Text(
                                    mainList[index].name,
                                    style: (mainList[index].isSelected ?? false)
                                        ? widget.dropDown.textStyleSelected ??
                                            widget.dropDown.textStyle ??
                                            myTextStyle
                                        : widget.dropDown.textStyle ??
                                            myTextStyle,
                                  ),
                              // ),
                              trailing: widget.dropDown.enableMultipleSelection
                                  ? isSelected
                                      ? Icon(
                                          Icons.check_box,
                                          color:
                                              widget.dropDown.selectedColor ??
                                                  widget.dropDown.color ??
                                                  myControlColor,
                                        )
                                      : Icon(Icons.check_box_outline_blank,
                                          color: widget.dropDown.color ??
                                              myControlColor)
                                  : widget.dropDown.showRadioButton
                                      ? isSelected
                                          ? Icon(
                                              Icons.radio_button_checked,
                                              color: widget
                                                      .dropDown.selectedColor ??
                                                  widget.dropDown.color ??
                                                  myControlColor,
                                            )
                                          : Icon(Icons.radio_button_off,
                                              color: widget.dropDown.color ??
                                                  myControlColor)
                                      : const SizedBox(
                                          height: 0.0,
                                          width: 0.0,
                                        ),
                            ),
                          ),
                        ),
                      ),
                      onTap: widget.dropDown.enableMultipleSelection
                          ? null
                          : () {
                              setState(() {
                                for (var element in mainList) {
                                  element.isSelected = false;
                                }
                                mainList[index].isSelected = !isSelected;
                              });
                              widget.dropDown.selectedItems
                                  ?.call([mainList[index]]);
                              _onUnFocusKeyboardAndPop();
                            },
                    );
                  },
                ),
              ),

              /// Controller Button
              Visibility(
                visible:
                    // widget.dropDown.enableMultipleSelection &&
                    !widget.dropDown.showDoneOnHeader,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: widget.dropDown.buttonPadding ??
                        const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        widget.dropDown.cancelButtonChild != null
                            ? Expanded(
                                flex: 1,
                                child: widget.dropDown.cancelButtonChild!,
                              )
                            : const SizedBox(),
                        Expanded(
                          flex: widget.dropDown.submitButtonFlex ?? 2,
                          child: widget.dropDown.submitButtonChild ??
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: Colors.transparent, width: 0)),
                                color: Colors.green.shade500,
                                onPressed: () {
                                  List<SelectedListItem> selectedList = widget
                                      .dropDown.data
                                      .where((element) =>
                                          element.isSelected ?? false)
                                      .toList();
                                  List<SelectedListItem> selectedNameList = [];

                                  for (var element in selectedList) {
                                    selectedNameList.add(element);
                                  }

                                  widget.dropDown.selectedItems
                                      ?.call(selectedNameList);
                                  _onUnFocusKeyboardAndPop();
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

  /// This helps when search enabled & show the filtered data in list.
  _buildSearchList(String userSearchTerm) {
    final results = widget.dropDown.data
        .where((element) =>
            element.name.toLowerCase().contains(userSearchTerm.toLowerCase()))
        .toList();
    if (userSearchTerm.isEmpty) {
      mainList = widget.dropDown.data;
    } else {
      mainList = results;
    }
    setState(() {});
  }

  /// This helps to UnFocus the keyboard & pop from the bottom sheet.
  _onUnFocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _setSearchWidgetListener() {
    TextFormField? _searchField = widget.dropDown.searchWidget;
    _searchField?.controller?.addListener(() {
      _buildSearchList(_searchField.controller?.text ?? '');
    });
  }
}

