import 'dart:io';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// location
import 'package:geolocator/geolocator.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// widgets
import 'package:app/widgets/bookshelf.dart';

// global variables
import 'package:app/globals.dart';
import 'package:app/globals.dart' as globals;

// API
import 'package:app/data/api_wrapper.dart' as moca_api;
import 'package:image_picker/image_picker.dart';

class BookshelfScreen extends StatefulWidget {
  const BookshelfScreen({super.key});

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  late ScrollController _controller;
  bool showBookshelfAdd = true;
  String curAddress = "";
  late Map<dynamic, dynamic> response;
  late List<Map<dynamic, dynamic>> bookshelves;

  getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    MocaUser.latitude = position.latitude.toString();
    MocaUser.longitude = position.longitude.toString();
    response = await moca_api.Location.coordToAddress(
      x: MocaUser.longitude,
      y: MocaUser.latitude,
    );

    setState(() {
      curAddress = "${response["documents"][0]["address"]["address_name"]}";
    });
  }

  Future<List<Map<dynamic, dynamic>>> getBookshelvesData() async {
    response = await moca_api.Bookshelves.getBookshelves(
      address_name: curAddress,
      longitude: MocaUser.longitude,
      latitude: MocaUser.latitude,
    );
    setState(() {
      bookshelves = List<Map>.from(response["items"]);
    });

    return bookshelves;
  }

  void _scrollListener() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      debugPrint("up!!");
      // setState(() {
      //   showBookshelfAdd = true;
      // });
    }

    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      debugPrint("down!!");
      // setState(() {
      //   showBookshelfAdd = false;
      // });
    }
  }

  init() async {
    response = await moca_api.Location.coordToAddress(
      x: MocaUser.longitude,
      y: MocaUser.latitude,
    );

    curAddress = "${response["documents"][0]["address"]["address_name"]}";

    await getGeoData();
    await getBookshelvesData();
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(onPressed: () {}, icon: const Icon(Icons.gps_fixed)),
              SizedBox(
                width: 280,
                child: Text(
                  curAddress,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await getGeoData();
                  await getBookshelvesData();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Stack(
              children: [
                FutureBuilder(
                  future: getBookshelvesData(),
                  builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                    if (snapshot.hasData == false) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List bookshelfList = snapshot.data!;

                    return ListView.separated(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(top: 70),
                      itemBuilder: (BuildContext context, int index) {
                        return BookshelfWidget(
                          bookshelfData: bookshelfList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(height: 5);
                      },
                      itemCount: bookshelfList.length,
                    );
                  },
                ),
                // add btn
                AnimatedPositioned(
                  height: 65,
                  top: showBookshelfAdd ? 0 : -65.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastOutSlowIn,
                  child: Container(
                    width: globals.ScreenSize.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF5).withOpacity(0.8),
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: globals.ScreenSize.width / 4,
                      vertical: 12,
                    ),
                    child: GestureDetector(
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
                            pageBuilder: (context, animation, secondaryAnimation) => const BookshelfAdd(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text('책장 등록요청', style: Theme.of(context).textTheme.labelLarge),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BookshelfAdd extends StatefulWidget {
  const BookshelfAdd({super.key});

  @override
  State<BookshelfAdd> createState() => _BookshelfAddState();
}

class _BookshelfAddState extends State<BookshelfAdd> {
  DataModel? _dataModel;

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  String bookshelfName = "";

  @override
  Widget build(BuildContext context) {
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
                      "책장목록 > 책장 등록 요청",
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
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40),
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                if (_image != null)
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    width: ScreenSize.width,
                                    child: Image.file(
                                      File(_image!.path),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 300,
                                    padding: const EdgeInsets.only(bottom: 32),
                                    width: ScreenSize.width,
                                    child: const Icon(Icons.image),
                                  ),
                                Container(
                                  height: 50,
                                  color: Colors.white70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
                                          getImage(ImageSource.camera);
                                        },
                                        child: const Text("카메라"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          //getImage 함수를 호출해서 갤러리에서 사진 가져오기
                                          getImage(ImageSource.gallery);
                                        },
                                        child: const Text("갤러리"),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("책장 이름"),
                              Container(
                                width: globals.ScreenSize.width / 1.5,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: TextField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    fillColor: Theme.of(context).colorScheme.secondary,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                  ),
                                  controller: TextEditingController(),
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  onChanged: (value) {
                                    bookshelfName = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("주소"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const LibraryDaumPostcodeScreen();
                                      },
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        _dataModel = value;
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  width: globals.ScreenSize.width / 1.5,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: _dataModel != null ? Alignment.centerLeft : Alignment.center,
                                  child: _dataModel != null ? Text("  ${_dataModel!.address}") : const Text("주소 검색"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_image != null && _dataModel != null && bookshelfName.isNotEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return FutureBuilder(
                                    future: moca_api.Bookshelves.addBookshelf(
                                      id: MocaUser.id,
                                      name: bookshelfName,
                                      address_name: _dataModel!.address,
                                      image: File(_image!.path),
                                    ),
                                    builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                                      if (snapshot.hasData == false) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return AlertDialog(
                                        content: const Text(
                                          "책장 등록요청 되었습니다.",
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              return Navigator.of(context).popUntil(
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
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                                SnackBar(
                                  content: const Center(
                                    child: Text("사진/책장이름/주소를 모두 채워야 합니다."),
                                  ),
                                  // width: 200,
                                  duration: const Duration(seconds: 1),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: globals.ScreenSize.width,
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text("책장 등록요청"),
                          ),
                        ),
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

class LibraryDaumPostcodeScreen extends StatelessWidget {
  const LibraryDaumPostcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("주소 검색")),
      body: DaumPostcodeSearch(
        webPageTitle: "주소 검색",
        initialOption: InAppWebViewGroupOptions(),
        onConsoleMessage: ((controller, consoleMessage) {}),
        onLoadError: ((controller, url, code, message) {}),
        onLoadHttpError: (controller, url, statusCode, description) {},
        onProgressChanged: (controller, progress) {},
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
      ),
    );
  }
}
