import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Time Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Entry {
  Duration duration;
  String details;

  Entry(this.duration, {this.details});
}

class _MyHomePageState extends State<MyHomePage> {

  List<Entry> numbers = [];
  TextEditingController hourController = TextEditingController(text: "0");
  TextEditingController minuteController = TextEditingController(text: "0");
  TextEditingController detailsController = TextEditingController();
  String calculated = "00:00";
  ScrollController scrollController = new ScrollController();

  void onListUpdate(){
    Duration t = Duration();
    numbers.forEach((x) {
      t += x.duration;
    });
    setState(() {
      calculated = formatDuration(t);
    });
  }
  
  String formatDuration(Duration dur){
    var numberFormatter = NumberFormat("00");
    return "${numberFormatter.format(dur.inHours)}:${numberFormatter.format(dur.inMinutes.remainder(60))}";
  }

  Widget getDivider({double thickness: 1}){
    return OrientationBuilder(
      builder: (c, o){
        if(o == Orientation.portrait)
          return Divider(thickness: thickness);
        else
          return VerticalDivider(thickness: thickness);
      }
    );
  }

  void reset(){
    hourController.text = "0";
    minuteController.text = "0";
    detailsController.text = "";
  }

  List<Widget> mainWidget(){
    return <Widget>[
      Expanded(
          flex: 5,
          child: Container(
              child: ListView.builder(
                  itemCount: numbers.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(Uuid().v4()),
                      background: Container(color: Colors.red),
                      child: ListTile(
                        title: Center(child: Text(formatDuration(numbers[index].duration), style: TextStyle(fontSize: 30))),
                        subtitle: numbers[index].details == null ? null :
                          Center(child: Text(numbers[index].details))
                      ),
                      onDismissed: (dismissDirection){
                        setState(() {
                          numbers.removeAt(index);
                          onListUpdate();
                        });
                      },
                    );
                  }
              )
          )
      ),
      getDivider(thickness: 1),
      Expanded(
        flex: 5,
        child:
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: Colors.red,
                          height: 60,
                          minWidth: 60,
                          shape: CircleBorder(),
                          onPressed: (){
                            setState(() {
                              numbers.clear();
                              onListUpdate();
                            });
                          },
                          child: Icon(Icons.clear)
                      ),
                      FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text("$calculated", style: TextStyle(fontSize: 40))
                      )
                    ]
                ),
                Divider(thickness: 1),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 70,
                            child: Column(
                              children: [
                                ButtonTheme(
                                    minWidth: 20,
                                    height: 20,
                                    child: MaterialButton(
                                      child: Icon(Icons.arrow_drop_up),
                                      onPressed: () {
                                        int currentValue = int.tryParse(hourController.text);
                                        currentValue ??= 0;
                                        setState(() {
                                          if(currentValue<23){
                                            currentValue++;
                                            hourController.text = (currentValue).toString();
                                          }
                                        });
                                      },
                                    )
                                ),
                                TextField(
                                    style: TextStyle(
                                        fontSize: 40
                                    ),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder()
                                    ),
                                    textAlign: TextAlign.center,
                                    controller: hourController,
                                    inputFormatters: [
                                      DurationTextInputFormatter(23),
                                      LengthLimitingTextInputFormatter(2)
                                    ],
                                    keyboardType: TextInputType.number
                                ),
                                ButtonTheme(
                                    minWidth: 20,
                                    height: 20,
                                    child: MaterialButton(
                                      child: Icon(Icons.arrow_drop_down),
                                      onPressed: () {
                                        int currentValue = int.tryParse(hourController.text);
                                        currentValue ??= 0;
                                        setState(() {
                                          if(currentValue>0){
                                            currentValue--;
                                            hourController.text = (currentValue).toString();
                                          }
                                        });
                                      },
                                    )
                                )
                              ],
                            )
                        ),
                        SizedBox(width: 20,
                            child: Center(child: Text(":",
                                style: TextStyle(
                                  fontSize: 40,

                                )
                            ))
                        ),
                        SizedBox(width: 70,
                            child: Column(
                              children: [
                                ButtonTheme(
                                    minWidth: 20,
                                    height: 20,
                                    child: MaterialButton(
                                      child: Icon(Icons.arrow_drop_up),
                                      onPressed: () {
                                        int currentValue = int.tryParse(minuteController.text);
                                        currentValue ??= 0;
                                        setState(() {
                                          if(currentValue<59){
                                            currentValue++;
                                            minuteController.text = (currentValue).toString();
                                          }
                                        });
                                      },
                                    )
                                ),
                                TextField(
                                    style: TextStyle(
                                        fontSize: 40
                                    ),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder()
                                    ),
                                    textAlign: TextAlign.center,
                                    controller: minuteController,
                                    inputFormatters: [
                                      DurationTextInputFormatter(59),
                                      LengthLimitingTextInputFormatter(2)
                                    ],
                                    keyboardType: TextInputType.number
                                ),
                                ButtonTheme(
                                    minWidth: 20,
                                    height: 20,
                                    child: MaterialButton(
                                      child: Icon(Icons.arrow_drop_down),
                                      onPressed: () {
                                        int currentValue = int.tryParse(minuteController.text);
                                        currentValue ??= 0;
                                        setState(() {
                                          if(currentValue>0){
                                            currentValue--;
                                            minuteController.text = (currentValue).toString();
                                          }
                                        });
                                      },
                                    )
                                )
                              ],
                            )
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Descrizione"
                          ),
                          maxLines: null,
                          inputFormatters: [
                            LineLimitingTextInputFormatter(5)
                          ],
                          textAlign: TextAlign.left,
                          controller: detailsController,
                          keyboardType: TextInputType.multiline
                      ),
                    )
                  ],
                )
              ],
            )
          )
        )
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
          onPressed: (){
            setState(() {
              if(hourController.value.text == "0" && minuteController.value.text == "0")
                return;
              var dur = Duration(hours: int.parse(hourController.value.text), minutes: int.parse(minuteController.value.text));
              var details = detailsController.value.text == "" ? null : detailsController.value.text;
              numbers.add(Entry(dur, details: details));
              onListUpdate();
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
              reset();
            });
          }
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: Center(
            child: OrientationBuilder(
                builder: (c, o){
                  if(o == Orientation.portrait)
                    return Column(
                        children: mainWidget()
                    );
                  else
                    return Row(
                        children: mainWidget()
                    );
                }
            )
        )
      )
    );
  }
}

class DurationTextInputFormatter extends TextInputFormatter {

  int maxNum;

  DurationTextInputFormatter(this.maxNum) : super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int number = int.tryParse(newValue.text);
    try {
      if (number > maxNum) {
        number = maxNum;
      }
    } catch(FormatException){
      number = 0;
    }
    return TextEditingValue(
        text: number == 0 ? "" : number.toString(),
        selection: TextSelection.fromPosition(TextPosition(offset: number == 0 ? 0 : number.toString().length))
    );
  }
}

class LineLimitingTextInputFormatter extends TextInputFormatter {

  int maxLines;

  LineLimitingTextInputFormatter(this.maxLines) : super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.split('\n').length-2 > maxLines ? oldValue.text : newValue.text,
      selection: newValue.text.split('\n').length-2 > maxLines ? oldValue.selection : newValue.selection
    );
  }
}