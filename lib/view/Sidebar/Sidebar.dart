import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acctik/controller/Navigation/route/navigation_event_bloc.dart';
import 'package:rxdart/rxdart.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

String x = "en";

class _SidebarState extends State<Sidebar>
    with SingleTickerProviderStateMixin<Sidebar> {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);
   String? _email; // <-- Their email
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
    User? user = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
    if (user != null) {
       _email = user.email; // <-- Their email
    } else {
       _email = "Null";
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {

    x = Localizations.localeOf(context).toString();
    final ThemeData theme = Theme.of(context);
    final screenwidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, snapshot) {
        return AnimatedPositioned(
          top: 0,
          bottom: 0,
          left: x == "en"
              ? snapshot.data!
                  ? 0
                  : -screenwidth
              : snapshot.data!
                  ? screenwidth / 1.4
                  : screenwidth - 45,
          //  isOpen ? 0 : 0,
          right: x == "en"
              ? snapshot.data!
                  ? screenwidth / 1.4
                  : screenwidth - 45
              : snapshot.data!
                  ? 0
                  : -screenwidth,
          duration: _animationDuration,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: theme.indicatorColor,
                  child: Center(
                    child: CustomScrollView(
                      slivers: [
                        // Fixed header
                        SliverAppBar(
                          bottom: const PreferredSize(
                              preferredSize: Size(100, 100),
                              child: Text(
                                overflow: TextOverflow
                                    .ellipsis, // Trail off with ellipsis
                                maxLines: 1,
                                "company Category",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )),
                          actions: const [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                overflow: TextOverflow
                                    .ellipsis, // Trail off with ellipsis
                                maxLines: 1,
                                "user type",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                          expandedHeight: 100,
                          flexibleSpace: const SizedBox(
                            height: 100,
                          ),
                          title:   Text(
                            overflow: TextOverflow
                                .ellipsis, // Trail off with ellipsis
                            maxLines: 1,
                            _email!,
                            style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              width: 100,
                              child: CircleAvatar(
                                radius: 100,
                                child: Icon(
                                  Icons.perm_identity,
                                  color: theme.cardColor,
                                ),
                              ),
                            ),
                          ),

                          pinned: true, // Keep header fixed when scrolling
                        ),

                        // Your ListView
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: 1, // Assuming 20 list items
                            (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: SizedBox(
                                      width: 50,
                                      child: Icon(
                                        Icons.home,
                                        color: theme.primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      overflow: TextOverflow
                                          .ellipsis, // Trail off with ellipsis
                                      maxLines: 1,
                                      "Home",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 26,
                                          color: theme.primaryColor),
                                    ),
                                    onTap: () {
                                      //onIconPressed();
                                      onIconPressed();
                                      BlocProvider.of<NavigationCubit>(context)
                                          .HomePage();
                                    },
                                  ),
                                  ListTile(
                                      leading: SizedBox(
                                        width: 50,
                                        child: Icon(
                                          Icons.public,
                                          color: theme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        overflow: TextOverflow
                                            .ellipsis, // Trail off with ellipsis
                                        maxLines: 1,
                                        "Organization",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 26,
                                            color: theme.primaryColor),
                                      ),
                                      onTap: () {
                                        //onIconPressed();
                                        onIconPressed();
                                        BlocProvider.of<NavigationCubit>(
                                                context)
                                            .Org();
                                      }),
                                  ListTile(
                                      leading: SizedBox(
                                        width: 50,
                                        child: Icon(
                                          Icons.apartment,
                                          color: theme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        overflow: TextOverflow
                                            .ellipsis, // Trail off with ellipsis
                                        maxLines: 1,
                                        "Accounts",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 26,
                                            color: theme.primaryColor),
                                      ),
                                      onTap: () {
                                        //onIconPressed();
                                        onIconPressed();
                                        BlocProvider.of<NavigationCubit>(
                                                context)
                                            .Accoutnts();
                                      }),
                                       ListTile(
                                      leading: SizedBox(
                                        width: 50,
                                        child: Icon(
                                          Icons.add_box,
                                          color: theme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        overflow: TextOverflow
                                            .ellipsis, // Trail off with ellipsis
                                        maxLines: 1,
                                        "Add Journal",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 26,
                                            color: theme.primaryColor),
                                      ),
                                      onTap: () {
                                        //onIconPressed();
                                        onIconPressed();
                                        BlocProvider.of<NavigationCubit>(
                                                context)
                                            .JornalEntry();
                                      }),
                                      ListTile(
                                      leading: SizedBox(
                                        width: 50,
                                        child: Icon(
                                          Icons.edit,
                                          color: theme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        overflow: TextOverflow
                                            .ellipsis, // Trail off with ellipsis
                                        maxLines: 1,
                                        "All Journal",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 26,
                                            color: theme.primaryColor),
                                      ),
                                      onTap: () {
                                        //onIconPressed();
                                        onIconPressed();
                                        BlocProvider.of<NavigationCubit>(
                                                context)
                                            .JornalTrans();
                                      }),


                                        ListTile(
                                      leading: SizedBox(
                                        width: 50,
                                        child: Icon(
                                          Icons.book,
                                          color: theme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        overflow: TextOverflow
                                            .ellipsis, // Trail off with ellipsis
                                        maxLines: 1,
                                        "Master Ledger",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 26,
                                            color: theme.primaryColor),
                                      ),
                                      onTap: () {
                                        //onIconPressed();
                                        onIconPressed();
                                        BlocProvider.of<NavigationCubit>(
                                                context)
                                            .MasterLedger();
                                      }),
                                        ListTile(
                                      leading: SizedBox(
                                        width: 50,
                                        child: Icon(
                                          Icons.bookmark_remove,
                                          color: theme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        overflow: TextOverflow
                                            .ellipsis, // Trail off with ellipsis
                                        maxLines: 1,
                                        "Sub Ledger",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 26,
                                            color: theme.primaryColor),
                                      ),
                                      onTap: () {
                                        //onIconPressed();
                                        onIconPressed();
                                        BlocProvider.of<NavigationCubit>(
                                                context)
                                            .SubLedger();
                                      }),
                                  ListTile(
                                      leading: SizedBox(
                                        width: 50,
                                        child: Icon(
                                          Icons.report,
                                          color: theme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        overflow: TextOverflow
                                            .ellipsis, // Trail off with ellipsis
                                        maxLines: 1,
                                        "Reports",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 26,
                                            color: theme.primaryColor),
                                      ),
                                      onTap: () {
                                        //onIconPressed();
                                        onIconPressed();
                                        BlocProvider.of<NavigationCubit>(
                                                context)
                                            .Reports();
                                      }),
                                         ListTile(
                                    leading: SizedBox(
                                      width: 50,
                                      child: Icon(
                                        Icons.history,
                                        color: theme.primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      overflow: TextOverflow
                                          .ellipsis, // Trail off with ellipsis
                                      maxLines: 1,
                                      "Log Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 26,
                                          color: theme.primaryColor),
                                    ),
                                    onTap: () {
                                      //onIconPressed();
                                      onIconPressed();
                                       BlocProvider.of<NavigationCubit>(context)
                                          .LogData();
                                    },
                                  ),
                                  ListTile(
                                    leading: SizedBox(
                                      width: 50,
                                      child: Icon(
                                        Icons.settings,
                                        color: theme.primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      overflow: TextOverflow
                                          .ellipsis, // Trail off with ellipsis
                                      maxLines: 1,
                                      "Setting",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 26,
                                          color: theme.primaryColor),
                                    ),
                                    onTap: () {
                                      //onIconPressed();
                                      onIconPressed();
                                      print("Setting");
                                      BlocProvider.of<NavigationCubit>(context)
                                          .Setting();
                                    },
                                  ),
                                  Divider(
                                    //  height: 64,
                                    thickness: 0.5,
                                    color: theme.primaryColor.withOpacity(0.3),
                                    indent: 10,
                                    endIndent: 5,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper:
                        x == "en" ? CustomMenuClipper() : ArCustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: theme.indicatorColor,
                      alignment: x == "en"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(0, 0);

    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ArCustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    final width = size.width;
    final height = size.height;
    Path originalPath = Path();
    originalPath.moveTo(0, 0);
    originalPath.quadraticBezierTo(0, 8, -10, 16);
    originalPath.quadraticBezierTo(
        -(width - 1), height / 2 - 20, -width, height / 2);
    originalPath.quadraticBezierTo(
        -(width + 1), height / 2 + 20, -10, height - 16);
    originalPath.quadraticBezierTo(0, height - 8, 0, height);

    Path flipped = flipPath(originalPath, width, height);
    return flipped;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Path flipPath(Path path, double width, double height) {
  Path flippedPath = Path();
  path.computeMetrics().forEach((metric) {
    final segment = metric.extractPath(0, metric.length);
    final reversedSegment = Path()..addPath(segment, Offset(width, 0));
    flippedPath.addPath(reversedSegment, const Offset(0, 0));
  });
  return flippedPath;
}
