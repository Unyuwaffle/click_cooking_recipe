import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. dotenv 패키지 임포트
import 'router.dart';

// 2. main 함수를 비동기(async)로 변경
Future<void> main() async {
  // 3. 비동기로 데이터를 로드하기 전 Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 4. .env 파일 로드
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: '찰칵! 쿠킹 레시피',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B6B), // 따뜻한 빨간색
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
          ),
        ),
        useMaterial3: true,
      ),
      // home: 속성은 라우터가 관리하므로 사용하지 않음
    );
  }
}

// 5. 사용하지 않는 기본 템플릿용 MyHomePage 전체 삭제 완료!