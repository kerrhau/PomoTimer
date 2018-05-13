import 'package:flutter/material.dart';
import 'package:pomotimer/pages/timer_page.dart';

class IntervalTimeForm extends StatefulWidget {
  @override
  createState() => new IntervalTimeFormState();
}

class IntervalData {
  int sprint = 0;
  int cooldown = 0;
}

class IntervalTimeFormState extends State<IntervalTimeForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  IntervalData _data = new IntervalData();

  @override
  Widget build(BuildContext context) {
    // Container for grouping multiple TextField widgets
    return new Form(
      key: _formKey,
      // A widget used for displaying children in a vertical manner
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Input Box
          new TextFormField(
              // Label above the input box
              decoration:
                  new InputDecoration(labelText: "Work Interval (Seconds)"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) return 'Please enter a number';
              },
              onSaved: (String value) {
                this._data.sprint = int.parse(value);
              }),
          new TextFormField(
              decoration:
                  new InputDecoration(labelText: "Cooldown Interval (Seconds)"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) return 'Please enter a number';
              },
              onSaved: (String value) {
                this._data.cooldown = int.parse(value);
              }),
          new Center(
            child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new TimerPage(_data));
                      Navigator.of(context).push(route);
                    }
                  },
                  child: new Text('Begin')),
            ),
          ),
        ],
      ),
    );
  }
}
