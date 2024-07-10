import 'package:findovio/consts.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ContainerWithTextAndIcon extends StatefulWidget {
  final String selectedCategory;
  final String filterOption;
  final String? optionalSubmittedText;

  const ContainerWithTextAndIcon({
    Key? key,
    required this.filterOption,
    required this.selectedCategory,
    this.optionalSubmittedText,
  }) : super(key: key);

  @override
  State<ContainerWithTextAndIcon> createState() =>
      _ContainerWithTextAndIconState();
}

class _ContainerWithTextAndIconState extends State<ContainerWithTextAndIcon> {
  String? boxTitle;
  late Color bgColor;
  late Color borderColor;
  late Color textColor;
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    setView();
  }

  void setView() {
    setState(() {
      bgColor = boxTitle == 'wybierz'
          ? const Color.fromARGB(255, 243, 243, 243)
          : Colors.white;
      borderColor = boxTitle != 'wybierz' ? Colors.orange : Colors.transparent;
      textColor =
          boxTitle != null && boxTitle!.isNotEmpty ? Colors.black : Colors.grey;
      isSelected = boxTitle != 'wybierz' ? true : false;
    });
  }

  void setText(
      String filterOption, DiscoverPageFilterProvider userDataProvider) {
    switch (filterOption) {
      case 'dla kogo':
        if (widget.filterOption == filterOption) {
          setState(() {
            boxTitle = userDataProvider.userData.gender == ''
                ? 'wybierz'
                : userDataProvider.userData.gender;
            setView();
          });
        }
        break;
      case 'kategoria':
        if (widget.filterOption == filterOption) {
          setState(() {
            boxTitle = userDataProvider.userData.category == ''
                ? 'wybierz'
                : userDataProvider.userData.category;
            setView();
          });
        }
      case 'lokalizacja':
        if (widget.filterOption == filterOption) {
          setState(() {
            boxTitle = userDataProvider.userData.city == ''
                ? 'wybierz'
                : userDataProvider.userData.city;
            setView();
          });
        }
      default:
        boxTitle = 'wybierz';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    DiscoverPageFilterProvider userDataProvider =
        Provider.of<DiscoverPageFilterProvider>(context);
    setText(widget.filterOption, userDataProvider);
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: Text(widget.filterOption,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          ConstsWidgets.gapH8,
          Container(
            height: MediaQuery.sizeOf(context).height * 0.05,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange,
                  offset: isSelected ? const Offset(0, 1) : const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Text(
                  boxTitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                if (boxTitle == 'wybierz')
                  Icon(
                    MdiIcons.chevronRight,
                    color: Colors.grey,
                  ),
                if (boxTitle != 'wybierz')
                  GestureDetector(
                    child: Icon(
                      MdiIcons.delete,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        if (boxTitle == userDataProvider.userData.city) {
                          userDataProvider.setCity('');
                        } else if (boxTitle ==
                            userDataProvider.userData.gender) {
                          userDataProvider.setForWhom('');
                        } else if (boxTitle ==
                            userDataProvider.userData.category) {
                          userDataProvider.setCategory('');
                        }
                        boxTitle = 'wybierz';
                        setView();
                      });
                    },
                  ),
              ],
            ),
          ),
          ConstsWidgets.gapH8,
        ],
      ),
    );
  }
}
