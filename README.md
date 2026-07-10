
# 퐁당 (Pong-Dang) 🌊

> **일상 속 이미지를 펀치로 퐁당! 크롭하여 나만의 디지털 도감과 다꾸를 완성하는 감성 앱**

퐁당(Pong-Dang)은 소중한 일상의 기억이나 좋아하는 이미지를 귀여운 프레임 펀치로 잘라내어 나만의 컬렉션을 만들고, 다이어리 꾸미기(다꾸) 스페이스에서 스티커처럼 활용할 수 있는 Flutter 기반 하이브리드 애플리케이션입니다.

---

## ✨ 주요 기능 (Key Features)

* **F1-PUNCH: 디지털 펀치 (이미지 크롭)**
    * `CustomClipper<Path>` 기반의 비정형 커스텀 마스킹 기술 적용
    * 6종 감성 프레임 지원: 엽서, 우유곽, 원형, 사각, 폴라로이드, 하트
    * 투명 PNG 형태의 고해상도 캡처 및 크롭 기능
* **F2-REGISTRY & F3-VIEWER: 도감 시스템** *(개발 예정)*
    * 크롭한 이미지를 카테고리별로 분류하고 평점 및 메모와 함께 등록 및 조회
* **F5-STORAGE: 안전한 로컬 데이터 관리** *(개발 예정)*
    * 자동 로컬 백업 및 ZIP 형식의 데이터 내보내기/가져오기 기능 지원
* **F6-THEME: 감성 테마 시스템** *(디자인 확정)*
    * 복숭아 우유(Peach Milk - 기본), 민트 소다(Mint Soda), 포도 캔디(Grape Candy) 3종 컬러 테마 제공

---

## 🛠 기술 스택 (Tech Stack)

* **Framework:** Flutter (v3.44.6)
* **State Management:** Riverpod
    * 컴파일 타임 안정성 확보 및 유지보수성 향상을 위해 채택
* **Local Database:** sqflite (SQLite)
    * 폴더 계층 구조 관리 및 향후 클라우드 동기화(Supabase 등) 확장성을 고려하여 관계형 DB 채택
* **Gesture Control:** 네이티브 `GestureDetector.onScale*` 매트릭스 제어

---

## 📂 프로젝트 구조 (Folder Structure)


```

pong_dang/
├── app/                             # Flutter 메인 프로젝트 앱 소스
│   └── lib/
│       ├── models/                  # 데이터 모델 (프레임 타입 등)
│       ├── screens/                 # 주요 화면 (홈, 펀치 모드 등)
│       └── widgets/                 # 공통 컴포넌트 및 커스텀 클리퍼
├── docs/                            # 프로젝트 기획 및 디자인 명세서
└── PROGRESS.md                      # 프로젝트 진행 로그 및 세션 기록

```


---

## 🚀 시작하기 (Getting Started)

### 사전 준비 사항
* Flutter SDK (v3.44.6 이상 권장)
* Chrome 웹 브라우저 (또는 타겟 디바이스 개발 환경)

### 설치 및 실행 방법

1. **저장소 클론**
```bash
git clone [https://github.com/leesuin0710/pong-dang.git](https://github.com/leesuin0710/pong-dang.git)
cd pong-dang/app

```

2. **의존성 패키지 다운로드**
```bash
flutter pub get

```


3. **애플리케이션 실행 (Chrome Web)**
```bash
flutter run -d chrome

```



---

## 📅 프로젝트 로드맵 (Roadmap)

* **Phase 1-1: 화면 구조화 및 디자인 가이드 확정** ✅
* **Phase 1-2: 핵심 기술 검증 및 펀치 UI 구현** ✅
* **Phase 1-3: 로컬 MVP 개발 (로컬 DB 연동 및 도감 등록)** 🔄 (진행 예정)
* **Phase 2: 다꾸 스페이스 기능 확장** ⏳ (대기 중)

---

### 💡 팁
* 프로젝트 내부에서 UI 테스트 시 `Ctrl + S`를 통한 **Hot Reload**를 적극 활용하면 디자인 확인이 빨라집니다.
* 전체적인 작업 진행 세부 로그는 상위 디렉토리의 `PROGRESS.md`에서 확인하실 수 있습니다.

