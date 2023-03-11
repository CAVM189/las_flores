import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String title;
  final Widget content;

  const Accordion({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(children: [
          Expanded(
              flex: 6,
              child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  title: Container(
                      color: Colors.red,
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                          child: Text(widget.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)))))),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 8),
                  color: Colors.red,
                  child: IconButton(
                    icon: Icon(
                      _showContent
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        _showContent = !_showContent;
                      });
                    },
                  ))),
        ]),
        _showContent
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(child: widget.content),
              )
            : Container()
      ]),
    );
  }
}
