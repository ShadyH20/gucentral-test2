// ignore: avoid_web_libraries_in_flutter
// import "dart:html";
import "dart:async";
// import "dart:ui" as ui;
import "package:auto_size_text/auto_size_text.dart";
import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter/services.dart";
import "package:flutter_linkify/flutter_linkify.dart";
import "package:flutter_staggered_animations/flutter_staggered_animations.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/pages/schedule_page.dart";
import "package:gucentral/pages/transcript_page.dart";
import 'package:gucentral/widgets/ExpandableChromeDino.dart';
import "package:gucentral/widgets/EventDataSource.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:gucentral/widgets/Requests.dart";
import "package:intl/intl.dart";
import "package:jumping_dot/jumping_dot.dart";
import "package:simple_animations/animation_builder/mirror_animation_builder.dart";
import 'package:url_launcher/url_launcher.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:timeago/timeago.dart" as timeago;
import "package:wtf_sliding_sheet/wtf_sliding_sheet.dart";
import "../chrome-dino/chromeDino.dart";
import "../main.dart";
import "../utils/MeasureSize.dart";
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

  static ValueNotifier<Size> cardSize = ValueNotifier(const Size(300, 200));
  static double cardDy = 100;

  static AppBar appBar = AppBar();

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

  // Size cardSize = const Size(300, 200);
  GlobalKey gameCardKey = GlobalKey();

  @override
  void initState() {
    // Set State every 5 seconds to update the timeago widget
    Timer.periodic(const Duration(seconds: 5), (Timer t) {
      setState(() {});
    });

    // Override "en" locale messages with custom messages that are more precise and short
    timeago.setLocaleMessages('en', MyCustomMessages());
    super.initState();
    initializeEverything();
    initNotifications();
  }

  bool loadingEverything = true;
  void initializeEverything() async {
    await Requests.initializeEverything();
    // setState(() {
    loadingEverything = false;
    prefs.setBool("loading", false);
    // });
    // Set the course map
    var courses = Requests.getCourses();
    courseMap = {for (var course in courses) course['code']: course['name']};
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
    // super.build(context);
    // ColorScheme MyColors = Theme.of(context).colorScheme;
    HomePage.appBar = AppBar(
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
                            title: 'Welcome to GUCentral!',
                            body: 'We hope you enjoy our app!',
                            actionType: ActionType.Default,
                            payload: {'uuid': 'user-profile-uuid'}));
                  });
                },
              ),
        Container(
          width: 10,
        )
      ],
    );
    return Scaffold(
        backgroundColor: MyColors.background,
        // bottomNavigationBar: FlutterAdManagerWeb(
        //   adUnitCode: adUnitCode,
        //   // debug: true,
        //   width: MediaQuery.of(context).size.width,
        //   height: 70,
        // ),
        appBar: HomePage.appBar,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              // top: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
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
                                key: gameCardKey,
                                flex: 3,
                                child: MeasureSize(
                                  child: Container(
                                    // height: 250,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        15.0,
                                      ),
                                      color: MyColors.primary,
                                    ),
                                    // child: const Authorized(),
                                    // ChromeDino(),
                                  ),
                                  onChange: (size) {
                                    setState(() {
                                      HomePage.cardDy = getCardDisplacement();
                                      HomePage.cardSize.value = size;
                                      // chromeDino = ChromeDino(size: HomePage.cardSize.value);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //// THIS WEEK QUIZZES ////
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
                                              fontSize: 15,
                                              color: Colors.white),
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
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                          Expanded(
                            // height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              child:
                                  loadingNotifications && notifications.isEmpty
                                      ? buildNotificationsSkeleton()
                                      : buildNotifications(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const ExpandableChromeDino(),
          ],
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

  late final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  Widget buildNotifications() {
    return AnimationLimiter(
      key: ValueKey(getNotifsValueKey()),
      child: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: () async {
          await refreshNotifications();
          refreshController.refreshCompleted();
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
                  .parse(notifications[index]['date']);
              // print(date);
              var timeAgo = timeago.format(date, locale: 'en');
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
                        child: GestureDetector(
                          onTap: () {
                            buildNotificationSheet(notifications[index], date);
                            if (notifications[index]['read'] == false) {
                              Requests.addReadNotification(date);
                            }
                            setState(() {
                              notifications[index]['read'] = true;
                            });
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            dense: false,
                            visualDensity: VisualDensity.compact,
                            minVerticalPadding: 5,
                            horizontalTitleGap: 15,
                            leading: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: ShapeDecoration(
                                      color: MyApp.isDarkMode.value
                                          ? Colors.transparent
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: MyApp.isDarkMode.value
                                            ? BorderSide(
                                                color: MyColors.secondary
                                                    .withOpacity(0.4),
                                                width: 1.5)
                                            : BorderSide(
                                                color: MyColors.surface
                                                    .withOpacity(0.5),
                                                width: 1),
                                      )),
                                  child: Icon(
                                    Icons.notifications,
                                    color: MyColors.secondary.withOpacity(
                                        MyApp.isDarkMode.value ? 1 : 0.9),
                                  ),
                                ),
                                // Small orange cicle if notification is new
                                // (DateTime.now().difference(date).inHours <=
                                //         3 * 24)
                                notifications[index]['read'] == false
                                    ? Container(
                                        width: 9,
                                        height: 9,
                                        margin: const EdgeInsets.all(0.2),
                                        decoration: BoxDecoration(
                                          color: MyColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
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
                                const SizedBox(height: 1),
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
                                fontSize: 12,
                              ),
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

  getNotifsValueKey() {
    var key = "";
    for (var notif in notifications) {
      key += notif['date'];
    }
    return key;
  }

  List<dynamic> notifications = Requests.getNotificationsSaved();
  bool loadingNotifications = false;
  initNotifications() async {
    setState(() {
      loadingNotifications = true;
    });
    Requests.setNotificationsRead(notifications);
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

  buildNotificationSheet(dynamic notification, date) {
    showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          duration: const Duration(milliseconds: 400),
          avoidStatusBar: true,
          minHeight: MediaQuery.of(context).size.height,
          // minHeight: MediaQuery.of(context).size.height,
          color: MyApp.isDarkMode.value
              ? MyColors.background
              : const Color.fromARGB(255, 250, 250, 254),
          cornerRadius: 20,
          // extendBody: true,
          snapSpec: const SnapSpec(
            snappings: [0.85],
            initialSnap: .85,
            // onSnap: (p0, snap) {
            //   print(snap);
            // },

            // positioning: SnapPositioning.relativeToSheetHeight,
          ),
          scrollSpec: const ScrollSpec(
            overscroll: false,
          ),
          headerBuilder: (context, state) =>
              buildNotificationHeader(context, state, notification),
          builder: (context, state) =>
              buildNoticiationContent(context, notification, date),
        );
      },
    );
  }

  String at = 'at';
  Material buildNoticiationContent(BuildContext context, notification, date) {
    return Material(
      child: Container(
        color: MyApp.isDarkMode.value
            ? MyColors.background
            : const Color.fromARGB(255, 250, 250, 254),
        padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
        child: Column(
          children: [
            //Text containing the notification title
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(
                    '${courseMap[notification['course_code']]}  |',
                    style: TextStyle(
                      color: MyColors.secondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '  ${notification['course_code']}',
                    style: TextStyle(
                      color: MyColors.secondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                notification['title'],
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            const Divider(
              height: 35,
              thickness: 2,
            ),

            //ListTile containing the profile.svg icon, the sender name and the send time

            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  // decoration: ShapeDecoration(
                  //   shape: CircleBorder(
                  //     side: MyApp.isDarkMode.value
                  //         ? BorderSide(color: MyColors.secondary, width: 1)
                  //         : const BorderSide(),
                  //   ),
                  // ),
                  child: SvgPicture.asset(
                    "assets/images/profile.svg",
                    height: 50,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    dense: true,
                    // visualDensity: VisualDensity.compact,
                    horizontalTitleGap: 10,
                    minVerticalPadding: 0,
                    minLeadingWidth: 0,
                    leading: Container(
                      width: 0,
                    ),
                    title: Text(
                      notification['sender'],
                      maxLines: 2,
                      style: TextStyle(
                        color: MyColors.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.5,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 1),
                        Text(
                          DateFormat('EEEE, MMMM dd, yyyy  @ h:mm a')
                              .format(date),
                          style: TextStyle(
                            color: MyColors.secondary.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SelectableLinkify(
              options: const LinkifyOptions(humanize: false),
              onOpen: _onOpen,
              text: notification['message'],
              style: TextStyle(
                color: MyColors.secondary.withOpacity(0.9),
                fontWeight: FontWeight.w400,
                fontSize: 16.5,
              ),
              linkStyle: TextStyle(
                color: MyColors.primary.withOpacity(0.9),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w400,
                fontSize: 16.5,
              ),
            ),
            const SizedBox(height: 40),
            const Divider(
              thickness: 2,
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     notification['sender'],
            //     textAlign: TextAlign.left,
            //     style: TextStyle(
            //       color: MyColors.secondary.withOpacity(0.9),
            //       fontWeight: FontWeight.w400,
            //       fontSize: 16.5,
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                notification['sender'],
                style: TextStyle(
                  color: MyColors.secondary.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                notification['department'],
                style: TextStyle(
                  color: MyColors.secondary.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    Uri uri = Uri.parse(link.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  Widget buildNotificationHeader(
      BuildContext context, SheetState state, notification) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: MyApp.isDarkMode.value
              ? MyColors.background
              : const Color.fromARGB(255, 250, 250, 254),
          // padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 35,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: MyColors.secondary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildNotificationsSkeleton() {
    return MirrorAnimationBuilder<double>(
        duration: const Duration(seconds: 1, milliseconds: 200),
        tween: Tween(begin: 1, end: 0.2),
        builder: (context, value, child) => Opacity(
            opacity: value,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                    // margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    child: const Skeleton(height: 55));
              },
            )));
  }

  getCardDisplacement() {
    final RenderBox renderBox =
        gameCardKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size; // or _widgetKey.currentContext?.size
    print('Size: ${size.width}, ${size.height}');

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    print('Offset: ${offset.dx}, ${offset.dy}');

    return offset.dy;
  }
}

// my_custom_messages.dart
class MyCustomMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'ago';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'now';
  @override
  String aboutAMinute(int minutes) => '1m';
  @override
  String minutes(int minutes) => '${minutes}m';
  @override
  String aboutAnHour(int minutes) => minutes > 59 ? '1h' : '${minutes}m';
  @override
  String hours(int hours) => hours == 24 ? '1d' : '${hours}h';
  @override
  String aDay(int hours) => '1d';
  @override
  String days(int days) => '${days}d';
  @override
  String aboutAMonth(int days) => '1mo';
  @override
  String months(int months) => '${months}mo';
  @override
  String aboutAYear(int year) => '1y';
  @override
  String years(int years) => '${years}y';
  @override
  String wordSeparator() => ' ';
}
