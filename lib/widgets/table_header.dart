import 'package:flutter/material.dart';

// @required is defined in the meta.dart package
import 'package:meta/meta.dart';

class THeader extends StatelessWidget {
  ///Builds elements for the table headers
  const THeader({
    Key key,
    @required this.thPaddingLeft,
    @required this.thPaddingTop,
    @required this.thPaddingBottom,
    @required this.thPaddingRight,
    @required List headers,
    @required FontWeight thWeight,
    @required double thSize,
    @required double widthRatio,
    @required int index,
  })  : _headers = headers,
        _thWeight = thWeight,
        _thSize = thSize,
        _index = index,
        _widthRatio = widthRatio,
        super(key: key);

  final double thPaddingLeft;
  final double thPaddingTop;
  final double thPaddingBottom;
  final double thPaddingRight;
  final List _headers;
  final FontWeight _thWeight;
  final double _thSize;
  final int _index;
  final double _widthRatio;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        width: width * _widthRatio,
        child: Padding(
          padding: EdgeInsets.only(
              left: thPaddingLeft,
              top: thPaddingTop,
              bottom: thPaddingBottom,
              right: thPaddingRight),
          child: Text(
            _headers != null || _headers.isNotEmpty
                ? _headers[_index]['title']
                : '',
            style: TextStyle(fontWeight: _thWeight, fontSize: _thSize),
          ),
        ),
      ),
    );
  }
}

class THeader_editable extends StatefulWidget {
  ///Builds elements for the table headers
  const THeader_editable({
    Key key,
    @required this.thPaddingLeft,
    @required this.thPaddingTop,
    @required this.thPaddingBottom,
    @required this.thPaddingRight,
    @required List headers,
    @required FontWeight thWeight,
    @required double thSize,
    @required double widthRatio,
    @required int index,
    @required this.onSubmitted_col,
    @required this.onChanged_col,
  })  : _headers = headers,
        _thWeight = thWeight,
        _thSize = thSize,
        _index = index,
        _widthRatio = widthRatio,
        super(key: key);

  final double thPaddingLeft;
  final double thPaddingTop;
  final double thPaddingBottom;
  final double thPaddingRight;
  final List _headers;
  final FontWeight _thWeight;
  final double _thSize;
  final int _index;
  final double _widthRatio;
  final ValueChanged<String> onSubmitted_col;
  final ValueChanged<String> onChanged_col;

  @override
  _THeader_editableState createState() => _THeader_editableState();
}

class _THeader_editableState extends State<THeader_editable> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        width: width * widget._widthRatio,
        child: Padding(
          padding: EdgeInsets.only(
              left: widget.thPaddingLeft,
              top: widget.thPaddingTop,
              bottom: widget.thPaddingBottom,
              right: widget.thPaddingRight),
          child: TextFormField(
            initialValue: widget._headers != null || widget._headers.isNotEmpty
                ? widget._headers[widget._index]['title']
                : '',
            onFieldSubmitted: widget.onSubmitted_col,
            onChanged: widget.onChanged_col,
            decoration: InputDecoration(
              hintText: "col ${widget._index}",
              border: InputBorder.none,
            ),
            style: TextStyle(
                fontWeight: widget._thWeight, fontSize: widget._thSize),
          ),
        ),
      ),
    );
  }
}
