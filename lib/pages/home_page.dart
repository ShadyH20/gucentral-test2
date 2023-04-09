// ignore: avoid_web_libraries_in_flutter
// import "dart:html";
import "dart:ui" as ui;
import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_staggered_animations/flutter_staggered_animations.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/pages/schedule_page.dart";
import "package:gucentral/widgets/EventDataSource.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:gucentral/widgets/Requests.dart";
import "package:intl/intl.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:timeago/timeago.dart" as timeago;
import "../main.dart";
import "../utils/SharedPrefs.dart";
//import Notifications.dart from the web directory
import '../utils/Notifications.dart';
// import 'dart:js' as js;
// import 'package:flutter_ad_manager_web/flutter_ad_manager_web.dart';

// import 'package:navigation_drawer_animation/widet/menu_widget'

String adUnitCode = '''
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-9217063481962107"
     crossorigin="anonymous"></script>
<!-- HorizontalAds -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-9217063481962107"
     data-ad-slot="9500486818"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
''';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  @override
  void initState() {
// Override "en" locale messages with custom messages that are more precise and short
    timeago.setLocaleMessages('en', timeago.EnMessages());
    super.initState();
    initializeEverything();
    initNotifications();
  }

  bool loadingEverything = true;
  void initializeEverything() async {
    await Requests.initializeEverything();
    setState(() {
      loadingEverything = false;
      prefs.setBool("loading", false);
      // menuPageKey.currentState?.setState(() {});
    });
  }

  Widget adsenseAdsView() {
    // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(
    //     'adViewType',
    //     (int viewID) => IFrameElement()
    //       ..width = '320'
    //       ..height = '100'
    //       ..src = 'adview.html'
    //       ..style.border = 'none');

    return Container(
      height: 100.0,
      width: 320.0,
      decoration: BoxDecoration(border: Border.all()),
      // child: HtmlElementView(
      //   viewType: 'adViewType',
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ColorScheme MyColors = Theme.of(context).colorScheme;

    return Scaffold(
        backgroundColor: MyColors.background,
        // bottomNavigationBar: FlutterAdManagerWeb(
        //   adUnitCode: adUnitCode,
        //   // debug: true,
        //   width: MediaQuery.of(context).size.width,
        //   height: 70,
        // ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.background,
          centerTitle: true,
          leadingWidth: 50.0,
          leading: const MenuWidget(),
          title: const Text(
            "Home",
          ),
          actions: [
            loadingEverything
                ? const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : IconButton(
                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                    icon: Icon(
                      Icons.notifications_rounded,
                      size: 30,
                      color: MyColors.secondary,
                    ),
                    // SvgPicture.asset(
                    //   "assets/images/edit.svg",
                    //   height: 30,
                    //   color: MyColors.secondary,
                    // ),
                    onPressed: () async {
                      /// REQUEST NOTIFICATIONS PERMISSION
                      AwesomeNotifications()
                          .isNotificationAllowed()
                          .then((isAllowed) {
                        print(
                            "Notifications are ${isAllowed ? "allowed" : "not allowed"}");
                        if (!isAllowed) {
                          // This is just a basic example. For real apps, you must show some
                          // friendly dialog box before call the request method.
                          // This is very important to not harm the user experience
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications();
                        }
                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                                id: 10,
                                channelKey: 'basic_channel',
                                title: 'Welcom to GUCentral!',
                                body: 'We hope you enjoy our app!',
                                actionType: ActionType.Default));
                      });

                      if (kIsWeb) {
                        MyNotification.sendNotification('Welcome to GUCentral!',
                            'We hope you enjoy our app!');
                      }
                    },
                  ),
            Container(
              width: 10,
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 15),
              //// HELLO STUDENT ////
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Hello, ${prefs.getString('first_name') ?? "Student"}!",
                        style: TextStyle(
                            color: MyColors.secondary,
                            fontSize: 36,
                            fontWeight: FontWeight.w800),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              //// THE 3 BOXES ////
              Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        //// SUMMARY ////
                        Expanded(
                          flex: 3,
                          child: Container(
                            // height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15.0,
                              ),
                              color: MyColors.primary,
                            ),
                            // child: adsenseAdsView(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //// NEXT WEEK QUIZZES ////
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                    color: MyColors.surface,
                                  ),
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 11.0),
                                      child: FittedBox(
                                        child: Column(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "this week",
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  getNumberOfQuizzesThisWeek(),
                                                  textScaleFactor: 5.5,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                  "exam${nQuizzesThisWeek == 1 ? "" : "s"}")
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              //// CURRENT WEEK ////
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                    color: MyColors.tertiary,
                                  ),
                                  child: Column(children: [
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: const [
                                          Positioned(
                                            top: 15,
                                            child: Text(
                                              "current week",
                                            ),
                                          ),
                                          Positioned(
                                            // right: 10,
                                            child: Text("Week 5",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 43)),
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    )),
              ),

              //// NOTIFICATIONS ////
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // i want this to have a loading indicator on the right side to indicate whether the notifications are loading or not
                    // and if there are no notifications, then show a message saying "No notifications"
                    Expanded(
                      // height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text.rich(
                                TextSpan(
                                  text: "Today, ",
                                  style: TextStyle(
                                      color: MyColors.secondary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                  children: [
                                    TextSpan(
                                      text: DateFormat("d MMMM")
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                          // color: MyColors.background,
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // show a loading indicator if the notifications are loading
                            loadingNotifications
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      flex: 10,
                      child: Container(
                        // height: 50,
                        decoration: BoxDecoration(
                          color: MyColors.background,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.primary,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(top: 5),
                        child: buildNotifications(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  int nQuizzesThisWeek = 0;
  @override
  bool get wantKeepAlive => true;

  getNumberOfQuizzesThisWeek() {
    var allQuizzes = Requests.getQuizzes();
    var allExams = Requests.getExamsSaved();
    var dataSource = EventDataSource(allQuizzes + allExams);
    var quizzesThisWeek = dataSource.getVisibleAppointments(
        DateTime.now(), "", findLastDateOfTheWeek(DateTime.now()));
    setState(() {
      nQuizzesThisWeek = quizzesThisWeek.length;
    });
    return "${quizzesThisWeek.length}";
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    int daysToadd = DateTime.saturday - dateTime.weekday;
    if (daysToadd == -1) {
      daysToadd = 6;
    }
    return dateTime
        .getDateOnly()
        .add(Duration(days: daysToadd))
        .subtract(const Duration(minutes: 1));
  }

  /// NOTIFICATIONS ///
  // this is 1 notification: {'title': 'SE Project Repository', 'course_code': 'CSEN603', 'date': '28/03/2023 09:24:28', 'message': "Dear All,\n\nPlease note that you should NOT set your team's GitHub repository as public otherwise it will be considered a cheating case because this means everyone can
// see your submission.\n\nKind regards,\n\n------------------------------\nMs. Marina Nader Nabil Amin Eskander \nDepartment: Computer Science", 'sender': 'Ms. Marina Nader Nabil Amin Eskander'}
  // i wanto to make me a listview with all notifications from the notifications list. I want to show a notification's title, sender, and how much time ago was the notification sent (e.g. 20m ago) if the sent time is today, or the date if it was sent yesterday or before
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildNotifications() {
    return AnimationLimiter(
      key: ValueKey("$notifications"),
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          await refreshNotifications();
          _refreshController.refreshCompleted();
        },
        header: WaterDropHeader(
          waterDropColor: MyColors.primary,
          complete: Icon(
            Icons.check,
            color: MyColors.primary,
          ),
        ),
        child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var date = DateFormat('dd/MM/yyyy HH:mm:ss')
                  .parse(notifications[index]['date'], true);
              var timeAgo = timeago.format(date, locale: 'en_short');
              return AnimationConfiguration.staggeredList(
                delay: const Duration(milliseconds: 50),
                position: index,
                duration: const Duration(milliseconds: 200),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color:
                              // Color.fromARGB(255, 227, 246, 254).withOpacity(1)
                              MyColors.secondary.withOpacity(
                                  MyApp.isDarkMode.value ? 0.2 : 0.1),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          dense: false,
                          visualDensity: VisualDensity.compact,
                          horizontalTitleGap: 15,
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration:
                                // BoxDecoration(
                                //   borderRadius: BorderRadius.circular(15),
                                //   color: MyApp.isDarkMode.value
                                //       ? MyColors.secondary.withOpacity(0.4)
                                //       // : Color(0xFFDBF2FD).withOpacity(0.6),
                                //       : ui.Color.fromARGB(255, 220, 220, 220),
                                //   // color: Color(0xFFDBF2FD)
                                //   // border: MyApp.isDarkMode.value
                                //   //     ? Border.all(
                                //   //         color: MyColors.secondary.withOpacity(0.4),
                                //   //         width: 1)
                                //   //     : Border.all(
                                //   //         color: Color.fromARGB(255, 227, 246, 254),
                                //   //         width: 1),
                                //   boxShadow: [
                                //     BoxShadow(
                                //         color: MyColors.surface.withOpacity(0.5),
                                //         offset: const Offset(0, 0),
                                //         spreadRadius: 1),
                                //   ],
                                // ),
                                ShapeDecoration(
											color: MyApp.isDarkMode.value ? Colors.transparent: Colors.white,
                                    shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: MyApp.isDarkMode.value
                                  ? BorderSide(
                                      color:
                                          MyColors.secondary.withOpacity(0.4),
                                      width: 1.5)
                                  : BorderSide(
                                      color: MyColors.surface.withOpacity(0.5),
                                      width: 1),
                            )),
                            child: Icon(
                              Icons.notifications,
                              color: MyColors.secondary.withOpacity(
                                  MyApp.isDarkMode.value ? 1 : 0.9),
                            ),
                          ),
                          // i want to add
                          title: Text(
                            notifications[index]['title'],
                            style: TextStyle(
                              color: MyColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1),
                              Text(
                                notifications[index]['course_code'],
                                style: TextStyle(
                                  color: MyColors.secondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                notifications[index]['sender'],
                                style: TextStyle(
                                  color: MyColors.secondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: Text(
                            timeAgo,
                            style: TextStyle(
                              color: MyColors.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  List<dynamic> notifications = Requests.getNotificationsSaved();
  bool loadingNotifications = false;
  initNotifications() async {
    setState(() {
      loadingNotifications = true;
    });
    var result = await Requests.getNotifications();
    var success = result['success'];
    if (success) {
      setState(() {
        notifications = result['notifications'];
      });
    }
    setState(() {
      loadingNotifications = false;
    });
  }

  refreshNotifications() async {
    var result = await Requests.getNotifications();
    var success = result['success'];
    if (success) {
      setState(() {
        notifications = result['notifications'];
      });
    }
  }
}

// my_custom_messages.dart
class MyCustomMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'now';
  @override
  String aboutAMinute(int minutes) => '${minutes}m ago';
  @override
  String minutes(int minutes) => '${minutes}m ago';
  @override
  String aboutAnHour(int minutes) => '${minutes}m ago';
  @override
  String hours(int hours) => '${hours}h ago';
  @override
  String aDay(int hours) => '${hours}h';
  @override
  String days(int days) => '${days}d';
  @override
  String aboutAMonth(int days) => '${days}d';
  @override
  String months(int months) => '${months}mo';
  @override
  String aboutAYear(int year) => '${year}y';
  @override
  String years(int years) => '${years}y';
  @override
  String wordSeparator() => ' ';
}
