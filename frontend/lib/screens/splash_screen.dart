import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _prepareToNavigate();
  }

  // 2.5초 대기 로직
  _prepareToNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 색상 정의
    const darkGreen = Color(0xFF1E6027);
    const lightGreen = Color(0xFF98E38D);
    const grayDot = Color(0xFFCDD5C0);
    const grayText = Color(0xFF444444);

    // 그라데이션 강화 (상단 연두색 -> 하단 흰색)
    const enhancedBgTop = Color(0xFFE8F5E9);
    const enhancedBgBottom = Color(0xFFFFFFFF);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 준비 완료 시 터치하면 홈으로 이동
          if (_isReady && mounted) {
            context.go('/home');
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [enhancedBgTop, enhancedBgBottom],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로고 섹션 (국자 아이콘으로 교체)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: darkGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.soup_kitchen, color: Colors.white, size: 70),
                      ),
                      Positioned(
                        top: 5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: lightGreen,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.eco, color: darkGreen, size: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // 타이틀 섹션
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 36, letterSpacing: -1.5),
                      children: [
                        TextSpan(
                          text: 'Click ',
                          style: TextStyle(
                            color: darkGreen,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: 'Cooking Recipe',
                          style: TextStyle(color: grayText, fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 하단 상태 표시 섹션
              Positioned(
                bottom: 120,
                child: Column(
                  children: [
                    if (!_isReady)
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Dot(color: darkGreen),
                          SizedBox(width: 8),
                          _Dot(color: lightGreen),
                          SizedBox(width: 8),
                          _Dot(color: grayDot),
                        ],
                      )
                    else ...[
                      const Text(
                        '화면을 터치해주세요',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Icon(Icons.touch_app, color: Colors.black26),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🛠️ 에러가 났던 점 위젯의 올바른 구현부
class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}