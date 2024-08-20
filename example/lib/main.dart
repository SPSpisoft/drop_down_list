import 'package:flutter/material.dart';
import 'package:sps_drop_down_list/drop_down_list.dart';
import 'package:sps_drop_down_list/model/selected_list_item.dart';

import 'constants.dart';

void main() {
  runApp(
    const MaterialApp(
      title: kTitle,
      home: DropDownListExample(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class DropDownListExample extends StatefulWidget {
  const DropDownListExample({
    Key? key,
  }) : super(key: key);

  @override
  _DropDownListExampleState createState() => _DropDownListExampleState();
}

class _DropDownListExampleState extends State<DropDownListExample> {
  /// This is list of city which will pass to the drop down.
  final List<SelectedListItem> _listOfCities = [
    SelectedListItem(
      name: kTokyo,
      value: "TYO",
      isSelected: false,
    ),
    SelectedListItem(
      name: kNewYork,
      value: "NY",
      isSelected: false,
    ),
    SelectedListItem(
      name: kLondon,
      value: "LDN",
      isSelected: false,
    ),
    SelectedListItem(name: kParis),
    SelectedListItem(name: kMadrid),
    SelectedListItem(name: kDubai),
    SelectedListItem(name: kRome),
    SelectedListItem(name: kBarcelona),
    SelectedListItem(name: kCologne),
    SelectedListItem(name: kMonteCarlo),
    SelectedListItem(name: kPuebla),
    SelectedListItem(name: kFlorence),
  ];

  /// This is register text field controllers.
  final TextEditingController _fullNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController _cityTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _fullNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _phoneNumberTextEditingController.dispose();
    _cityTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _mainBody(),
      ),
    );
  }

  /// This is Main Body widget.
  Widget _mainBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(
          //   height: 30.0,
          // ),
          // const Text(
          //   kRegister,
          //   style: TextStyle(
          //     fontSize: 34.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(
          //   height: 15.0,
          // ),
          // AppTextField(
          //   textEditingController: _fullNameTextEditingController,
          //   title: kFullName,
          //   hint: kEnterYourName,
          //   isCitySelected: false,
          // ),
          // AppTextField(
          //   textEditingController: _emailTextEditingController,
          //   title: kEmail,
          //   hint: kEnterYourEmail,
          //   isCitySelected: false,
          // ),
          // AppTextField(
          //   textEditingController: _phoneNumberTextEditingController,
          //   title: kPhoneNumber,
          //   hint: kEnterYourPhoneNumber,
          //   isCitySelected: false,
          // ),
          AppTextField(
            textEditingController: _cityTextEditingController,
            title: kCity,
            hint: kChooseYourCity,
            isCitySelected: true,
            cities: _listOfCities,
          ),
          // AppTextField(
          //   textEditingController: _passwordTextEditingController,
          //   title: kPassword,
          //   hint: kAddYourPassword,
          //   isCitySelected: false,
          // ),
          const SizedBox(
            height: 15.0,
          ),
          _AppElevatedButton(),
        ],
      ),
    );
  }
}

/// This is Common App textfiled class.
class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String hint;
  final bool isCitySelected;
  final List<SelectedListItem>? cities;

  const AppTextField({
    required this.textEditingController,
    required this.title,
    required this.hint,
    required this.isCitySelected,
    this.cities,
    Key? key,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  int last = -1;

  List<double> myList = [ 2.5, 5.6, 4.0 ];

  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {

    DropDownNumState(
      DropDownNumerical(
        isDismissible: true,
        valuesList: myList,
        minValue: -15.0,
        maxValue: 20.0,
        decimalPlace: 1,
        description: "cm",
        // inputDescriptionWidget: Text("(-10 ... +10)", style: TextStyle(fontSize: 14),),
        margin: EdgeInsets.only(top: MediaQuery.of(context).orientation == Orientation.landscape ? 60 : 0),
        fromSide: MediaQuery.of(context).orientation == Orientation.landscape,
        dropDownBackgroundColor: Colors.white,
        bottomSheetTitle: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            kCities,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        cancelButtonChild: const Text("Cancel", style: TextStyle(color: Colors.white)),
        textStyle: const TextStyle(color: Colors.red),
        noCloseDialog: true,
        // listItemBuilder: (index) => Text(widget.cities![index].name),
      ),
    ).showModal(context);

    // DropDownState(
    //   DropDown(
    //     isDismissible: true,
    //     isSearchVisible: false,
    //     // inputDescriptionWidget: Text("(-10 ... +10)", style: TextStyle(fontSize: 14),),
    //     margin: EdgeInsets.only(top: MediaQuery.of(context).orientation == Orientation.landscape ? 60 : 0),
    //     fromSide: MediaQuery.of(context).orientation == Orientation.landscape,
    //     dropDownBackgroundColor: Colors.white,
    //     bottomSheetTitle: const Padding(
    //       padding: EdgeInsets.all(15.0),
    //       child: Text(
    //         kCities,
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20.0,
    //         ),
    //       ),
    //     ),
    //     // showRadioButton: false,
    //     // submitButtonChild:  Center(
    //     //   child: Text(
    //     //     'Done000',
    //     //     style: TextStyle(
    //     //       fontSize: 16,
    //     //       fontWeight: FontWeight.bold,
    //     //     ),
    //     //   ),
    //     // ),
    //     cancelButtonChild: const Text("Cancel", style: TextStyle(color: Colors.white)),
    //     data: widget.cities ?? [],
    //
    //     // listItemBuilder: (index) => InkWell(
    //     //   onTap: () {
    //     //     last = index;
    //     //     FocusScope.of(context).unfocus();
    //     //     Navigator.of(context).pop();
    //     //   },
    //     //     child: Text(widget.cities![index].name , style: TextStyle(color: (index == last) ? Colors.red : Colors.black87))),
    //     selectedItems: (List<dynamic> selectedList) {
    //       List<String> list = [];
    //       for (var item in selectedList) {
    //         if (item is SelectedListItem) {
    //           list.add(item.name);
    //         }
    //       }
    //       showSnackBar(list.toString());
    //     },
    //     textStyle: const TextStyle(color: Colors.red),
    //     textStyleSelected: const TextStyle(color: Colors.blue),
    //     selectedColor: Colors.blue,
    //     color: Colors.red,
    //     enableMultipleSelection: true,
    //     noCloseDialog: true,
    //     // listItemBuilder: (index) => Text(widget.cities![index].name),
    //   ),
    // ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          // readOnly: true,
          // showCursor: true,
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          onTap: widget.isCitySelected
              ? () {
                  FocusScope.of(context).unfocus();
                  onTextFieldTap();
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            contentPadding:
                const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
            hintText: widget.hint,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}

/// This is common class for 'REGISTER' elevated button.
class _AppElevatedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text(
          kREGISTER,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(70, 76, 222, 1),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
