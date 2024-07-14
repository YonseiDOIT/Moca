import 'package:flutter/material.dart';

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

// widgets
import 'package:app/widgets/book.dart';

// global variables
import 'package:app/globals.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.setShowAppbar});
  final Function(bool state) setShowAppbar;

  @override
  State<BookScreen> createState() => BookScreenState();
}

class BookScreenState extends State<BookScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // int _selectedIndex = 0;

  int _setIndex(int index) {
    if (index == -1) {
      return _tabController.index;
    }
    setState(() {
      _tabController.index = index;
      if (index == 0) {
        widget.setShowAppbar(true);
      } else {
        _tabController.index = index;
        widget.setShowAppbar(false);
      }
    });
    return -1;
  }

  void _bookGroupData(Map groupData) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, animationDuration: Duration.zero);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          BooksList(
            setParentIndex: _setIndex,
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: BooksListMore(
              setParentIndex: _setIndex,
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: BooksListMore(
              setParentIndex: _setIndex,
            ),
          ),
        ],
      ),
    );
    //
  }
}

class BooksList extends StatelessWidget {
  const BooksList({
    super.key,
    required this.setParentIndex,
  });
  final Function(int index) setParentIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "새로 등록된 중고책",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextButton(
                  onPressed: () {
                    setParentIndex(1);
                  },
                  child: Text(
                    "더보기 >",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            ],
          ),
          Stack(
            children: [
              FutureBuilder(
                future: moca_api.Books.getGroups(sort: "new_book.created_at"),
                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                  if (snapshot.hasData == false) {
                    return const SizedBox(
                      height: 270,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  List bookGroup = snapshot.data!["items"];

                  return SizedBox(
                    height: 270,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: bookGroup.length,
                      itemBuilder: (BuildContext context, int index) {
                        int positionNum = 1;
                        if (index == 0) {
                          positionNum = 0;
                        } else if (index == (bookGroup.length - 1)) {
                          positionNum = 2;
                        }
                        return BookGroupWidget(
                          cardView: true,
                          bookGroupData: bookGroup[index],
                          sortType: "new_book.created_at",
                          positionNum: positionNum,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "현재 인기인 중고책",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextButton(
                  onPressed: () {
                    setParentIndex(2);
                  },
                  child: Text(
                    "더보기 >",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            ],
          ),
          FutureBuilder(
            future: moca_api.Books.getGroups(sort: "score"),
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
              if (snapshot.hasData == false) {
                return const SizedBox(
                  height: 270,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              List bookGroup = snapshot.data!["items"];
              return SizedBox(
                height: 270,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: bookGroup.length,
                  itemBuilder: (BuildContext context, int index) {
                    int positionNum = 1;
                    if (index == 0) {
                      positionNum = 0;
                    } else if (index == (bookGroup.length - 1)) {
                      positionNum = 2;
                    }
                    return BookGroupWidget(
                      cardView: true,
                      bookGroupData: bookGroup[index],
                      sortType: "score",
                      positionNum: positionNum,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BooksListMore extends StatelessWidget {
  const BooksListMore({
    super.key,
    required this.setParentIndex,
  });
  final Function(int index) setParentIndex;
  static String filterText = "";
  static String apiText = "";
  static late int currIndex;

  @override
  Widget build(BuildContext context) {
    currIndex = setParentIndex(-1);
    if (currIndex == 1) {
      filterText = "최신순";
      apiText = "new_book.created_at";
    } else if (currIndex == 2) {
      filterText = "인기순";
      apiText = "score";
    }
    return WillPopScope(
      onWillPop: () {
        return setParentIndex(0);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: IconButton(
                    onPressed: () {
                      setParentIndex(0);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "중고책 전체 목록",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  filterText,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                IconButton(
                  onPressed: () {
                    if (currIndex == 1) {
                      setParentIndex(2);
                    } else if (currIndex == 2) {
                      setParentIndex(1);
                    }
                  },
                  icon: const Icon(Icons.filter_alt_rounded, size: Checkbox.width),
                ),
              ],
            ),
            FutureBuilder(
              future: moca_api.Books.getGroups(sort: apiText),
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                if (snapshot.hasData == false) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
                List bookGroup = snapshot.data!["items"];
                return Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: bookGroup.length,
                    itemBuilder: (BuildContext context, int index) {
                      int positionNum = 1;
                      if (index == 0) {
                        positionNum = 0;
                      } else if (index == (bookGroup.length - 1)) {
                        positionNum = 2;
                      }

                      return BookGroupWidget(
                        cardView: false,
                        bookGroupData: bookGroup[index],
                        sortType: apiText,
                        positionNum: positionNum,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 5);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
