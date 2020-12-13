// Copyright 2020 Godwin Asuquo. All rights reserved.
//
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library editable;

import 'package:flutter/material.dart';
import 'commons/helpers.dart';
import 'widgets/table_body.dart';
import 'widgets/table_header.dart';

//TODO: Known ISSUE :: Initial Column array: same column names result in output of the last column with that name, ignoring earlier columns.
//TODO: Known ISSUE :: When column names are editable : Same Column Names result in output of saved rows with only the last changed value in last changed column, ignoring other columns.
//TODO: Known ISSUE :: If no functions are given, it throws an error when the save button is pressed.
//TODO: add a validator to input in editable text fields.
//TODO: Must check that headers have unique keys: different keys in the list. Or else it silently omits data when saving rows.
//TODO: Must check that functions are given for the intendend actions.

class Editable extends StatefulWidget {
  /// Builds an editable table using predefined number of rows and columns,
  /// or using data provided for the body and header of the table.
  ///
  /// If no data is provided for [row] and [column],
  /// [rowCount] and [columnCount] properties must be set, so the widget
  /// will generate an empty table with a pre-set size.
  ///
  /// the column names can be editable by setting [editableColumnNames] to [true].
  ///
  /// it is useful for rendering data from an API or to create a spreadsheet-like
  /// data table
  ///
  /// example:
  ///
  /// ```dart
  ///  Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: <Widget>[
  ///           Expanded(
  ///           flex: 1,
  ///           child: EdiTable(
  ///               showCreateButton: true,
  ///               tdStyle: TextStyle(fontSize: 20),
  ///               showSaveIcon: false,
  ///               borderColor: Colors.lightBlue,
  ///               columnCount: 4,
  ///               rowCount: 8,
  ///               editableColumnNames: true,
  ///              ),
  ///           ).
  ///         ]
  ///       ),
  ///   );
  /// }
  /// ```
  Editable({
    Key key,
    this.columns,
    this.rows,
    this.columnRatio = 0.20,
    this.onSubmitted,
    this.onRowSaved,
    this.columnCount = 0,
    this.rowCount = 0,
    this.borderColor = Colors.grey,
    this.tdPaddingLeft = 8.0,
    this.tdPaddingTop = 0.0,
    this.tdPaddingRight = 0.0,
    this.tdPaddingBottom = 10.0,
    this.thPaddingLeft = 10.0,
    this.thPaddingTop = 0.0,
    this.thPaddingRight = 0.0,
    this.thPaddingBottom = 0.0,
    this.trHeight = 50.0,
    this.borderWidth = 0.5,
    this.thWeight = FontWeight.w600,
    this.thSize = 18,
    this.showSaveIcon = false,
    this.saveIcon = Icons.save,
    this.saveIconColor = Colors.black12,
    this.saveIconSize = 18,
    this.tdAlignment = TextAlign.start,
    this.tdStyle,
    this.showCreateButton = false,
    this.createButtonAlign = CrossAxisAlignment.start,
    this.createButtonIcon,
    this.createButtonColor,
    this.createButtonShape,
    this.createButtonLabel,
    this.stripeColor1 = Colors.white,
    this.stripeColor2 = Colors.black12,
    this.zebraStripe = false,
    this.editableColumnNames = false,
    this.onSubmitted_col,
    this.onColumnSaved,
  }) : super(key: key);

  /// A data set to create headers
  ///
  /// Can be null if blank columns are needed, else can be set as an editable by defining [editableColumnNames] as true and can be given values as an array of objects:
  /// Must be array of objects
  /// with the following keys: [title], [widthFactor] and [key]
  ///
  /// example:
  /// ```dart
  /// List cols = [
  ///   {"title":'Name', 'widthFactor': 0.1, 'key':'name'},
  ///   {"title":'Date', 'widthFactor': 0.2, 'key':'date'},
  ///   {"title":'Month', 'widthFactor': 0.1, 'key':'month'},
  ///   {"title":'Status', 'widthFactor': 0.1, 'key':'status'},
  /// ];
  /// ```
  /// [title] is the column heading
  ///
  /// [widthFactor] a custom size ratio of each column width, if not provided, defaults to  [columnRatio = 0.20]
  /// ```dart
  /// 'widthFactor': 0.1 //gives 10% of screen size to the column
  /// 'widthFactor': 0.2 //gives 20% of screen size to the column
  /// ```
  ///
  /// [key] an identifyer preferably a short string
  final List columns;

  /// A data set to create rows
  ///
  /// Can be null if empty rows are needed. else,
  /// Must be array of objects
  /// with keys matching [key] provided in the column array
  ///
  /// example:
  /// ```dart
  ///List rows = [
  ///          {"name": 'James Joe', "date":'23/09/2020',"month":'June',"status":'completed'},
  ///          {"name": 'Daniel Paul', "date":'12/4/2020',"month":'March',"status":'new'},
  ///        ];
  /// ```
  /// each objects DO NOT have to be positioned in same order as its column

  final List rows;

  /// Interger value of number of rows to be generated:
  ///
  /// Optional if row data is provided
  final int rowCount;

  /// Interger value of number of columns to be generated:
  ///
  /// Optional if column data is provided
  final int columnCount;

  /// aspect ration of each column,
  /// sets the ratio of the screen width occupied by each column
  /// it is set in fraction between 0 to 1.0
  /// 0.8 indicates 80 percent width per column
  final double columnRatio;

  /// Color of table border
  final Color borderColor;

  /// width of table borders
  final double borderWidth;

  /// Table data cell padding left
  final double tdPaddingLeft;

  /// Table data cell padding top
  final double tdPaddingTop;

  /// Table data cell padding right
  final double tdPaddingRight;

  /// Table data cell padding bottom
  final double tdPaddingBottom;

  /// Aligns the table data
  final TextAlign tdAlignment;

  /// Style the table data
  final TextStyle tdStyle;

  /// Table header cell padding left
  final double thPaddingLeft;

  /// Table header cell padding top
  final double thPaddingTop;

  /// Table header cell padding right
  final double thPaddingRight;

  /// Table header cell padding bottom
  final double thPaddingBottom;

  /// Table Row Height
  /// cannot be less than 40.0
  final double trHeight;

  /// Table headers fontweight
  final FontWeight thWeight;

  /// Table headers fontSize
  final double thSize;

  /// Toogles the save button,
  /// if [true] displays an icon to save rows,
  /// adds an addition column to the right
  final bool showSaveIcon;

  /// Icon for to save row data
  /// example:
  ///
  /// ```dart
  /// saveIcon : Icons.add
  /// ````
  final IconData saveIcon;

  /// Color for the save Icon
  final Color saveIconColor;

  /// Size for the saveIcon
  final double saveIconSize;

  /// displays a button that adds a new row onPressed
  final bool showCreateButton;

  /// Aligns the button for adding new rows
  final CrossAxisAlignment createButtonAlign;

  /// Icon displayed in the create new row button
  final Icon createButtonIcon;

  /// Color for the create new row button
  final Color createButtonColor;

  /// border shape of the create new row button
  ///
  /// ```dart
  /// createButtonShape: RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.circular(8)
  /// )
  /// ```
  final BoxShape createButtonShape;

  /// Label for the create new row button
  final Widget createButtonLabel;

  /// The first row alternate color, if stripe is set to true
  final Color stripeColor1;

  /// The Second row alternate color, if stripe is set to true
  final Color stripeColor2;

  /// enable zebra-striping, set to false by default
  /// if enabled, you can style the colors [stripeColor1] and [stripeColor2]
  final bool zebraStripe;

  /// enable editable header
  final bool editableColumnNames;

  ///[onSubmitted] callback is triggered when the enter button is pressed on a table data cell
  /// it returns a value of the cell data
  final ValueChanged<String> onSubmitted;

  /// [onRowSaved] callback is triggered when a [saveButton] is pressed.
  /// returns only values if row is edited, otherwise returns a string ['no edit']
  final ValueChanged<dynamic> onRowSaved;

  ///[onSubmitted_col] callback is triggered when the enter button is pressed on a table column cell
  /// it returns a value of the cell data
  final ValueChanged<String> onSubmitted_col;

  /// [onColumnSaved] callback is triggered when a [saveButton] is pressed.
  /// returns only values if column name is edited, otherwise returns a string ['no edit']
  final ValueChanged<dynamic>
      onColumnSaved; //TODO: apply saving of column names

  @override
  EditableState createState() => EditableState(
      rows: this.rows,
      columns: this.columns,
      rowCount: this.rowCount,
      columnCount: this.columnCount);
}

class EditableState extends State<Editable> {
  List rows, columns;
  int columnCount, rowCount;

  EditableState({this.rows, this.columns, this.columnCount, this.rowCount});

  ///Get all edited rows
  List get editedRows => _editedRows;

  ///Get all edited columns
  List get editedHeader => _editedHeader;

  ///Create a row after the last row
  createRow() => addOneRow(columns, rows);

  /// Temporarily holds all edited rows
  List _editedRows = [];

  /// Temporarily holds all edited column names
  List _editedHeader = [];

  @override
  Widget build(BuildContext context) {
    /// initial Setup of columns and row, sets count of column and row
    rowCount = rows == null || rows.isEmpty ? widget.rowCount : rows.length;
    columnCount =
        columns == null || columns.isEmpty ? columnCount : columns.length;
    columns = columns ?? columnBlueprint(columnCount, columns);
    rows = rows ?? rowBlueprint(rowCount, columns, rows);

    /// Builds saveIcon widget
    Widget _saveIcon(index) {
      return Flexible(
        fit: FlexFit.loose,
        child: Visibility(
          visible: widget.showSaveIcon,
          child: IconButton(
            padding: EdgeInsets.only(right: widget.tdPaddingRight),
            hoverColor: Colors.transparent,
            icon: Icon(
              widget.saveIcon,
              color: widget.saveIconColor,
              size: widget.saveIconSize,
            ),
            onPressed: () {
              int rowIndex = editedRows.indexWhere(
                  (element) => element['row'] == index ? true : false);
              if (rowIndex != -1) {
                widget.onRowSaved(editedRows[rowIndex]);
                if (widget.editableColumnNames) {
                  editedHeader.isNotEmpty ? widget.onColumnSaved(editedHeader) : widget.onColumnSaved('no edit');
                }
              } else {
                widget.onRowSaved('no edit');
                if (widget.editableColumnNames) {
                  editedHeader.isNotEmpty ? widget.onColumnSaved(editedHeader) : widget.onColumnSaved('no edit');
                }
              }
            },
          ),
        ),
      );
    }

    /// Generates table columns
    List<Widget> _tableHeaders() {
      return List<Widget>.generate(columnCount + 1, (index) {
        return columnCount + 1 == (index + 1)
            ? iconColumn(widget.showSaveIcon, widget.thPaddingTop,
                widget.thPaddingBottom)
            : widget.editableColumnNames //Chooses the appropriate widget for the column titles: editable or not:
                ? THeader_editable(
                    widthRatio: columns[index]['widthFactor'] != null
                        ? columns[index]['widthFactor'].toDouble()
                        : widget.columnRatio,
                    thPaddingLeft: widget.thPaddingLeft,
                    thPaddingTop: widget.thPaddingTop,
                    thPaddingBottom: widget.thPaddingBottom,
                    thPaddingRight: widget.thPaddingRight,
                    headers: columns,
                    thWeight: widget.thWeight,
                    thSize: widget.thSize,
                    index: index,
                    onSubmitted_col: widget.onSubmitted_col,
                    onChanged_col: (value) {
                      //TODO: Add alarm informing that column's keys must have different names!
                      //TODO:  note that is due to the standard used in the widget that the saved row must map a key with a value.
                      //TODO: !!! if the original key as two identical values, the widget breaks when saving...
                      ///checks if column has been edited previously
                      var result = editedHeader.indexWhere((element) {
                        return element['index'] != index ? false : true;
                      });

                      ///adds a new edited data to a temporary holder
                      var temp;
                      if (result != -1) {
                        temp = editedHeader[result]['key']; //case where the key matches the title
                        editedHeader[result]['title'] = value;
                        editedHeader[result]['key'] = value; //case where the key matches the title
                      } else {
                        temp = {};
                        temp['index'] = index;
                        temp['title'] = value;
                        temp['key'] = value; //case where the key matches the title
                        //temp['key'] = columns[index]['index'];//case where the key matches the index
                        // Getting original key
                        temp["origKey"] = columns[index]['key']; //case where the key matches the title//original key for easy mapping
                        editedHeader.add(temp);
                        temp = temp["origKey"]; //case where the key matches the title//necessary to change edited rows
                      }
                      //case where the key matches the title
                      if (editedRows.isNotEmpty) {
                        editedRows.forEach((e) {
                          if (e.keys.contains(temp)) {
                            var tempValue = e[temp];
                            e.remove(temp);
                            e[value] = tempValue;
                          }
                        });
                      }//End of case where the key matches the title
                    },
                  )
                : THeader(
                    widthRatio: columns[index]['widthFactor'] != null
                        ? columns[index]['widthFactor'].toDouble()
                        : widget.columnRatio,
                    thPaddingLeft: widget.thPaddingLeft,
                    thPaddingTop: widget.thPaddingTop,
                    thPaddingBottom: widget.thPaddingBottom,
                    thPaddingRight: widget.thPaddingRight,
                    headers: columns,
                    thWeight: widget.thWeight,
                    thSize: widget.thSize,
                    index: index,
                  );
      });
    }

    /// Generates table rows
    List<Widget> _tableRows() {
      return List<Widget>.generate(rowCount, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columnCount + 1, (rowIndex) {
            var ckeys =
                []; //TODO: change code to identify the respective column without need to copy the array of keys
            var cwidths = [];
            columns.forEach((e) {
              ckeys.add(e['key']);
              cwidths.add(e['widthFactor'] ?? widget.columnRatio);
            });
            var list = rows[index];
            return columnCount + 1 == (rowIndex + 1)
                ? _saveIcon(index)
                : RowBuilder(
                    index: index,
                    col: ckeys[rowIndex],
                    trHeight: widget.trHeight,
                    borderColor: widget.borderColor,
                    borderWidth: widget.borderWidth,
                    cellData: list[ckeys[rowIndex]],
                    tdPaddingLeft: widget.tdPaddingLeft,
                    tdPaddingTop: widget.tdPaddingTop,
                    tdPaddingBottom: widget.tdPaddingBottom,
                    tdPaddingRight: widget.tdPaddingRight,
                    tdAlignment: widget.tdAlignment,
                    tdStyle: widget.tdStyle,
                    onSubmitted: widget.onSubmitted,
                    widthRatio: cwidths[rowIndex].toDouble(),
                    zebraStripe: widget.zebraStripe,
                    stripeColor1: widget.stripeColor1,
                    stripeColor2: widget.stripeColor2,
                    onChanged: (value) {
                      ///checks if row has been edited previously
                      var result = editedRows.indexWhere((element) {
                        return element['row'] != index ? false : true;
                      });

                      ///checks if header has been edited previously
                      //case where the key matches the title
                      if (widget.editableColumnNames) {
                        ///checks if that column was a previously edited
                        var result_2 = editedHeader.indexWhere(
                            (element) => element['index'] == rowIndex);

                        ///gets new edited columns key
                        var tempColumnName;
                        var tempOrigColumnName;
                        if (result_2 != -1) {
                          tempColumnName = editedHeader[result_2]['key'];
                          tempOrigColumnName = editedHeader[result_2]['origKey'];
                        } else {
                          tempColumnName = columns[rowIndex]['key'];
                        }

                        ///adds a new edited data to a temporary holder
                        if (result != -1) {
                          //if there's the previous column name, removes it.
                          if (tempOrigColumnName != null) {
                            editedRows[result].remove(tempColumnName);
                          }
                          editedRows[result][tempColumnName] = value;
                        } else {
                          var temp = {};
                          temp['row'] = index;
                          temp[tempColumnName] = value;
                          editedRows.add(temp);
                        }
                      } else {
                        ///adds a new edited data to a temporary holder
                        if (result != -1) {
                          editedRows[result][ckeys[rowIndex]] = value;
                        } else {
                          var temp = {};
                          temp['row'] = index;
                          temp[ckeys[rowIndex]] = value;
                          editedRows.add(temp);
                        }
                      } // End of case where the key matches the title
                      ///adds a new edited data to a temporary holder
                      /*if (result != -1) {
                      editedRows[result][ckeys[rowIndex]] = value;
                      } else {
                      var temp = {};
                      temp['row'] = index;
                      temp[ckeys[rowIndex]] = value;
                      editedRows.add(temp);
                      }*/
                    },
                  );
          }),
        );
      });
    }

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              Column(crossAxisAlignment: widget.createButtonAlign, children: [
            //Table Header
            createButton(),

            Container(
              padding: EdgeInsets.only(bottom: widget.thPaddingBottom),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: widget.borderColor,
                          width: widget.borderWidth))),
              child: Row(
                  mainAxisSize: MainAxisSize.min, children: _tableHeaders()),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _tableRows(),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  /// Button for creating a new empty row
  Widget createButton() {
    return Visibility(
      visible: widget.showCreateButton,
      child: Padding(
        padding: EdgeInsets.only(left: 4.0, bottom: 4),
        child: InkWell(
          onTap: () {
            rows = addOneRow(columns, rows);
            rowCount++;
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: widget.createButtonColor ?? Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey.shade400)
              ],
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: widget.createButtonIcon ?? Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
