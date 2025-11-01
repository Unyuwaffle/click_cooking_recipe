각각 BE와 AI 폴더로 나눴습니다. 각자 작업한 것들을 올려주시면 됩니다.

[참고] AI 담당자가 만든 코드는 결국 백엔드(BE)가 호출해서 사용해야 합니다. 따라서 ai 폴더를 따로 만들 수도 있지만, 많은 경우 backend 폴더 안에 ai_module 같은 폴더를 만들어 AI 코드를 통합 관리하는 것이 더 효율적일 수 있습니다.
(이건 BE 담당자와 AI 담당자가 상의해서 결정하세요!)




🍳 ClickCookingRecipe FE 개발 가이드
이 문서는 ClickCookingProject의 Frontend(frontend/) 개발 환경을 세팅하고, 원활한 협업을 위한 코드 작성 규칙을 정의합니다. FE 담당자는 개발 시작 전 이 문서를 반드시 숙지합니다.

1. 💻 개발 환경 세팅 가이드 (Environment Setup)
1.1. 필수 설치 도구
Flutter SDK

flutter doctor 명령어로 설치 상태 확인

Android Studio

Android SDK 및 에뮬레이터(AVD) 설치용

Git


(선택) VS Code

Dart 및 Flutter Extension 설치

1.2. 프로젝트 클론 및 실행
프로젝트를 클론(Clone) 받습니다.

Bash

git clone [팀의 GitHub 저장소 URL]
frontend 폴더로 이동합니다.

Bash

cd ClickCookingProject/frontend
패키지를 설치합니다.

Bash

flutter pub get
안드로이드 스튜디오 (또는 VS Code)에서 프로젝트를 열고, 시뮬레이터를 실행한 뒤 Run 합니다.

2. 🌳 Git 브랜치 전략 (Git Branch Strategy)

main

배포용 브랜치. (절대 직접 Push 금지)

develop

개발의 중심이 되는 브랜치.

모든 feature 브랜치는 develop에서 시작해서 develop으로 Merge(PR)됩니다.

feature/[담당자]/[기능]

실제 작업 브랜치.

develop에서 브랜치를 생성합니다. (예: feature/FE1/setup-routing, feature/FE2/design-theme)

작업 완료 후 develop 브랜치로 **Pull Request (PR)**를 보냅니다.

3. ✍️ 코딩 컨벤션 (Coding Convention)
3.1. 기본 원칙
Lint 규칙 준수: analysis_options.yaml 파일에 정의된 Lint 규칙을 100% 준수합니다. (예: const 키워드 사용, file_names 규칙)

영어 주석: 모든 주석은 영어로 작성합니다. (You requested this)

3.2. 폴더 구조 (Directory Structure)
lib 폴더는 아래와 같은 구조를 따릅니다.

lib/
 ├── common/         # 공통 로직, 유틸리티
 |   └── utils/
 ├── widgets/        # 공통으로 사용하는 위젯 (예: PrimaryButton.dart)
 ├── data/
 |   ├── models/     # API 응답 DTO (예: recipe_model.dart)
 |   └── services/   # API 통신 로직 (예: api_service.dart)
 ├── screens/        # 실제 화면 페이지
 |   ├── home/
 |   |   └── home_screen.dart
 |   ├── camera/
 |   |   └── camera_screen.dart
 |   └── result/
 |       └── result_screen.dart
 ├── provider/       # 상태 관리 (Riverpod)
 |   └── recipe_provider.dart
 └── router.dart     # GoRouter 설정
3.3. 상태 관리 (State Management)
Riverpod (flutter_riverpod)를 사용합니다.

Provider 분리:

api_service.dart (데이터 통신)는 Provider로 만듭니다.

API에서 받아온 '상태' (데이터, 로딩, 에러)는 FutureProvider 또는 AsyncNotifierProvider로 관리합니다.

사용자 입력 등 화면 내의 간단한 상태는 StatefulWidget 또는 StateProvider를 사용할 수 있습니다.

ref.watch vs ref.read

build 메소드 내에서 화면에 표시할 데이터를 가져올 때는 **ref.watch()**를 사용합니다.

버튼 클릭 시 로직(함수)을 실행할 때는 **ref.read()**를 사용합니다.

3.4. 네이밍 규칙 (Naming Convention)
파일: snake_case (소문자, 언더스코어). (예: home_screen.dart)

클래스/위젯: PascalCase (대문자 시작). (예: RecipeCard)

변수/함수: camelCase (소문자 시작). (예: fetchRecipes)

상수: k로 시작하는 camelCase. (예: kPrimaryColor)
