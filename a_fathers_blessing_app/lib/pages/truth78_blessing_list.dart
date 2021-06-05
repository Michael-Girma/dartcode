import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/truthBlessingsView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Truth78BlessingList extends StatefulWidget {
  Truth78BlessingList({Key key}) : super(key: key);
  final String title = "TRUTH78 BLESSINGS";

  @override
  _Truth78BlessingListState createState() => _Truth78BlessingListState();
}

class _Truth78BlessingListState extends State<Truth78BlessingList> {

  @override
  Widget build(BuildContext context) {
    TruthBlessingProvider provider = Provider.of<TruthBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    // provider.truthBlessings = [];
    // provider.lastBlessingDocument = null;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'OpenSans-Bold',
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
        child: Consumer<TruthBlessingProvider>(
          builder: (context, truthBlessingProvider, child){
            // TruthBlessingView(this.context, this.requester, {this.truthBlessings = const[]});
            List<TruthBlessing> blessings = truthBlessingProvider.truthBlessings;
            String onTimeout = "Couldn't fetch blessings";
            return TruthBlessingView(context, _requester, truthBlessings: blessings, onTimeout: onTimeout);
          },
        )
      ),
    );
  }

  Future<bool> _requester(context) async{
    TruthBlessingProvider provider = Provider.of<TruthBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen:false );
    List<TruthBlessing> blessings = await provider.getMoreTruthBlessings(user.user);
    if(blessings == null) return false;
    return blessings.length > 0;
  }

  //TODO: make refresher function
}
