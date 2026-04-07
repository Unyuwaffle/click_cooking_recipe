import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // 화면 이동 준비 상태를 관리하는 변수
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    // 2초 뒤에 준비 상태를 true로 변경
    _prepareToNavigate();
  }

  _prepareToNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      setState(() {
        _isReady = true; // 문구를 띄우기 위해 상태 업데이트
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // 1. GestureDetector로 화면 전체의 터치를 감지
      body: GestureDetector(
        onTap: () {
          // 준비가 된 상태에서 터치하면 홈 화면으로 이동
          if (_isReady && mounted) {
            context.go('/home');
          }
        },
        child: Stack( // 문구를 아래쪽에 배치하기 위해 Stack 사용
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.soup_kitchen,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '찰칵! 쿠킹 레시피',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // 준비 중일 때는 로딩바를, 준비 완료 시에는 빈 공간 표시
                  if (!_isReady)
                    const CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
            // 2. 화면 아래쪽 즈음에 문구 표시
            if (_isReady)
              const Positioned(
                bottom: 80, // 아래에서부터의 거리
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      '화면을 터치해주세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    // 반짝이는 효과를 위해 아이콘 추가 가능 (선택 사항)
                    Icon(Icons.touch_app, color: Colors.white70, size: 20),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}