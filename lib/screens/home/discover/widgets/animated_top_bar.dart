import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:findovio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedTopBar extends StatefulWidget {
  bool showAppbar;
  final String? optionalCategry;
  final BuildContext context;

  AnimatedTopBar(
      {super.key,
      required this.showAppbar,
      required this.context,
      this.optionalCategry});

  @override
  State<AnimatedTopBar> createState() => _AnimatedTopBarState();
}

class _AnimatedTopBarState extends State<AnimatedTopBar> {
  void changeShowAppBarToFalse() {
    widget.showAppbar = false;
    setState(() {});
  }

  void changeShowAppBarToTrue() {
    widget.showAppbar = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimatedTopBarProvider>(builder: (context, myProvider, _) {
      return AnimatedContainer(
        height: myProvider.isTopBarVisible ? 36 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Container(
              padding: AppMargins.defaultMargin,
              child: Stack(
                children: [
                  //   Container(
                  //     margin: const EdgeInsets.only(top: 11.0),
                  //     clipBehavior: Clip.none,
                  //     width: MediaQuery.sizeOf(context).width * 0.2,
                  //     height: 13, // Adjust the height of the line as needed
                  //     color: Colors.orange,
                  //   ),
                  //   Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       if (widget.optionalCategry == '')
                  //         const TitleBar(text: 'co dziś znajdziemy?'),
                  //       if (widget.optionalCategry == '')
                  //         const Icon(Icons.search),
                  //     ],
                  //   ),
                  //   Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       TitleBarWithoutHeight(text: widget.optionalCategry ?? ''),
                  //       if (widget.optionalCategry != '')
                  //         const Icon(Icons.search),
                  //     ],
                  //   ),
                ],
              ),
            ),
            const SizedBox(height: 19),
          ],
        ),
      );
    });
  }
}
