import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class DisplayList extends StatefulWidget {
  final List list;
  final Function getTitle;
  final Function getSubtitle;
  final Function onTap;
  final Function filter;
  final String filterText;
  DisplayList(this.list, this.getTitle, this.getSubtitle, this.onTap, this.filter, this.filterText);

  @override
  _DisplayListState createState() => _DisplayListState();
}

class _DisplayListState extends State<DisplayList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {    
    return Container(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            onChanged: (String text){
              widget.filter(context, text);
            },
            style: TextStyle(
              fontSize: 18
            ),
            decoration:  new InputDecoration(
              hintText: widget.filterText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w200,
              )
            ),
          ),
        ),
        Expanded(  
            child: ListView.separated(
              shrinkWrap: true,
                itemCount: widget.list != null? widget.list.length + 1 : 0,
                itemBuilder: (context, index){
                  if(index == widget.list.length) 
                  return ListTile(title:  
                    index == 0?
                      Text("Nothing to Display", textAlign: TextAlign.center,):
                      SizedBox()
                    );
                  return ListTile(
                    dense: true,
                    onTap: ()async{
                      setState(()=>loading = true);
                      try{
                        await widget.onTap(widget.list[index], context);
                      }catch(e){
                        Toast.show("Something went wrong", context, duration: Toast.LENGTH_SHORT);
                      }
                      finally{
                        setState(() => loading = false);
                      }
                    },
                    trailing: loading == false?Icon(
                        Icons.arrow_forward_rounded,
                        color: Theme.of(context).secondaryHeaderColor,):
                      CupertinoActivityIndicator(),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.getTitle(widget.list[index]), //TODO: 
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            widget.getSubtitle(widget.list[index]), //TODO:
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Aleo-Regular',
                              fontSize: 18.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider( color: Theme.of(context).primaryColor, thickness: 1,);
                },
              ),
            ), 

          
        ]
      )
    );
  }
}