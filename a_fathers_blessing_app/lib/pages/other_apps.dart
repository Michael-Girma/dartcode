import 'package:flutter/material.dart';


class OtherApps extends StatelessWidget {
  final String screenTitle = "OTHER APPS";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                screenTitle,
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 24,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Optional
        child: Container(
          child: Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Fighter Verses',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'The Fighter Verses™ program encourages churches, families, and individuals in the lifelong practice'
                              ' and love of Bible memory. The five-year program features weekly verses that are essential to '
                              'fighting the fight of faith. The passages provide encouragement we need daily, channeling our '
                              'thought in three main directions: fixing our hearts on the character and worth of our great God; '
                              'batting the desires of our flesh; and rejoicing in the work of Christ in the Gospel. The app provides a system to help you memorize and review verses at your own pace.',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'The Fighter Verses app includes the following features:',
                            style: TextStyle(
                              fontFamily: 'OpenSans-BoldItalic',
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '• Over 1000 preloaded verses—including two complete five-year collections of verses, 76 Foundation Verses for pre-readers, and memory verses from the Truth78 curriculum\n\n'
                          '• Ability to customize and organize your own memory program with My Verses\n\n'
                          '• Multiple Bible translations in English, Spanish, French, and German\n\n'
                              '• Six unique quizzes to help you memorize verses\n\n'
                              '• Customizable review prompts (daily, weekly, monthly, and biannually) to encourage long-term retention\n\n'
                        '• Songs and spoken verse audio\n\n'
                        '• Weekly devotional blog from fighterverses.com\n\n'
                        '• Access to full chapter text and commentaries\n\n'
                        '• And much more!\n\n',
                            style: TextStyle(
                              fontFamily: 'OpenSans-Regular',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Text(
                        'With the Fighter Verses App Bible memory has never been easier. With these tools even people who have'
                        'previously been unsuccessful at memorizing Bible verses can be successful.\n\n'
                        'Download on iTunes\n\n'
                        'Download on Google Play\n',
                        style: TextStyle(
                          fontFamily: 'OpenSans-BoldItalic',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Growing in Faith Together',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Growing in Faith Together: Parent and Child Resource Pages (GIFT Pages) are created by Truth78 to help parents'
    'interact with their children about spiritual truths taught in Sunday School. These GIFT Pages, which correlate'
    'with the Truth78 elementary curriculum, provide parents a summary of what children are taught in class,'
    'discussion questions to help lead children to a heart response and an activity suggestion to reinforce the lesson'
    'themes or memory verse.',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: Text(
                              'The GIFT App is a great tool for keeping your children caught up if they are sick or traveling and miss Sunday '
    'School or it can be used on its own for family devotions. GIFT Pages can also be used as a discipleship tool for'
    'parents even if their children are not currently studying a Truth78 curriculum.',
                              style: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                              ),
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: Text(
                          'As you diligently interact with your child about these truths in daily life, you may see your child grow in spiritual'
                          'understanding and faith. Our desire is that these discussions will encourage a heart response of faith as your'
                        'child learns to trust God.\n\n'
                              'Download on iTunes\n\n'
                              'Download on Google Play\n',
                          style: TextStyle(
                            fontFamily: 'OpenSans-BoldItalic',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}