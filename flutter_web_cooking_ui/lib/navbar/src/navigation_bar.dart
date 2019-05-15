import 'package:flutter/material.dart';

import 'navigation_bar_item.dart';

class TitledBottomNavigationBar extends StatefulWidget {
  final bool reverse;
  final Curve curve;
  final Color activeColor;
  final Color inactiveColor;
  final Color indicatorColor;
  final ValueChanged<int> onTap;
  final List<TitledNavigationBarItem> items;

  TitledBottomNavigationBar({
    Key key,
    this.reverse = false,
    this.curve = Curves.linear,
    @required this.onTap,
    @required this.items,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
  }) : super(key: key) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    assert(onTap != null);
  }

  @override
  State createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  static const double BAR_HEIGHT = 60;
  static const double INDICATOR_HEIGHT = 2;

  bool get reverse => widget.reverse;
  Curve get curve => widget.curve;
  List<TitledNavigationBarItem> get items => widget.items;

  double width = 0;
  int selectedIndex = 0;
  double indicatorAlignX = 0;

  Color activeColor;
  Duration duration = Duration(milliseconds: 250);

  @override
  void initState() {
    // select a default item
    _select(selectedIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    activeColor = widget.activeColor ?? Theme.of(context).indicatorColor;

    return Container(
      key: widget.key,
      height: BAR_HEIGHT,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 2),
        ],
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: INDICATOR_HEIGHT,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                var index = items.indexOf(item);
                return GestureDetector(
                  onTap: () => setState(() {
                        _select(index);
                      }),
                  child: _buildItemWidget(item, index == selectedIndex),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: width,
            child: AnimatedAlign(
              alignment: Alignment(indicatorAlignX, 0),
              curve: curve,
              duration: duration,
              child: Container(
                color: widget.indicatorColor ?? activeColor,
                width: width / items.length,
                height: INDICATOR_HEIGHT,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _select(int index) {
    selectedIndex = index;
    widget.onTap(selectedIndex);
    indicatorAlignX = -1 + (2 / (items.length - 1) * index);
  }

  Widget _buildIcon(TitledNavigationBarItem item) {
    return Icon(
      item.icon,
      color: reverse ? widget.inactiveColor : activeColor,
      size: 28,
    );
  }

  Widget _buildText(TitledNavigationBarItem item) {
    return Text(
      item.title,
      style: TextStyle(
        color: reverse ? activeColor : widget.inactiveColor,
        fontFamily: 'Bold',
        fontSize: 14,
      ),
    );
  }

  Widget _buildItemWidget(TitledNavigationBarItem item, bool isSelected) {
    return Container(
      color: item.backgroundColor,
      height: BAR_HEIGHT,
      width: width / items.length,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: isSelected ? 0.0 : 1.0,
            duration: duration,
            curve: curve,
            child: reverse ? _buildIcon(item) : _buildText(item),
          ),
          AnimatedAlign(
            duration: duration,
            alignment: isSelected ? Alignment.center : Alignment(0, 2.6),
            child: reverse ? _buildText(item) : _buildIcon(item),
          ),
        ],
      ),
    );
  }
}