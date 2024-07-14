import 'package:flutter/material.dart';

// global variablesa
import 'package:app/globals.dart' as globals;

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.setParentIndex,
  });
  final Function(int index) setParentIndex;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return setParentIndex(0);
      },
      child: Container(
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
                      setParentIndex(0);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  Text(
                    "마이페이지 > 환경 설정",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(55)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "계정 정보",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "아이디",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    "로그아웃>",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "알림설정",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                // vertical: 8,
                              ),
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "PUSH 알림 수신",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Switch(
                                    value: true,
                                    onChanged: (bool value) {},
                                    activeColor: Theme.of(context).colorScheme.primary,
                                    inactiveTrackColor: Theme.of(context).colorScheme.error,
                                    inactiveThumbColor: Theme.of(context).colorScheme.error,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "버전 관리",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "현재 버전",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    "최신 버전",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "고객 센터",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "문의하기",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    ">",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "회원탈퇴",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    ">",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
