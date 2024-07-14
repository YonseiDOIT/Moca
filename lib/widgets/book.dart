import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

// global variables
import 'package:app/globals.dart';
import 'package:app/globals.dart' as globals;

class BookGroupWidget extends StatelessWidget {
  final bool cardView;
  final Map bookGroupData;
  final String sortType;
  final int positionNum;

  static double bookWidth = 150;
  static double bookshelfWidth = bookWidth + 30;
  static double bookOffset = 20;

  const BookGroupWidget({
    super.key,
    required this.cardView,
    required this.bookGroupData,
    required this.sortType,
    required this.positionNum,
  });

  @override
  Widget build(BuildContext context) {
    if (cardView) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 250),
              reverseTransitionDuration: const Duration(milliseconds: 250),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) => BookGroupDetail(
                bookGroupData: bookGroupData,
                sortType: sortType,
              ),
            ),
          );
        },
        child: SizedBox(
          width: bookshelfWidth,
          height: 270,
          child: Stack(
            children: [
              ..._buildBookshelf(context, positionNum),
              Stack(
                children: [
                  Positioned(
                    height: 184,
                    width: bookWidth,
                    top: 10,
                    left: bookOffset,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(10, 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    height: 184,
                    width: 7,
                    top: 18,
                    left: bookWidth + bookOffset - 12,
                    child: ClipPath(
                      clipper: BookClipper(),
                      child: Container(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    height: 200,
                    width: bookWidth,
                    top: 10,
                    left: bookOffset,
                    child: Hero(
                      tag: "${bookGroupData["_id"]}$sortType",
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Image.network(
                          bookGroupData["image_url"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 250),
              reverseTransitionDuration: const Duration(milliseconds: 250),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) => BookGroupDetail(
                bookGroupData: bookGroupData,
                sortType: sortType,
              ),
            ),
          );
        },
        child: Container(
          height: bookWidth,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: [
              Hero(
                tag: "${bookGroupData["_id"]}$sortType",
                child: AspectRatio(
                  aspectRatio: 6 / 9,
                  child: Image.network(
                    bookGroupData["image_url"],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${bookGroupData["title"]}",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "${bookGroupData["author"]} - ${bookGroupData["publisher"]} - ${bookGroupData["publication_date"]}",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        "최저가: ${globals.formatCurrency.format(bookGroupData["lowest_price"]["price"])}원",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "재고: ${bookGroupData["registered_books"].length}부",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
// ..._buildBookshelf(context),

  List<Widget> _buildBookshelf(context, positionNum) {
    double topHeight = 40;
    double topPosition = 180;
    double frontHeight = 15;
    double frontPosition = topHeight + topPosition;

    if (positionNum == 0) {
      return [
        Positioned(
          height: topHeight,
          top: topPosition,
          width: bookshelfWidth,
          child: ClipPath(
            clipper: BookshelfLeftClipper(),
            child: Container(
              color: const Color(0xFFF9EFD6),
            ),
          ),
        ),
        Positioned(
          height: frontHeight,
          top: frontPosition,
          width: bookshelfWidth,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAEE),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(10, 10), // changes position of shadow
                ),
              ],
            ),
          ),
        ),
      ];
    } else if (positionNum == 2) {
      return [
        Positioned(
          height: topHeight,
          top: topPosition,
          width: bookshelfWidth,
          child: ClipPath(
            clipper: BookshelfRightClipper(),
            child: Container(
              color: const Color(0xFFF9EFD6),
            ),
          ),
        ),
        Positioned(
          height: frontHeight,
          top: frontPosition,
          width: bookshelfWidth,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAEE),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(10, 10), // changes position of shadow
                ),
              ],
            ),
          ),
        ),
      ];
    } else {
      return [
        Positioned(
          height: topHeight,
          top: topPosition,
          width: bookshelfWidth,
          child: Container(
            color: const Color(0xFFF9EFD6),
          ),
        ),
        Positioned(
          height: frontHeight,
          top: frontPosition,
          width: bookshelfWidth,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAEE),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(10, 10), // changes position of shadow
                ),
              ],
            ),
          ),
        ),
      ];
    }
  }
}

class BookshelfLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double slope = 16;

    path.moveTo((0 + slope), 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo((size.width), 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BookshelfRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double slope = 16;

    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo((size.width - slope), 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BookClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double slope = 8;

    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, (size.height - slope));
    path.lineTo(size.width, (0 + slope));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BookGroupDetail extends StatefulWidget {
  final Map bookGroupData;
  final String sortType;

  const BookGroupDetail({
    super.key,
    required this.bookGroupData,
    required this.sortType,
  });

  @override
  State<BookGroupDetail> createState() => _BookGroupDetailState();
}

class _BookGroupDetailState extends State<BookGroupDetail> {
  final controller = ScrollController();
  double cWidth = 0.0;
  double itemHeight = 28.0;
  double itemsCount = 20;
  late double screenWidth;

  onScroll() {
    setState(() {
      cWidth = controller.offset * screenWidth / (itemHeight * itemsCount);
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    // final someOtherSliver = SliverToBoxAdapter(
    //   child: Container(
    //     height: 80,
    //     alignment: Alignment.centerLeft,
    //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
    //     child: Row(
    //       children: [
    //         IconButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           icon: const Icon(Icons.arrow_back_ios_new),
    //         ),
    //         Text(
    //           "중고책 전체 목록 > 책 목록",
    //           style: Theme.of(context).textTheme.titleMedium,
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    // return Scaffold(
    //   body: NestedScrollView(
    //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //       // These are the slivers that show up in the "outer" scroll view.
    //       return <Widget>[
    //         SliverOverlapAbsorber(
    //           handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //           sliver: SliverAppBar(
    //             pinned: true,
    //             expandedHeight: 300.0,
    //             collapsedHeight: 80,
    //             forceElevated: innerBoxIsScrolled,
    //             bottom: PreferredSize(
    //               preferredSize: Size.fromHeight(80),
    //               child: Container(
    //                 // height: 80,
    //                 alignment: Alignment.centerLeft,
    //                 // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
    //                 child: Row(
    //                   children: [
    //                     IconButton(
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    //                     ),
    //                     Text(
    //                       "중고책 전체 목록 > 책 목록",
    //                       style: Theme.of(context).textTheme.titleMedium,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ];
    //     },
    //     body: FutureBuilder(
    //       future: moca_api.Books.getBooks(
    //           id: widget.bookGroupData[
    //               "_id"]), // this is a code smell. Make sure that the future is NOT recreated when build is called. Create the future in initState instead.
    //       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //         Widget newsListSliver;

    //         if (snapshot.hasData == false) {
    //           newsListSliver = const SliverToBoxAdapter(
    //             child: CircularProgressIndicator(),
    //           );
    //         } else {
    //           Map groupBooksData = snapshot.data!;
    //           newsListSliver = SliverList(
    //             delegate: SliverChildBuilderDelegate(
    //               (context, index) {
    //                 print(index);
    //                 return Column(
    //                   children: [
    //                     BookWidget(
    //                       makeFrom: "group",
    //                       bookGroupData: groupBooksData["book_group"],
    //                       bookData: groupBooksData["items"][index],
    //                       sortType: widget.sortType,
    //                     ),
    //                     const Divider(height: 0, thickness: 1.5),
    //                   ],
    //                 );
    //               },
    //               childCount: groupBooksData["items"].length,
    //             ),
    //           );
    //         }
    //         return CustomScrollView(
    //           slivers: <Widget>[
    //             SliverOverlapInjector(
    //               // This is the flip side of the SliverOverlapAbsorber
    //               // above.
    //               handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //             ),
    //             someOtherSliver,
    //             newsListSliver
    //           ],
    //         );
    //       },
    //     ),

    // body: Builder(
    //   // This Builder is needed to provide a BuildContext that is
    //   // "inside" the NestedScrollView, so that
    //   // sliverOverlapAbsorberHandleFor() can find the
    //   // NestedScrollView.
    //   builder: (BuildContext context) {
    //     return CustomScrollView(
    //       // The "controller" and "primary" members should be left
    //       // unset, so that the NestedScrollView can control this
    //       // inner scroll view.
    //       // If the "controller" property is set, then this scroll
    //       // view will not be associated with the NestedScrollView.
    //       // The PageStorageKey should be unique to this ScrollView;
    //       // it allows the list to remember its scroll position when
    //       // the tab view is not on the screen.
    //       // key: PageStorageKey<String>(""),
    //       slivers: <Widget>[
    //         SliverOverlapInjector(
    //           // This is the flip side of the SliverOverlapAbsorber
    //           // above.
    //           handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //         ),
    //         SliverList(
    //           // The items in this example are fixed to 48 pixels
    //           // high. This matches the Material Design spec for
    //           // ListTile widgets.

    //           delegate: SliverChildBuilderDelegate([
    //             Container(
    //                 child: FutureBuilder(
    //               future: moca_api.Books.getBooks(id: widget.bookGroupData["_id"]),
    //               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //                 if (snapshot.hasData == false) {
    //                   return Container();
    //                 }
    //                 Map groupBooksData = snapshot.data!;
    //                 return Container();
    //                 // return ListView.separated(
    //                 //   shrinkWrap: true,
    //                 //   itemBuilder: (context, index) {
    //                 //     return BookWidget(
    //                 //       makeFrom: "group",
    //                 //       bookGroupData: groupBooksData["book_group"],
    //                 //       bookData: groupBooksData["items"][index],
    //                 //       sortType: widget.sortType,
    //                 //     );
    //                 //   },
    //                 //   separatorBuilder: (context, index) {
    //                 //     return const Divider(height: 0, thickness: 1.5);
    //                 //   },
    //                 //   itemCount: groupBooksData["items"].length,
    //                 // );
    //                 // return Column(
    //                 //   children: [
    //                 //     for (var book in groupBooksData["items"])
    //                 //       Column(
    //                 //         children: [
    //                 //           BookWidget(
    //                 //             makeFrom: "group",
    //                 //             bookGroupData: groupBooksData["book_group"],
    //                 //             bookData: book,
    //                 //             sortType: widget.sortType,
    //                 //           ),
    //                 //           const Divider(height: 0, thickness: 1.5),
    //                 //         ],
    //                 //       ),
    //                 //   ],
    //                 // );
    //               },
    //             ))
    //           ] as NullableIndexedWidgetBuilder

    //               // The childCount of the SliverChildBuilderDelegate
    //               // specifies how many children this inner list
    //               // has. In this example, each tab has a list of
    //               // exactly 30 items, but this is arbitrary.

    //               ),
    //         ),
    //       ],
    //     );
    //   },
    // ),
    // ),
    // );

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              Container(
                height: 80,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Text(
                      "중고책 전체 목록 > 책 목록",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          // ${widget.bookData["_id"]}${widget.sortType}
                          tag: "${widget.bookGroupData["_id"]}${widget.sortType}",
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: Image.network(
                              widget.bookGroupData["image_url"],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          widget.bookGroupData["title"],
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          "${widget.bookGroupData["author"]} - ${widget.bookGroupData["publisher"]} - ${widget.bookGroupData["publication_date"]}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "원가: ${globals.formatCurrency.format(widget.bookGroupData["new_price"])}원",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "\n등록된 중고책 모두 보기",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        FutureBuilder(
                          future: moca_api.Books.getBooks(id: widget.bookGroupData["_id"]),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData == false) {
                              return Container();
                            }
                            Map groupBooksData = snapshot.data!;
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return BookWidget(
                                  makeFrom: "group",
                                  bookGroupData: groupBooksData["book_group"],
                                  bookData: groupBooksData["items"][index],
                                  sortType: widget.sortType,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(height: 0, thickness: 1.5);
                              },
                              itemCount: groupBooksData["items"].length,
                            );
                            // return Column(
                            //   children: [
                            //     for (var book in groupBooksData["items"])
                            //       Column(
                            //         children: [
                            //           BookWidget(
                            //             makeFrom: "group",
                            //             bookGroupData: groupBooksData["book_group"],
                            //             bookData: book,
                            //             sortType: widget.sortType,
                            //           ),
                            //           const Divider(height: 0, thickness: 1.5),
                            //         ],
                            //       ),
                            //   ],
                            // );
                          },
                        )
                      ],
                    ),
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

class BookWidget extends StatefulWidget {
  final String makeFrom;
  final Map bookGroupData;
  final Map bookData;
  final String sortType;
  final String state;
  final Map bookshelfData;
  final Map fullData;

  const BookWidget({
    super.key,
    required this.makeFrom,
    required this.bookGroupData,
    required this.bookData,
    this.sortType = "",
    this.state = "",
    this.bookshelfData = const {},
    this.fullData = const {},
  });

  @override
  State<BookWidget> createState() => BookWidgetState();
}

class BookWidgetState extends State<BookWidget> {
  final List _condition = ["최상", "상", "중", "하"];
  late bool selected = widget.bookData["bookshelf"]?["_id"] == widget.bookshelfData["_id"];
  late bool liked = MocaUser.liked_books.contains(widget.bookData["_id"]);
  bool changed = false;

  Future<Map> saveBookshelf() async {
    Map response = {"success": "notchanged"};
    if (changed) {
      response = await moca_api.Books.updateBook(
        transaction_type: "bookshelf",
        user_id: MocaUser.id,
        book_id: widget.bookData["_id"],
        bookshelf: widget.bookshelfData["_id"],
      );
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.makeFrom == "bookshelf_add") {
          changed = true;
          setState(() {
            selected = !selected;
          });
        } else if (widget.makeFrom == "history") {
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 250),
              reverseTransitionDuration: const Duration(milliseconds: 250),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) => BookDetail(
                bookGroupData: widget.bookGroupData,
                bookData: widget.bookData,
                sortType: widget.sortType,
              ),
            ),
          );
        }
      },
      child: buildBook(),
    );
  }

  Widget buildBook() {
    if (widget.makeFrom == "group") {
      return Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.bookGroupData["title"].split('(')[0],
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                widget.bookData["owner"]["_id"] != MocaUser.id ? const Text("") : const Text("owned"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "대출 상태: ${widget.bookData["borrower"] == null ? "보관중" : "대출중"}",
                    ),
                    Text(
                      "책 상태: ${_condition[widget.bookData["condition"]]}",
                    ),
                  ],
                ),
                Text(
                  "판매가: ${globals.formatCurrency.format(widget.bookData["set_price"])}원",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (widget.makeFrom == "manage") {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Hero(
              tag: "${widget.bookData["_id"]}${widget.sortType}",
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.network(
                  widget.bookGroupData["image_url"],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.bookGroupData["title"].split('(')[0],
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "${widget.bookGroupData["author"]} - ${widget.bookGroupData["publisher"]} - ${widget.bookGroupData["publication_date"]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "보관 책장: ${widget.bookData["bookshelf"] == null ? "없음" : widget.bookData["bookshelf"]["name"]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      widget.state == "borrowed"
                          ? "${DateFormat('yy-MM-dd').format(DateTime.parse((MocaUser.borrowed_books.where((element) => element["book"] == widget.bookData["_id"])).toList()[0]["date"]).add(const Duration(days: 14)))}까지 반납"
                          : widget.bookData["borrower"] == null
                              ? "보관 중"
                              : "대출 중",
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.makeFrom == "favorites") {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Hero(
              tag: "${widget.bookData["_id"]}${widget.sortType}",
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.network(
                  widget.bookGroupData["image_url"],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.bookGroupData["title"].split('(')[0],
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "${widget.bookGroupData["author"]} - ${widget.bookGroupData["publisher"]} - ${widget.bookGroupData["publication_date"]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "판매가: ${widget.bookData["set_price"]}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "소유자: ${widget.bookData["owner"]["nickname"]}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            Map response;
                            bool success = false;
                            while (!success) {
                              if (liked) {
                                setState(() {
                                  liked = false;
                                });
                                response = await moca_api.Books.updateBook(
                                  transaction_type: "unlike",
                                  user_id: MocaUser.id,
                                  book_id: widget.bookData["_id"],
                                );
                              } else {
                                setState(() {
                                  liked = true;
                                });
                                response = await moca_api.Books.updateBook(
                                  transaction_type: "like",
                                  user_id: MocaUser.id,
                                  book_id: widget.bookData["_id"],
                                );
                              }
                              success = await response["success"];
                            }
                            await MocaUser.updateUser();
                          },
                          icon: liked
                              ? Icon(
                                  Icons.favorite_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                )
                              : Icon(
                                  Icons.favorite_border_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.makeFrom == "bookshelf") {
      widget.bookData["bookshelf"] = widget.bookshelfData;
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Hero(
                tag: "${widget.bookData["_id"]}${widget.sortType}",
                child: AspectRatio(
                  aspectRatio: 6 / 9,
                  child: Image.network(
                    widget.bookGroupData["image_url"],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: globals.ScreenSize.width / 2.2,
                        child: Text(
                          widget.bookGroupData["title"].split('(')[0],
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      widget.bookData["owner"]["_id"] != MocaUser.id ? const Text("") : const Text("owned"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "대출 상태: ${widget.bookData["borrower"] == null ? "보관중" : "대출중"}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "책 상태: ${_condition[widget.bookData["condition"]]}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        "판매가: ${globals.formatCurrency.format(widget.bookData["set_price"])}원",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (widget.makeFrom == "bookshelf_add") {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Image.network(
                widget.bookGroupData["image_url"],
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bookGroupData["title"].split('(')[0],
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: globals.ScreenSize.width - 64 - 20 - 80 - 86,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.bookGroupData["author"]} - ${widget.bookGroupData["publisher"]}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "판매가: ${widget.bookData["set_price"]}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "보관 책장: ${widget.bookData["bookshelf"] == null ? "없음" : widget.bookData["bookshelf"]["name"]}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selected = !selected;
                              changed = true;
                            });
                          },
                          icon: selected ? const Icon(Icons.check_box_rounded) : const Icon(Icons.check_box_outline_blank_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.makeFrom == "history") {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Hero(
              tag: "${widget.bookData["_id"]}${widget.sortType}",
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.network(
                  widget.bookGroupData["image_url"],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.bookGroupData["title"].split('(')[0],
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (widget.fullData["type"] == "rent")
                      Text(
                        "대출",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else if (widget.fullData["type"] == "lend")
                      Text(
                        "빌려감",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else if (widget.fullData["type"] == "buy")
                      Text(
                        "구매",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else if (widget.fullData["type"] == "sell")
                      Text(
                        "판매",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    Text(
                      "판매가: ${widget.bookData["set_price"]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "일시: ${widget.fullData["date"]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    {
      return Container();
    }
  }
}

class BookDetail extends StatefulWidget {
  final Map bookGroupData;
  final Map bookData;
  final String sortType;

  const BookDetail({
    super.key,
    required this.bookGroupData,
    required this.bookData,
    required this.sortType,
  });

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  late bool liked = MocaUser.liked_books.contains(widget.bookData["_id"]);
  final List<String> _condition = ["최상", "상", "중", "하"];

  late bool allowSell = widget.bookData["sell"];
  late bool allowRent = widget.bookData["rent"];
  late String bookCondition = _condition[widget.bookData["condition"]];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () {
            if (changed()) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text(
                      "수정된 책 정보를 저장하시겠습니까?",
                    ),
                    actions: [
                      TextButton(
                        child: const Text('예'),
                        onPressed: () {
                          Navigator.pop(context);
                          updateBook(context, false);
                        },
                      ),
                      TextButton(
                        child: const Text('아니오'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            }
            return Future.value(true);
          },
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: ScreenSize.width,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (changed()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                    "수정된 책 정보를 저장하시겠습니까?",
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('예'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updateBook(context, false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('아니오'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Text(
                        "목록 > 책 상세정보",
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                        width: 150,
                                        child: Hero(
                                          tag: "${widget.bookData["_id"]}${widget.sortType}",
                                          child: AspectRatio(
                                            aspectRatio: 6 / 9,
                                            child: Image.network(
                                              widget.bookGroupData["image_url"],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: ScreenSize.width - 150 - 48,
                                        height: 180,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.bookGroupData["title"],
                                              overflow: TextOverflow.clip,
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "지은이: ${widget.bookGroupData["author"]}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  "출판사: ${widget.bookGroupData["publisher"]}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  "출판연도: ${widget.bookGroupData["publication_date"]}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "판매가: ${globals.formatCurrency.format(widget.bookData["set_price"])}원",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "간단 설명",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                    text: TextSpan(
                                      text: "${widget.bookGroupData["brief_description"]}",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                  Text(
                                    "\n보관 정보",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    "보관 책장: ${widget.bookData["bookshelf"] == null ? "없음" : widget.bookData["bookshelf"]["name"]}",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "\n대출 정보",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    "책 소유자: ${widget.bookData["owner"]["nickname"]}",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  if (widget.bookData["owner"]["_id"] == MocaUser.id) ...[
                                    const Divider(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8AC894).withOpacity(0.33),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "책 관리",
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  "구매 허용",
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                              Switch(
                                                value: allowSell,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    allowSell = value;
                                                  });
                                                },
                                                activeColor: Theme.of(context).colorScheme.primary,
                                                inactiveTrackColor: Theme.of(context).colorScheme.error,
                                                inactiveThumbColor: Theme.of(context).colorScheme.error,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  "대출 허용",
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                              Switch(
                                                value: allowRent,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    allowRent = value;
                                                  });
                                                },
                                                activeColor: Theme.of(context).colorScheme.primary,
                                                inactiveTrackColor: Theme.of(context).colorScheme.error,
                                                inactiveThumbColor: Theme.of(context).colorScheme.error,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8, right: 24),
                                                child: Text(
                                                  "책 상태",
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                              DropdownMenu(
                                                initialSelection: bookCondition,
                                                textStyle: Theme.of(context).textTheme.labelMedium,
                                                menuStyle: const MenuStyle(
                                                  padding: MaterialStatePropertyAll(
                                                    EdgeInsets.symmetric(vertical: 0),
                                                  ),
                                                ),
                                                onSelected: (String? value) {
                                                  setState(() {
                                                    bookCondition = value!;
                                                  });
                                                },
                                                dropdownMenuEntries: _condition.map<DropdownMenuEntry<String>>(
                                                  (String value) {
                                                    return DropdownMenuEntry<String>(value: value, label: value);
                                                  },
                                                ).toList(),
                                              ),
                                            ],
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              updateBook(context, true);
                                            },
                                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)),
                                            child: Text(
                                              "저장",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ] else
                                    Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (widget.bookData["owner"]["_id"] != MocaUser.id)
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 75,
                              width: globals.ScreenSize.width,
                              padding: const EdgeInsets.symmetric(horizontal: 23),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.shadow,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      if (!globals.isLoggedIn) {
                                        alertLogin(context);
                                        return;
                                      }
                                      Map response;
                                      bool success = false;
                                      while (!success) {
                                        if (liked) {
                                          setState(() {
                                            liked = false;
                                          });
                                          response = await moca_api.Books.updateBook(
                                            transaction_type: "unlike",
                                            user_id: MocaUser.id,
                                            book_id: widget.bookData["_id"],
                                          );
                                        } else {
                                          setState(() {
                                            liked = true;
                                          });
                                          response = await moca_api.Books.updateBook(
                                            transaction_type: "like",
                                            user_id: MocaUser.id,
                                            book_id: widget.bookData["_id"],
                                          );
                                        }
                                        success = response["success"];
                                      }
                                      await MocaUser.updateUser();
                                    },
                                    icon: liked
                                        ? Icon(
                                            Icons.favorite_rounded,
                                            color: Theme.of(context).colorScheme.error,
                                          )
                                        : Icon(
                                            Icons.favorite_border_rounded,
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                  ),
                                  Row(
                                    children: [
                                      Opacity(
                                        opacity: widget.bookData["sell"] ? 1 : 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!globals.isLoggedIn) {
                                              alertLogin(context);
                                              return;
                                            }
                                            if (!widget.bookData["sell"]) {
                                              return;
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BuyRentBook(
                                                  bookGroupData: widget.bookGroupData,
                                                  bookData: widget.bookData,
                                                  buy: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: -1,
                                                  blurRadius: 5,
                                                  offset: Offset(3, 3),
                                                ),
                                              ],
                                            ),
                                            child: const Text("구매하기"),
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: widget.bookData["rent"] ? 1 : 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!globals.isLoggedIn) {
                                              alertLogin(context);
                                              return;
                                            }
                                            if (!widget.bookData["rent"]) {
                                              return;
                                            }
                                            if (widget.bookData["borrower"] != MocaUser.id) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BuyRentBook(
                                                    bookGroupData: widget.bookGroupData,
                                                    bookData: widget.bookData,
                                                    buy: false,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('예'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (BuildContext context) {
                                                              return FutureBuilder(
                                                                future: moca_api.Books.updateBook(
                                                                  transaction_type: "return",
                                                                  user_id: MocaUser.id,
                                                                  book_id: widget.bookData["_id"],
                                                                ),
                                                                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                                                                  if (snapshot.hasData == false) {
                                                                    return const Center(
                                                                      child: CircularProgressIndicator(),
                                                                    );
                                                                  }
                                                                  MocaUser.updateUser();
                                                                  return AlertDialog(
                                                                    content: const Text(
                                                                      "반납 처리되었습니다.",
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        child: const Text('예'),
                                                                        onPressed: () {
                                                                          Navigator.of(context).popUntil(
                                                                            (route) => route.isFirst,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text('아니오'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text("제목: "),
                                                            Flexible(
                                                              child: Text(
                                                                widget.bookGroupData["title"],
                                                                overflow: TextOverflow.clip,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(),
                                                        Text(
                                                            "반납: ${DateFormat('yy-MM-dd').format(DateTime.parse((MocaUser.borrowed_books.where((element) => element["book"] == widget.bookData["_id"])).toList()[0]["date"]).add(const Duration(days: 14)))}까지"),
                                                        const Divider(),
                                                        const Text("반납 하시겠습니까?")
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: -1,
                                                  blurRadius: 5,
                                                  offset: Offset(3, 3),
                                                ),
                                              ],
                                            ),
                                            child: widget.bookData["borrower"] != MocaUser.id ? const Text("대여하기") : const Text("반납하기"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
      ),
    );
  }

  bool changed() {
    if (allowSell != widget.bookData["sell"] || allowRent != widget.bookData["rent"] || bookCondition != _condition[widget.bookData["condition"]]) {
      return true;
    }
    return false;
  }

  dynamic updateBook(BuildContext context, bool justSave) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: moca_api.Books.updateBook(
            book_id: widget.bookData["_id"],
            user_id: MocaUser.id,
            transaction_type: "manage",
            sell: allowSell,
            rent: allowRent,
            condition: _condition.indexOf(bookCondition),
            set_price: widget.bookData["set_price"],
          ),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData == false) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            widget.bookData["sell"] = allowSell;
            widget.bookData["rent"] = allowRent;
            widget.bookData["condition"] = _condition.indexOf(bookCondition);
            return AlertDialog(
              content: const Text(
                "책 정보가 수정되었습니다.",
              ),
              actions: [
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    if (justSave) {
                      return Navigator.pop(context);
                    } else {
                      return Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  ScaffoldFeatureController alertLogin(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("로그인이 필요합니다"),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: '로그인 하기',
          onPressed: () {
            Navigator.of(context).popUntil(
              (route) => route.isFirst,
            );
          },
        ),
      ),
    );
  }
}

class BuyRentBook extends StatelessWidget {
  final Map bookGroupData;
  final Map bookData;
  final bool buy;
  BuyRentBook({
    super.key,
    required this.bookGroupData,
    required this.bookData,
    required this.buy,
  });
  final List _condition = ["최상", "상", "중", "하"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(buy ? "주문/결제" : "대여")),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            // vertical: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: -1,
                        blurRadius: 5,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("주문 상품"),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: AspectRatio(
                              aspectRatio: 6 / 9,
                              child: Image.network(
                                bookGroupData["image_url"],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Container(
                            width: globals.ScreenSize.width - 164,
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${bookGroupData["title"]}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "판매가: ${bookData["set_price"]}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "보관 책장: ${bookData["bookshelf"] == null ? "없음" : bookData["bookshelf"]["name"]}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      buy
                          ? Container()
                          : Column(
                              children: [
                                const Text("대여기간 (2주)"),
                                Text(
                                    "${DateFormat('yy-MM-dd').format(DateTime.now())} ~ ${DateFormat('yy-MM-dd').format(DateTime.now().add(const Duration(days: 14)))}"),
                                const Text("대여 기간 이후에 반납 시 1일 마다 대여비에 100원씩 추가됩니다."),
                              ],
                            ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: -1,
                        blurRadius: 5,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("캐시"),
                          Text("보유 ${MocaUser.moca_cash}원"),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.savings_rounded),
                                Text("캐시 충전하기"),
                              ],
                            ),
                            Text(">"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: -1,
                        blurRadius: 5,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: Text("위 주문내용을 확인하였으며, 결제에 동의합니다.")),
                      GestureDetector(
                        onTap: () async {
                          if (MocaUser.moca_cash < bookData["set_price"]) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                    "캐시가 부족합니다.",
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('예'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          return showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              if (buy) {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text('예'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return FutureBuilder(
                                              future: moca_api.Books.updateBook(
                                                transaction_type: "buy",
                                                user_id: MocaUser.id,
                                                book_id: bookData["_id"],
                                              ),
                                              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                                                if (snapshot.hasData == false) {
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                MocaUser.updateUser();
                                                return AlertDialog(
                                                  content: const Text(
                                                    "구매 완료 되었습니다.",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('예'),
                                                      onPressed: () {
                                                        Navigator.of(context).popUntil(
                                                          (route) => route.isFirst,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('아니오'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("제목: "),
                                          Flexible(
                                            child: Text(
                                              bookGroupData["title"],
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          const Text("새책 가격: "),
                                          Flexible(
                                            child: Text(
                                              "${bookGroupData["new_price"]}",
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("판매가: "),
                                          Flexible(
                                            child: Text(
                                              "${bookData["set_price"]}",
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          const Text("책 상태: "),
                                          Flexible(
                                            child: Text(
                                              _condition[bookData["condition"]],
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      const Text("구매 하시겠습니까?")
                                    ],
                                  ),
                                );
                              } else {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text('예'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return FutureBuilder(
                                              future: moca_api.Books.updateBook(
                                                transaction_type: "rent",
                                                user_id: MocaUser.id,
                                                book_id: bookData["_id"],
                                              ),
                                              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                                                if (snapshot.hasData == false) {
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                MocaUser.updateUser();
                                                return AlertDialog(
                                                  content: const Text(
                                                    "대여 처리되었습니다.",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('예'),
                                                      onPressed: () {
                                                        Navigator.of(context).popUntil(
                                                          (route) => route.isFirst,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('아니오'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("제목: "),
                                          Flexible(
                                            child: Text(
                                              bookGroupData["title"],
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          const Text("책 상태: "),
                                          Flexible(
                                            child: Text(
                                              _condition[bookData["condition"]],
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Text("반납: ${DateFormat('yy-MM-dd').format(DateTime.now().add(const Duration(days: 14)))}까지"),
                                      const Divider(),
                                      Text("결제 금액:${bookData["set_price"]}원\n대여비:1000원+보증금:${bookData["set_price"] - 1000}"),
                                      const Divider(),
                                      const Text("대여 하시겠습니까?")
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: buy
                              ? Text("${bookData["set_price"]}원 결제하기")
                              : Text("${bookData["set_price"]}원(대여비:1000원+보증금:${bookData["set_price"] - 1000}) 결제하기"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
