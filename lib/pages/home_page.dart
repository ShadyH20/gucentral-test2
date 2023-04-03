// ignore: avoid_web_libraries_in_flutter
// import "dart:html";
import "dart:ui" as ui;
import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/pages/schedule_page.dart";
import "package:gucentral/widgets/EventDataSource.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:gucentral/widgets/Requests.dart";
import "package:intl/intl.dart";
import "../utils/SharedPrefs.dart";
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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
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
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: MyColors.background,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark),
          elevation: 0,
          backgroundColor: MyColors.background,
          centerTitle: true,
          leadingWidth: 50.0,
          leading: const MenuWidget(),
          title:
              // Container(
              //     padding: const EdgeInsets.only(top: 15),
              //     child: SvgPicture.asset(
              //       "assets/images/logo-text.svg",
              //       height: 35,
              //       color: MyColors.primary,
              //     )),
              const Text(
            "Home",
          ),
          actions: [
            IconButton(
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

                // var granted = js.context.callMethod('requestNotPermission');
                // if (granted) {
                //   js.context.callMethod('showNotification',
                //       ['Welcome to GUCentral!', 'We hope you enjoy our app!']);
                //   // await Future.delayed(const Duration(seconds: 7));
                //   // js.context.callMethod('showNotification', [
                //   //   'Welcome to GUCentral!',
                //   //   'This is a delayed notification!'
                //   // ]);
                // }
                // print("Granted: $granted");
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
              const SizedBox(height: 30),
              //// HELLO STUDENT ////
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        (prefs.getString('name')!.split(" ")[0] ==
                                "Abdelrahman")
                            ? "Hello, Bodia!"
                            : "Hello, ${prefs.getString('first_name')! ?? "Student"}!",
                        style: const TextStyle(
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
              const SizedBox(height: 20),

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
                                    color: MyColors.secondary,
                                  ),
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: MyColors.background),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 11.0),
                                      child: FittedBox(
                                        child: Column(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "This Week",
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  getNumberOfQuizzesThisWeek(),
                                                  textScaleFactor: 6,
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
                                    color: MyColors.accent,
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
                                                    fontSize: 47)),
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
                        const SizedBox(height: 25),
                      ],
                    )),
              ),

              //// SCHEDULE ////
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // height: 50,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text.rich(
                          TextSpan(
                            text: "Today, ",
                            style: const TextStyle(
                                color: MyColors.secondary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(
                                text: DateFormat("dd MMMM")
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
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        // height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.07),
                        ),
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
    var dataSource = EventDataSource(allQuizzes);
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
}
