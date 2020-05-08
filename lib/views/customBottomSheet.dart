import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/state_bloc.dart';
import '../model/car.dart';

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> with SingleTickerProviderStateMixin {
  Animation<RelativeRect> animation;
  AnimationController controller;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    double sheetTop = MediaQuery.of(context).size.height - 200;
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = RelativeRectTween(begin: RelativeRect.fromLTRB(0, sheetTop, 0, -400), end: RelativeRect.fromLTRB(0, 60, 0,0))
                .animate(CurvedAnimation(
                  parent: controller,
                  curve: Curves.,
                  reverseCurve: Curves.easeInOut,
                ));
  }

  forwardAnimation() {
    controller.forward();
    stateBloc.toggleAnimation();
  }

  reverseAnimation() {
    controller.reverse();
    stateBloc.toggleAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: animation,
      child: GestureDetector(
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          if (dragEndDetails.primaryVelocity < 0.0) forwardAnimation();
          else if (dragEndDetails.primaryVelocity > 0.0) reverseAnimation();
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 110;
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        color: Color(0xfff1f1f1),
      ),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                offerDetails(context, sheetItemHeight),
                specifications(context, sheetItemHeight),
                features(context, sheetItemHeight),
                SizedBox(height: 220),
              ],
            ),
          )
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), color: Color(0xffd9dbdb)
      ),
    );
  }

  specifications(BuildContext context, double sheetItemHeight) {
    var currentCar = Provider.of<Car>(context);
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Specifications",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCar.specifications.length,
              itemBuilder: (context, index) {
                return ListItem(
                  sheetItemHeight: sheetItemHeight,
                  mapVal: currentCar.specifications[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  features(BuildContext context, double sheetItemHeight) {
    var currentCar = Provider.of<Car>(context);
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Features",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCar.features.length,
              itemBuilder: (context, index) {
                return ListItem(
                  sheetItemHeight: sheetItemHeight,
                  mapVal: currentCar.features[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  offerDetails(BuildContext context, double sheetItemHeight) {
    var currentCar = Provider.of<Car>(context);
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Offer Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCar.offerDetails.length,
              itemBuilder: (context, index) {
                return ListItem(
                  sheetItemHeight: sheetItemHeight,
                  mapVal: currentCar.offerDetails[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double sheetItemHeight;
  final Map mapVal;

  ListItem({this.sheetItemHeight, this.mapVal});

  @override
  Widget build(BuildContext context) {
    var innerMap;
    bool isMap;

    if (mapVal.values.elementAt(0) is Map) {
      innerMap = mapVal.values.elementAt(0);
      isMap = true;
    } else {
      innerMap = mapVal;
      isMap = false;
    }

    return Container(
      margin: EdgeInsets.only(right: 20),
      width: sheetItemHeight,
      height: sheetItemHeight,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          mapVal.keys.elementAt(0),
          isMap
              ? Text(innerMap.keys.elementAt(0),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, letterSpacing: 1.2, fontSize: 11))
              : Container(),
          Text(
            innerMap.values.elementAt(0),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
