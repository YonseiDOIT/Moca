import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

// global variables
import 'package:app/globals.dart';
import 'package:app/globals.dart' as globals;

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

// pages
import 'cash_page.dart';
import 'favorites_page.dart';
import 'history_page.dart';
import 'settings_page.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();

  Future<void> showLoginPopup(BuildContext context) {
    late OAuthToken token;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('로그인', style: TextStyle(fontSize: 30)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "assets/images/app_icon.png",
                    height: 100,
                    cacheHeight: 100,
                  ),
                ),
                Transform.scale(
                  scale: 3,
                  child: IconButton(
                    onPressed: () async {
                      debugPrint("카카오 로그인");

                      if (await isKakaoTalkInstalled()) {
                        try {
                          debugPrint("카카오 로그인 시도");
                          token = await UserApi.instance.loginWithKakaoTalk();
                          debugPrint('카카오톡으로 로그인 성공 ${token.accessToken}');
                        } catch (error) {
                          debugPrint('카카오톡으로 로그인 실패 $error');
                          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                        }
                      }

                      try {
                        debugPrint("카카오 로그인 시도");
                        token = await UserApi.instance.loginWithKakaoAccount();
                        debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
                      } catch (error) {
                        debugPrint('카카오계정으로 로그인 실패 $error');
                      }

                      try {
                        User user = await UserApi.instance.me();
                        debugPrint("$user");
                        try {
                          Map userApiData;
                          int temp = 0;
                          do {
                            userApiData = await moca_api.Users.addUser(
                              username: user.kakaoAccount!.profile!.nickname!,
                              nickname: "${user.kakaoAccount!.profile!.nickname!}${(user.id).toString().substring(0, 2)}$temp",
                              email: user.kakaoAccount!.email!,
                              kakao_id: "${user.id}",
                              image_url: user.kakaoAccount!.profile!.thumbnailImageUrl ??
                                  "https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110",
                            );

                            temp += 1;
                          } while (!bool.parse(userApiData["acknowledged"], caseSensitive: false));

                          await MocaUser.setUser(userApiData["user_id"]);

                          debugPrint("서버 연동 완료");

                          try {
                            preferences.saveLocal("moca_user", MocaUser.toMap());

                            globals.isLoggedIn = true;

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop(); // 팝업 닫기
                          } catch (error) {
                            debugPrint('로컬 저장 실패 $error');
                          }
                        } catch (error) {
                          debugPrint('백엔드 오류 $error');
                        }
                      } catch (error) {
                        debugPrint('사용자 정보 요청 실패 $error');
                      }
                    },
                    icon: Image.asset("assets/images/kakao_login_large_narrow.png"),
                    iconSize: 50,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MyPageScreenState extends State<MyPageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _setIndex(int index) {
    setState(() {
      _tabController.index = index;
      // print(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5, animationDuration: Duration.zero);
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
          MyPage(setParentIndex: _setIndex),
          CashPage(setParentIndex: _setIndex),
          FavoritesPage(setParentIndex: _setIndex),
          HistoryPage(setParentIndex: _setIndex),
          SettingsPage(setParentIndex: _setIndex),
        ],
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({
    super.key,
    required this.setParentIndex,
  });
  final Function(int index) setParentIndex;
  static List<String> menuTextList = ["캐시 관리", "찜한 목록 보기", "사용 내역 보기", "환경 설정"];
  static List<Icon> menuIconList = [
    const Icon(Icons.savings_rounded),
    const Icon(Icons.favorite),
    const Icon(Icons.history),
    const Icon(Icons.settings)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Container(
            height: 80,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "마이페이지",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Image.asset("assets/images/cat lies on open books.png")
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // profile
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(ScreenSize.width / 6),
                            child: MocaUser.image_url.isNotEmpty
                                ? Image.network(
                                    MocaUser.image_url,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.account_circle),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                MocaUser.nickname,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '안녕하세요!',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  // 회원정보 수정 기능 추가
                                  // globals.isLoggedIn = false;
                                  // globals.preferences.deleteLocal("moca_user");
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  '회원정보 수정 >',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // cash owned
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '보유중인 캐시',
                          style: Theme.of(context).textTheme.labelLarge,
                          selectionColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 32),
                        ),
                        Text(
                          "${MocaUser.moca_cash}원",
                          style: Theme.of(context).textTheme.labelLarge,
                        )
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setParentIndex(index + 1);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: menuIconList[index],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        menuTextList[index],
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 24),
                                  child: Text(
                                    ">",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0,
                          indent: 12,
                          endIndent: 12,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                      itemCount: 4,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
