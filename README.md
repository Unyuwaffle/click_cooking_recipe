각각 BE와 AI 폴더로 나눴습니다. 각자 작업한 것들을 올려주시면 됩니다.

[참고] AI 담당자가 만든 코드는 결국 백엔드(BE)가 호출해서 사용해야 합니다. 따라서 ai 폴더를 따로 만들 수도 있지만, 많은 경우 backend 폴더 안에 ai_module 같은 폴더를 만들어 AI 코드를 통합 관리하는 것이 더 효율적일 수 있습니다.
(이건 BE 담당자와 AI 담당자가 상의해서 결정하세요!)



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
