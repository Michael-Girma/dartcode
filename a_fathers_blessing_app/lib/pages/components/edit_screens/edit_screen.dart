import 'dart:ui';

import 'package:a_fathers_blessing_app/pages/components/edit_screens/tag_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditScreen extends StatefulWidget with WidgetsBindingObserver {
  final String title;
  final List<String> tags;
  final String initialBlessing;
  // final String reference;
  final Function onTagTap;
  final Function onTagSave;
  final Function onTextChange;
  // final TextEditingController referenceController;
  final Function onTitleChange;
  final Function onEditFocus;

  EditScreen(
      {this.title,
      this.tags,
      this.initialBlessing,
      this.onTagTap,
      this.onEditFocus,
      this.onTagSave,
      this.onTitleChange,
      // this.reference,
      // this.referenceController,
      this.onTextChange});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> with WidgetsBindingObserver {
  double _overlap = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FocusNode _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) widget.onEditFocus();
    });

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          _hideKeyboard();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: size.width,
                child: widget.onTitleChange == null
                    ? Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 27,
                            fontFamily: "OpenSans-Bold",
                            color: Theme.of(context).secondaryHeaderColor),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey)),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 15.0, left: 15.0),
                          child: TextFormField(
                              // minLines: 2,
                              onChanged: (String text) {
                                widget.onTitleChange(context, text);
                              },
                              // controller: widget.referenceController,
                              autocorrect: false,
                              readOnly: false,
                              initialValue: widget.title,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: "",
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontFamily: "Lato-Regular",
                                      fontSize: 20)),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "OpenSans-Regular",
                                  color: Theme.of(context).accentColor)),
                        ),
                      )),
            GestureDetector(
              onTap: () {
                _hideKeyboard();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 0, top: 10),
                child: Container(
                  width: size.width,
                  child: Text(
                    "BLESSING TEXT",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "OpenSans-Bold",
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _hideKeyboard();
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, _overlap),
                  child: GestureDetector(
                    onTap: () {
                      _hideKeyboard();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                        child: TextFormField(
                          onChanged: widget.onTextChange,
                          initialValue: widget.initialBlessing,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: 'Aleo-Regular',
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10, top: 10),
              child: GestureDetector(
                onTap: () {
                  _hideKeyboard();
                },
                child: Row(
                  children: [
                    Image.asset(
                        "assets/images/BlessingApp_Icons_24x24_Tag.png"),
                    SizedBox(width: 10),
                    Text(
                      "TAGS",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "OpenSans-Bold",
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                  ],
                ),
              ),
            ),
            TagTextField(
                tags: widget.tags, onTap: () => widget.onTagTap(context))
          ],
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      0,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints;
    if (overlap >= 20) {
      setState(() {
        _overlap = overlap - 10;
      });
    } else
      setState(() => _overlap = 10);
  }

  _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
