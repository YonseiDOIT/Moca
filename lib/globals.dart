// ignore_for_file: non_constant_identifier_names

library globals;

import 'package:app/data/shared_pref.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

late String kakaoAppKey;
late String kakaoRestApiKey;
bool isLoggedIn = false;
Preferences preferences = Preferences();
late SharedPreferences localData;
NumberFormat formatCurrency = NumberFormat('###,###');

class MocaUser {
  static String id = "";
  static String nickname = "";
  static String email = "";
  static String kakao_id = "";
  static String image_url = "";
  static String phone_number = "";
  static String created_at = "";

  static int check_out_count = 0;
  static int overdue_count = 0;
  static int purchase_count = 0;
  static int damage_count = 0;
  static int moca_cash = 0;

  static bool local = true;

  static List owned_books = [];
  static List borrowed_books = [];

  static List use_hist = [];
  static List trade_hist = [];

  static List liked_books = [];
  static List liked_bookshelves = [];

  // not in DB
  static String latitude = "";
  static String longitude = "";

  static Future<void> setUser(String userId) async {
    Map userData;

    userData = await moca_api.Users.getUser(id: userId);

    id = userData["_id"];
    nickname = userData["nickname"];
    email = userData["email"];
    kakao_id = userData["kakao_id"];
    image_url = userData["image_url"];
    phone_number = userData["phone_number"];
    created_at = userData["created_at"];

    check_out_count = userData["check_out_count"];
    overdue_count = userData["overdue_count"];
    purchase_count = userData["purchase_count"];
    damage_count = userData["damage_count"];
    moca_cash = userData["moca_cash"];

    local = userData["local"];

    owned_books = userData["owned_books"];
    borrowed_books = userData["borrowed_books"];

    use_hist = userData["use_hist"];
    trade_hist = userData["trade_hist"];

    liked_books = userData["liked_books"];
    liked_bookshelves = userData["liked_bookshelves"];
  }

  static Future<void> updateUser() async {
    Map userData;
    userData = await moca_api.Users.getUser(id: id);

    id = userData["_id"];
    nickname = userData["nickname"];
    email = userData["email"];
    kakao_id = userData["kakao_id"];
    image_url = userData["image_url"];
    phone_number = userData["phone_number"];
    created_at = userData["created_at"];

    check_out_count = userData["check_out_count"];
    overdue_count = userData["overdue_count"];
    purchase_count = userData["purchase_count"];
    damage_count = userData["damage_count"];
    moca_cash = userData["moca_cash"];

    local = userData["local"];

    owned_books = userData["owned_books"];
    borrowed_books = userData["borrowed_books"];

    use_hist = userData["use_hist"];
    trade_hist = userData["trade_hist"];

    liked_books = userData["liked_books"];
    liked_bookshelves = userData["liked_bookshelves"];
  }

  static void fromMap(Map userData) {
    id = userData["_id"];
    nickname = userData["nickname"];
    email = userData["email"];
    kakao_id = userData["kakao_id"];
    image_url = userData["image_url"];
    phone_number = userData["phone_number"];
    created_at = userData["created_at"];

    check_out_count = userData["check_out_count"];
    overdue_count = userData["overdue_count"];
    purchase_count = userData["purchase_count"];
    damage_count = userData["damage_count"];
    moca_cash = userData["moca_cash"];

    local = userData["local"];

    owned_books = userData["owned_books"];
    borrowed_books = userData["borrowed_books"];

    use_hist = userData["use_hist"];
    trade_hist = userData["trade_hist"];

    liked_books = userData["liked_books"];
    liked_bookshelves = userData["liked_bookshelves"];
  }

  static Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "_id": id,
      "nickname": nickname,
      "email": email,
      "kakao_id": kakao_id,
      "image_url": image_url,
      "phone_number": phone_number,
      "created_at": created_at,
      "check_out_count": check_out_count,
      "overdue_count": overdue_count,
      "purchase_count": purchase_count,
      "damage_count": damage_count,
      "moca_cash": moca_cash,
      "local": local,
      "owned_books": owned_books,
      "borrowed_books": borrowed_books,
      "use_hist": use_hist,
      "trade_hist": trade_hist,
      "liked_books": liked_books,
      "liked_bookshelves": liked_bookshelves,
    };
    return data;
  }
}

class ScreenSize {
  static late double size;
  static late double height;
  static late double width;
  static late double pixelRatio;
  static late double topPadding;
  static late double bottomPadding;

  // MediaQuery.of(context).size             //앱 화면 크기 size  Ex> Size(360.0, 692.0)
  // MediaQuery.of(context).size.height      //앱 화면 높이 double Ex> 692.0
  // MediaQuery.of(context).size.width       //앱 화면 넓이 double Ex> 360.0
  // MediaQuery.of(context).devicePixelRatio //화면 배율    double Ex> 4.0
  // MediaQuery.of(context).padding.top      //상단 상태 표시줄 높이 double Ex> 24.0
}
