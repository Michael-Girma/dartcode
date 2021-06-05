import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About78 extends StatelessWidget {
  final String screenTitle = "ABOUT TRUTH78";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Optional
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '\t Truth78 is a vision-oriented ministry for the next generations. Our vision is that the next generations '
                      'know, honor, and treasure God, setting their hope in Christ alone, so that they will live as faithful disciples fo'
                      'r the glory of God.\n\n'
                      '\t Our mission is to nurture the faith of the next generations by equipping the church and home with resources and '
                      'training that instruct the mind, engage the heart, and influence the will through proclaiming the whole counsel of God.\n\n'
                      '\t Values that undergird the development of our resources and training are that they be God-centered, Bible-saturated, Gospel-'
                      ' focused, Christ-exalting, Spirit-dependent, doctrinally grounded, and discipleship-oriented.\n\n',
                      style: TextStyle(
                        fontFamily: 'OpenSans-Regular',
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Resources for Church and Home',
                style: TextStyle(
                  fontFamily: 'OpenSans-Bold',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Truth78 currently offers the following categories of resources '
                  ' and training materials for equipping the church and home:',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                  ),
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Vision-Casting and Training',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                  ),
                ),
                subtitle: Text(
                  'We offer a wide variety of booklets, video and audio seminars, articles, and other practical'
                  ' training resources that highlight and further expound our vision, mission, and values, as well'
                  ' as our educational philosophy and methodology. Many of these resources are freely distributed '
                  'through our website. These resources  and  training serve to assist ministry leaders, volunteers, '
                  'and parents in implementing Truth78’s vision and mission in their churches and homes.',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                  ),
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Curriculum',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                  ),
                ),
                subtitle: Text(
                  'We publish materials designed for formal Bible instruction. The scope and sequence '
                  'of these materials reflects our commitment to teach children and youth the whole '
                  'counsel of God over the course of their education. Materials include curricula for '
                  'Sunday school, Midweek Bible programs, Backyard Bible Clubs or Vacation Bible School, '
                  'and International studies. Most of these materials can be adapted for use in Christian '
                  'schools and education in the home.',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                  ),
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Parenting and Family Discipleship',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                  ),
                ),
                subtitle: Text(
                  'We have produced a variety of materials and training resources designed to help'
                  ' parents in their role in discipling their children. These include booklets, '
                  'video presentations, family devotionals, children’s books, articles, and other '
                  'recommended resources. Furthermore, our curricula include Growing in Faith Together '
                  '(GIFT) Pages to help parents apply what is taught in the classroom to their child’s '
                  'daily experience in order to nurture faith.',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                  ),
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Bible Memory',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                  ),
                ),
                subtitle: Text(
                  'Our Fighter Verses Bible memory program is designed to encourage churches, families, and individuals'
                  '  in  the  lifelong  practice  and  love of Bible memory. The Fighter Verses program utilizes '
                  'an easy-to-use Bible memory system with carefully chosen verses to help fight the  fight of faith.'
                  ' It is available in print, on FighterVerses.com, and as an app for smart phones and other mobile '
                  'devices. The  Fighter  Verses App includes review reminders, quizzes, songs, a devotional, and other '
                  'memory helps. For pre-readers, Foundation Verses uses simple images to help young children memorize '
                  '76 key verses. We also offer a study, devotional guide, and coloring book that correspond to Set 1 of the'
                  ' Fighter Verses. Visit FighterVerses.com for the weekly devotional blog and for free memory aids.',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'For more information on any of these resources contact:',
                        style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                        ),
                      ),
                      IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Image.asset('assets/images/truth78.png'),
                              SizedBox(
                                height: 50,
                                child: VerticalDivider(
                                  thickness: 3,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  'Equipping the Next Generations to Know, Honor, and Treasure God',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.web),
                        title: Text(
                          'Truth78.org',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(
                          'info@Truth78.org',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text(
                          '877 400 1414',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                      ListTile(
                        leading: IconButton(
                          icon: FaIcon(FontAwesomeIcons.facebookSquare),
                        ),
                        title: Text(
                          '@Truth78org',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                      ListTile(
                        leading: IconButton(
                          icon: FaIcon(FontAwesomeIcons.twitter),
                        ),
                        title: Text(
                          '@Truth78org',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                      ListTile(
                        leading: IconButton(
                          icon: FaIcon(FontAwesomeIcons.instagram),
                        ),
                        title: Text(
                          '@Truth78org',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
