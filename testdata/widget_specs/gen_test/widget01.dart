// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// THIS IS A GENERATED FILE. DO NOT MODIFY MANUALLY.

import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:gallery/src/widget_specs/utils.dart';
import 'package:widget_specs/widget_specs.dart';
import 'package:mock_package/exported.dart';

/// Name of the widget.
const String kName = 'Widget01';

/// [WidgetSpecs] of this widget.
final WidgetSpecs kSpecs = new WidgetSpecs(
  packageName: 'mock_package',
  name: 'Widget01',
  path: 'exported.dart',
  pathFromFuchsiaRoot:
      'apps/modules/testdata/widget_specs/extract_test/mock_package/lib/src/sample_widgets.dart',
  doc: '''
This is a public [StatefulWidget].''',
  exampleWidth: 200.0,
  exampleHeight: 300.0,
  hasSizeParam: false,
);

/// Generated state object for this widget.
class _GeneratedWidget01State extends GeneratedState {
  int intParam;
  bool boolParam;
  double doubleParam;
  String stringParam;
  dynamic noExampleValueParam;

  _GeneratedWidget01State(SetStateFunc setState) : super(setState);

  @override
  void initState(Config config) {
    intParam = 42;
    boolParam = true;
    doubleParam = 10.0;
    stringParam = '''example string value!''';
    noExampleValueParam = null;
  }

  @override
  Widget buildWidget(
    BuildContext context,
    Key key,
    double width,
    double height,
  ) {
    return new Widget01(
      key: key,
      intParam: this.intParam,
      boolParam: this.boolParam,
      doubleParam: this.doubleParam,
      stringParam: this.stringParam,
      noExampleValueParam: this.noExampleValueParam,
    );
  }

  @override
  List<TableRow> buildParameterTableRows(BuildContext context) {
    return <TableRow>[
      buildTableRow(
        context,
        <Widget>[
          new Text('int'),
          new Text('intParam'),
          new TextField(
            initialValue: new InputValue(text: (intParam ?? 0).toString()),
            isDense: true,
            keyboardType: TextInputType.number,
            onChanged: (InputValue value) {
              try {
                int intValue = int.parse(value.text);
                setState(() {
                  intParam = intValue;
                });
              } catch (e) {
                // Do nothing.
              }
            },
          ),
        ],
      ),
      buildTableRow(
        context,
        <Widget>[
          new Text('bool'),
          new Text('boolParam'),
          new Row(
            children: <Widget>[
              new Switch(
                value: boolParam ?? false,
                onChanged: (bool value) {
                  setState(() {
                    boolParam = value;
                  });
                },
              ),
              new Expanded(child: new Container()),
            ],
          ),
        ],
      ),
      buildTableRow(
        context,
        <Widget>[
          new Text('double'),
          new Text('doubleParam'),
          new TextField(
            initialValue: new InputValue(text: (doubleParam ?? 0.0).toString()),
            isDense: true,
            keyboardType: TextInputType.number,
            onChanged: (InputValue value) {
              try {
                double doubleValue = double.parse(value.text);
                setState(() {
                  doubleParam = doubleValue;
                });
              } catch (e) {
                // Do nothing.
              }
            },
          ),
        ],
      ),
      buildTableRow(
        context,
        <Widget>[
          new Text('String'),
          new Text('stringParam'),
          new TextField(
            initialValue: new InputValue(text: stringParam ?? ''),
            isDense: true,
            onChanged: (InputValue value) {
              setState(() {
                stringParam = value.text;
              });
            },
          ),
        ],
      ),
      buildTableRow(
        context,
        <Widget>[
          new Text('dynamic'),
          new Text('noExampleValueParam'),
          new InfoText('null (this type of parameter is not supported yet)'),
        ],
      ),
    ];
  }
}

/// State builder for this widget.
final GeneratedStateBuilder kBuilder =
    (SetStateFunc setState) => new _GeneratedWidget01State(setState);
