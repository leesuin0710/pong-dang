# 퐁당 (Pong-Dang) 프로젝트 진행 로그

> 이 파일은 프로젝트 진행 상황을 기록하여 세션 간 연속성을 유지하기 위한 문서입니다.
> 새로운 세션 시작 시 이 파일을 먼저 읽어주세요.

---

## 프로젝트 개요

- **앱 이름**: 퐁당 (Pong-Dang)
- **콘셉트**: 일상 속 이미지를 펀치로 크롭하여 디지털 도감/다꾸로 활용하는 감성 앱
- **기술 스택**: Flutter (하이브리드)
- **개발 방식**: Claude AI 협업 개발

---

## 주요 파일 구조

```
pong_dang/
├── app_planning_pong_dang.pdf      # 기획안 원본
├── pong_dang_project_roadmap.xlsx  # 일정표 원본
├── PROGRESS.md                      # 진행 로그 (이 파일)
├── docs/
│   ├── T101_phase1_feature_spec.md # Phase 1 기능 명세서
│   ├── T102_wireframe.md           # 화면 와이어프레임
│   └── T103_design_guide.md        # 디자인 가이드
└── app/                             # Flutter 프로젝트 (T201, 2026-07-10 생성)
```

> Flutter SDK 설치 위치: `C:\src\flutter` (User PATH 등록됨)
> GitHub 저장소: https://github.com/leesuin0710/pong-dang (2026-07-10 연동, `main` 브랜치) — 이후 작업 단위별로 커밋/푸시하며 진행

---

## 현재 진행 상태

### Phase 1-1: 화면 구조화 ✅ 완료 (2026-07-08, 1일 만에 완료!)

| 태스크 ID | 작업 내용 | 완료일 | 산출물 |
|-----------|----------|--------|--------|
| T101 | 아이디어 기반 기능 정의 리스트 확정 | 2026-07-08 | `docs/T101_phase1_feature_spec.md` |
| T102 | 주요 화면 와이어프레임 구성 | 2026-07-08 | `docs/T102_wireframe.md` |
| T103 | UI/UX 컬러 톤앤매너 및 디자인 에셋 준비 | 2026-07-08 | `docs/T103_design_guide.md` |

### Phase 1-2: 기술 검증 ✅ 완료 (2026-07-11)

| 태스크 ID | 작업 내용 | 완료일 | 산출물 |
|-----------|----------|--------|--------|
| T201 | Flutter 개발 환경 세팅 | 2026-07-10 | `app/` (Flutter 3.44.6, Chrome 검증 완료) |
| T202 | 이미지 크롭 패키지 테스트 및 펀치 UI 구현 | 2026-07-10 | `app/lib/screens/punch/`, `app/lib/widgets/frame_clipper.dart` — 6종 프레임(엽서/우유곽/원형/사각/폴라로이드/하트) 커스텀 마스킹 + 투명 PNG 크롭 캡처, Chrome에서 검증 완료 |
| T203 | 다꾸 스페이스 스티커 제어 검증 (드래그/확대/회전 구현) | 2026-07-11 | `app/lib/models/sticker.dart`, `app/lib/screens/deco/sticker_canvas_screen.dart` — `GestureDetector.onScale*` 기반 이동/확대/회전 동시 처리, 스티커 추가(팔레트)/선택(테두리 표시, 맨 앞으로)/삭제/전체삭제, 홈 화면 우측 상단 ✨ 버튼으로 진입. `flutter analyze` 통과, Chrome 기동 검증 완료(제스처 조작은 실제 Chrome 창에서 수동 확인 필요 — 헤드리스 브라우저 자동화 도구 미가용) |

### Phase 1-3: 로컬 MVP 개발 ✅ 완료 (2026-07-11)

| 태스크 ID | 작업 내용 | 완료일 | 산출물 |
|-----------|----------|--------|--------|
| T301 | 로컬 DB(sqflite) 구조 설계 | 2026-07-11 | `app/lib/data/db/schema.dart`, `app/lib/data/db/app_database.dart`, `app/lib/data/collection_repository.dart`, `app/lib/models/folder.dart`, `app/lib/models/collection_item.dart` — folders/items/labels/item_labels 정규화 테이블 + FK(ON DELETE CASCADE/SET NULL) + 인덱스. `sqflite_common_ffi`로 `test/data/collection_repository_test.dart` 작성해 검증(순차 도감번호 부여, 라벨 중복방지, 폴더 삭제 시 아이템 미분류 처리) — sqflite는 Flutter Web 미지원이라 Chrome 대신 순수 Dart 테스트로 확인 |
| T302 | 도감 등록 및 리스트 조회 화면 개발 | 2026-07-11 | `app/lib/screens/register/register_form_screen.dart`(태그/별점/메모 입력 후 저장), `app/lib/screens/detail/item_detail_screen.dart`(상세 보기 + 삭제), `app/lib/screens/home_screen.dart`(2열 그리드 뷰 + 최신순/별점순 정렬), `app/lib/services/image_storage_service.dart`(원본 저장 + `image` 패키지로 썸네일 생성, F2.6), `app/lib/providers/repository_providers.dart`(Riverpod DI), `app/lib/main.dart`(앱 시작 시 DB 오픈 후 주입). 크롭 결과 화면(T202 산출물)은 실제 등록 폼으로 교체됨. **실제 안드로이드 기기(삼성 SM-S936N)에 설치해 등록→그리드→상세→삭제 전체 플로우 수동 검증 완료** (Android SDK 신규 설치 + AGP 9.0.1→8.11.1 다운그레이드로 빌드 문제 해결 — 아래 이슈 참고) |
| T303 | 폴더 생성 및 카테고리 분류 시스템 구현 | 2026-07-11 | `app/lib/screens/folder/folder_list_screen.dart`(루트 폴더 목록 + 통계 + 생성), `app/lib/screens/folder/folder_detail_screen.dart`(서브폴더 최대 2단계 + 폴더 내 그리드 + 편집/삭제/병합), `app/lib/widgets/folder_form_dialog.dart`, `app/lib/widgets/folder_picker.dart`, `app/lib/widgets/collection_grid_view.dart`(그리드 렌더링 공용화). 홈 화면에 하단 네비게이션(도감/폴더 탭) 추가, 등록 폼·상세 화면에 폴더 선택/이동(F4.3) 연결. 리포지토리에 폴더 CRUD/통계/병합/이동 추가, 유닛테스트 7건 추가. **실기기에서 폴더 생성→아이템 이동→통계 반영까지 검증, 실기기 조작 중 실제 버그 2건 발견·수정**(등록 폼 태그 위치 관련 setState 오류는 아님 — 아래 참고) |

### Phase 2: 디지털 다꾸 및 달력 연동 (진행 중)

| 태스크 ID | 작업 내용 | 완료일 | 산출물 |
|-----------|----------|--------|--------|
| T401 | 달력(캘린더) 기본 폼 UI 구현 | 2026-07-11 | `docs/T401_phase2_feature_spec.md`(Phase 2 상세 기능 명세, T101과 동급), `app/lib/models/deco_entry.dart`, `app/lib/data/deco_repository.dart`, `app/lib/screens/calendar/calendar_screen.dart`(월별 그리드, 오늘 강조, 날짜별 점/개수 배지), `app/lib/widgets/deco_entry_list_sheet.dart`(하루 여러 장 다꾸 목록), `app/lib/screens/deco/deco_space_screen.dart`(T402 전까지의 스텁 화면). DB 스키마에 `deco_entries`/`deco_placements` 추가 + `onUpgrade` 마이그레이션(v1→v2). 홈 화면에 "달력" 탭(3번째) 추가. 유닛테스트 3건 추가. **실기기 검증 + 유저 피드백으로 설계 수정 2건**: (1) 날짜를 열기만 해도 `DecoEntry`가 생성되던 문제 → 실제 저장 전까지 엔트리 생성을 미루도록 수정, (2) "변경 사항 없으면 저장 버튼 비활성화"로 수정(빈 저장 방지). setState/Future 버그(T302에서 발견한 것과 동일 패턴)도 캘린더 화면에서 재발 → 동일하게 수정 |

### 진행 중인 태스크

| 태스크 ID | 작업 내용 | 시작일 | 상태 |
|-----------|----------|--------|------|
| T402 | 날짜별 다꾸 스페이스 — 스티커/텍스트 배치 및 자동 저장(디바운스) 로직 | 2026-07-11 | 다음 세션에서 착수 예정 |

### 대기 중인 태스크

**Phase 2: 디지털 다꾸 및 달력 연동**
| 태스크 ID | 작업 내용 | 관련 |
|-----------|----------|------|
| T403 | 다꾸 결과물 이미지 저장 및 공유 기능 | `docs/T401_phase2_feature_spec.md` F9-DECO-EXPORT |

---

## 세션별 작업 기록

### Session 1 (2026-07-08)

**작업 내용:**
1. 기획안 PDF (`app_planning_pong_dang.pdf`) 분석
2. 일정표 Excel (`pong_dang_project_roadmap.xlsx`) 분석
3. T101 태스크 수행: Phase 1 MVP 기능 명세서 작성
4. 백업 기능 보강: 앱스토어 배포 고려하여 F5-STORAGE 기능 확장
   - 수동 백업 → 자동 로컬 백업으로 변경
   - 데이터 내보내기/가져오기 기능 추가 (ZIP 형식)
   - Phase 3 클라우드 동기화 로드맵 명시

**도출된 Phase 1 핵심 기능:**
- F1-PUNCH: 디지털 펀치 (이미지 크롭)
- F2-REGISTRY: 도감 등록 시스템
- F3-VIEWER: 도감 조회/탐색
- F4-FOLDER: 폴더 분류 시스템
- F5-STORAGE: 로컬 데이터 저장 + 자동백업 + 내보내기/가져오기

**생성된 파일:**
- `docs/T101_phase1_feature_spec.md` - 상세 기능 명세서 (v0.2)

**T102 와이어프레임 작업:**
- 화면 흐름도 (Mermaid) 작성
- 8개 주요 화면 와이어프레임:
  1. 홈/메인 화면 (도감 그리드)
  2. 폴더 목록 화면
  3. 펀치 모드 - 이미지 선택
  4. 펀치 모드 - 프레임 선택 & 크롭
  5. 등록 폼 화면
  6. 도감 상세 화면
  7. 설정 화면
  8. 백업/복원 화면
- 공통 컴포넌트 정의 (CollectionCard, FrameOverlay, RatingBar, ChipInput)
- Flutter 컴포넌트 구조 코드 스니펫 포함

**T103 디자인 가이드 작업:**
- 3가지 테마 시스템 확정:
  - 복숭아 우유 (Peach Milk) - 기본 테마
  - 민트 소다 (Mint Soda)
  - 포도 캔디 (Grape Candy)
- 타이포그래피, 아이콘, 컴포넌트 스타일 정의
- 앱 아이콘 & 스플래시 콘셉트

**문서 업데이트:**
- T101: F6 테마 설정 기능 추가
- T102: 테마 선택 화면 와이어프레임 추가
- T103: 테마 시스템으로 컬러 팔레트 구성

**다음 세션 TODO:**
- [ ] Phase 1-1 문서 최종 검토 (T101, T102, T103 전체 점검)
- [ ] T201 Flutter 개발 환경 세팅 (07-09 시작 예정)
- [ ] 개발 환경 오류 발생 시 에러 로그로 디버깅
- [ ] 상태관리 라이브러리 선택 (Provider vs Riverpod)

### Session 2 (2026-07-10)

**작업 내용:**
1. 미결정 기술 사항 확정: 로컬 DB(sqflite), 상태관리(Riverpod)
2. T202 사전조사: `image_cropper`는 사각형/원형만 지원 확인 → 커스텀 마스킹 방식 채택
3. T203 사전조사: 스티커 드래그/확대/회전은 `GestureDetector.onScale*` 네이티브 기능으로 충분, `matrix_gesture_detector`는 미유지보수라 미채택
4. T201 완료: Flutter 3.44.6 설치(`C:\src\flutter`), Windows 개발자 모드 활성화, `app/` 프로젝트 생성, Chrome에서 실행 검증
5. T202 완료: 펀치 UI(이미지 선택 → 프레임 선택/크롭 → 결과 확인) 구현
   - `CustomClipper<Path>` 기반 6종 프레임 마스킹, `RepaintBoundary.toImage()`로 투명 PNG 캡처
   - 버그 수정: 크롭 결과 화면에서 고해상도(pixelRatio 3.0) 캡처본을 그대로 표시해 레이아웃 오버플로우 발생 → 260x260 고정 표시 크기 + `BoxFit.contain`으로 수정
6. Git 저장소 초기화 + GitHub 연동 (https://github.com/leesuin0710/pong-dang)

**다음 세션 TODO:**
- [ ] T203 실제 구현 (다꾸 캔버스 스티커 드래그/확대/회전) — Phase 2 대비 검증
- [ ] T301 로컬 DB(sqflite) 스키마 설계 시작
- [ ] Android SDK 설치 여부 결정 (실기기/에뮬레이터 검증 필요 시점에)
- [ ] 작업 단위별로 커밋 후 GitHub에 푸시하며 진행

### Session 3 (2026-07-11)

**작업 내용:**
1. `app/devtools_options.yaml` 삭제 (DevTools 자동 생성 파일, 작업과 무관하여 정리)
2. T203 구현: 다꾸 캔버스 스티커 드래그/확대/회전
   - `StickerItem` 모델 추가 (`app/lib/models/sticker.dart`)
   - `StickerCanvasScreen` 구현 (`app/lib/screens/deco/sticker_canvas_screen.dart`) — T202에서 검증된 `onScale*` 패턴 재사용(이동은 `focalPointDelta` 누적, 확대/회전은 제스처 시작값 기준 배율/각도 적용)
   - 스티커 팔레트에서 탭하여 추가, 탭하여 선택(맨 앞으로 이동 + 테두리 강조), 선택 삭제/전체 삭제 지원
   - 홈 화면 AppBar 우측 ✨ 아이콘으로 진입 경로 추가
   - `flutter analyze` 통과, `flutter run -d chrome`으로 실행 검증(빌드/기동 성공, 런타임 예외 없음). 실제 드래그/핀치/회전 조작은 헤드리스 브라우저 자동화 도구가 이 환경에 없어 수동 확인 필요
3. Git: origin/main의 README.md 초기화 커밋 pull, T203 변경사항 커밋/푸시
4. T301 구현: 로컬 DB(sqflite) 스키마 설계
   - `sqflite`, `path`, `uuid` 의존성 추가 + `sqflite_common_ffi`(dev, 테스트 전용) 추가
   - `app/lib/data/db/schema.dart` — folders/items/labels/item_labels 4개 테이블 정규화 설계. items.folder_id는 `ON DELETE SET NULL`(폴더 삭제 시 아이템은 미분류로 유지), item_labels는 `ON DELETE CASCADE`. folder_id/created_at/doc_number/label_id에 인덱스 추가
   - `app/lib/data/db/app_database.dart` — `openDatabase` 래퍼, `PRAGMA foreign_keys = ON`, 팩토리 주입 가능(운영은 기본 sqflite 팩토리, 테스트는 ffi 팩토리)
   - `app/lib/models/folder.dart`, `app/lib/models/collection_item.dart` — T101 명세의 데이터 모델을 sqflite row 매핑용 `toRow`/`fromRow`로 구현
   - `app/lib/data/collection_repository.dart` — 폴더/아이템 생성, 도감번호 자동 순번 부여(트랜잭션 내 `MAX(doc_number)+1`), 라벨 upsert, 폴더별 아이템 조회. 정렬/검색/필터(F3.4/F3.5) 등 조회 확장은 T302 범위로 남겨둠
   - sqflite는 Flutter Web을 지원하지 않아 Chrome 기동 검증 대신 `sqflite_common_ffi` 기반 `test/data/collection_repository_test.dart` 작성(순차 도감번호, 라벨 중복방지, 폴더 삭제 시 아이템 미분류 전환 검증) — `flutter test` 4개 전체 통과
5. Git: T301 변경사항 커밋/푸시
6. T302 구현: 도감 등록 및 리스트 조회 화면
   - 의존성 추가: `path_provider`(파일 저장 경로), `intl`(날짜 포맷). `sqflite_common_ffi`는 dev → 일반 의존성으로 이동(데스크톱 실행 시 앱 코드 자체가 팩토리를 교체해야 해서 런타임에도 필요)
   - `AppDatabase.useFfiFactoryOnDesktop()` 추가 — Windows/Linux는 네이티브 sqflite 플러그인이 없어 `main()`에서 ffi 팩토리로 교체 후 `openDefault()`(문서 디렉터리에 `pongdang.db` 생성) 호출
   - `lib/providers/repository_providers.dart` — Riverpod `Provider`로 `CollectionRepository`/`ImageStorageService` 주입(실제 인스턴스는 `main()`에서 `overrideWithValue`로 연결). T101에서 Riverpod을 채택했지만 지금까지 실사용이 없었는데, 이번에 처음으로 실제 상태 공유에 사용
   - `lib/services/image_storage_service.dart` — 크롭 PNG를 문서 디렉터리 `images/originals/`에 저장 + `image` 패키지로 320px 폭 썸네일을 만들어 `images/thumbnails/`에 저장(F5.1, F2.6 — T202 결정사항에서 미뤄뒀던 `image` 패키지 활용을 이번에 실현)
   - `lib/screens/register/register_form_screen.dart` — 크롭 결과 미리보기 + 별점(`RatingStars`)/태그 칩 입력/메모 입력 후 저장 시 이미지 저장 → `CollectionRepository.createItem` 호출 → 홈으로 복귀. 기존 `crop_result_screen.dart`(T202의 확인용 화면)를 대체하며 삭제
   - `lib/screens/detail/item_detail_screen.dart` — 풀스크린 이미지 + 메타데이터(별점/태그/메모/등록일시) + 삭제(DB 행 + 이미지 파일 정리, 확인 다이얼로그 포함)
   - `lib/screens/home_screen.dart` — 플레이스홀더 텍스트를 2열 `GridView`(썸네일 + 도감번호 + 별점)로 교체, AppBar에 정렬 메뉴(최신순/별점순, F3.4) 추가, 빈 상태 안내 문구 유지. 검색/필터(F3.5)와 폴더 선택 UI는 T303으로 보류
   - `CollectionRepository`에 `deleteItem`, `listItems(sortBy:)`, `createItem(id:)`(파일명에 쓸 id를 화면에서 먼저 생성하도록) 추가
   - 공용 위젯 분리: `lib/widgets/checkerboard_background.dart`, `lib/widgets/rating_stars.dart` (등록 폼/상세 화면에서 재사용)
   - 테스트: `test/widget_test.dart`를 Riverpod 오버라이드 + 인메모리 DB로 갱신하는 과정에서 `testWidgets`가 기본적으로 가상 시간(zone)에서 동작해 `sqflite_common_ffi`의 실제 비동기(격리 프로세스) 호출이 끝나지 않는 문제 발견 → `tester.runAsync()` + 실제 딜레이 후 `pump()`로 해결. `test/data/collection_repository_test.dart`에 `deleteItem`, 별점순 정렬 테스트 2건 추가 — `flutter test` 6개 전체 통과, `flutter analyze` 이상 없음
   - **실행 검증 한계**: 이 환경에는 Visual Studio "Desktop development with C++" 워크로드와 Android SDK가 모두 없어(`flutter doctor`로 확인) `flutter run -d windows`/에뮬레이터 실행이 불가능하고, sqflite가 Flutter Web을 지원하지 않아 Chrome도 쓸 수 없음. 따라서 전체 등록→조회→상세→삭제 플로우는 실제 기기에서 사람이 직접 확인 필요(코드 리뷰 + 정적 분석 + 유닛/위젯 테스트로만 검증됨)

5. Android SDK 신규 설치 + 실기기(삼성 SM-S936N, Android 16) 연동
   - 디스크 용량이 10GB 남짓으로 빠듯해 Visual Studio C++ 워크로드 대신 Android SDK만 설치(커맨드라인 툴 + platform-tools + platform 35/36 + build-tools) — 에뮬레이터 이미지는 설치하지 않고 실기기 USB 디버깅으로 검증(가장 가벼운 경로)
   - `flutter run -d <실기기>` 시도 중 AGP 9.0.1(`flutter create`가 기본 생성한 버전)이 "AGP 9+는 new DSL만 읽는다"는 오류로 빌드 실패 — `android.newDsl=false`가 이미 설정돼 있었는데도 재현됨. AGP를 8.11.1(+ Kotlin 2.2.20)로 낮추고 `compileSdk`/`targetSdk`를 다시 36(flutter 기본값)으로 맞춰서 해결
   - 빌드 시행착오 과정에서 Gradle `transforms` 캐시가 여러 GB씩 불어나 디스크가 804MB까지 떨어지는 위험한 상황 발생 → 유저가 C드라이브 공간을 12.4GB로 확보해준 뒤 재시도로 해결. 원인은 살아있는 Gradle 데몬/VS Code Java 확장이 캐시 파일을 잠그고 있던 것
   - 실기기에 앱을 설치해 `adb`(screencap + uiautomator dump + input tap/text)로 직접 조작하며 T302 전체 플로우(홈 → 펀치 → 갤러리 선택 → 크롭 → 등록 폼 → 저장 → 그리드 → 상세 → 삭제) 스크린샷 기반 검증
   - **실기기 검증으로 실제 버그 발견**: `home_screen.dart`의 `_reload()`가 `setState(() => _itemsFuture = _load())`로 작성돼 있어, 대입식이 반환하는 `Future`를 setState 콜백이 그대로 반환하는 꼴이 되어 "setState() callback argument returned a Future" 런타임 예외 발생 → 등록 후 홈 화면이 새로고침되지 않는 버그였음(데이터는 정상 저장되고 있었음). `setState(() { _itemsFuture = _load(); })` 블록 바디로 수정해 해결. `flutter analyze`/유닛테스트로는 잡히지 않고 실기기 조작에서만 드러난 버그
6. 유저 피드백 반영 (실기기 확인 중 UX 이슈 2건 제보)
   - 등록 폼 태그 입력: 태그 칩이 입력 필드 왼쪽에 쌓이며 입력 필드가 계속 밀리는 문제 → 입력 필드를 항상 고정 위치(상단)에 두고, 칩은 그 아래 별도 `Wrap`으로 이동(칩끼리는 기존처럼 옆으로 배치, 필드 위치는 고정)
   - 도감 상세 화면: 투명 배경이 체커보드 패턴으로 보여 거슬리는 문제 → 등록 폼(크롭 확인용) 미리보기는 체커보드 유지, 상세 화면은 `Theme.of(context).scaffoldBackgroundColor`로 배경을 채워 앱 배경색과 자연스럽게 어우러지도록 수정
   - 두 수정 모두 재빌드 후 실기기에서 스크린샷으로 재검증 완료
7. `pong_dang_project_roadmap.xlsx` 일정표를 실제 완료일/상태로 갱신 (openpyxl로 직접 편집). T303 시작일만 T302 다음날로 당기고, Phase 2 이후는 재산정 필요 메모만 남김
8. T303 구현: 폴더 생성 및 카테고리 분류 시스템 (F4-FOLDER)
   - 리포지토리 확장: `listFolders`(루트/서브 분리), `listAllFolders`, `getFolder`, `getFolderStats`(아이템 수·서브폴더 수·최근 추가일), `updateFolder`, `deleteFolder`, `mergeFolders`(아이템 이관 후 소스 폴더 삭제), `moveItemToFolder`
   - `folder_form_dialog.dart` — 이름/아이콘(8종 이모지)/색상(T103 팔레트에서 6색) 선택 다이얼로그, 생성/편집 겸용
   - `folder_picker.dart` — 폴더 트리(루트+서브 들여쓰기)를 보여주는 바텀시트. 반환값은 `null`(닫기, 변경 없음) / `''`(미분류) / 폴더id로 3가지를 구분 — 처음엔 `null`을 미분류로 써서 시트를 그냥 닫아도 기존 선택이 사라지는 버그가 될 뻔해서 빈 문자열 신호로 수정
   - `folder_list_screen.dart`(루트 폴더 + 통계 + 생성), `folder_detail_screen.dart`(서브폴더 최대 2단계 + 폴더 내 아이템 그리드 + 편집/병합/삭제)
   - `collection_grid_view.dart`로 그리드 카드 렌더링을 홈 화면에서 분리해 폴더 상세 화면과 공유
   - 홈 화면에 `NavigationBar`(도감/폴더 탭, `IndexedStack`으로 상태 유지) 추가, 등록 폼에 폴더 선택 드롭다운, 상세 화면에 폴더 표시+이동 액션(F4.3) 연결. 상세 화면은 삭제뿐 아니라 폴더 이동도 "변경됨"으로 취급해야 해서 `PopScope`로 뒤로가기를 가로채 항상 `_changed` 플래그를 반환하도록 수정
   - 리포지토리 유닛테스트 7건 추가(폴더 목록 분리, 통계, 수정, cascade 삭제, 병합, 아이템 이동) — 전체 12개 테스트 통과
   - **실기기 검증 중 실제 버그 추가 발견**: 홈 화면이 `IndexedStack`으로 도감/폴더 탭 상태를 유지하는데, 도감 탭에서 아이템을 폴더로 이동해도 폴더 탭(이미 살아있는 인스턴스)은 새로고침될 방법이 없어 폴더 아이템 통계가 계속 "비어있음"으로 stale하게 남는 문제 발견 → 아이템이 바뀔 때마다 증가하는 `_folderTabToken`을 폴더 탭 위젯의 `key`로 사용해, 변경 시마다 폴더 탭을 새 인스턴스로 재생성(=강제 새로고침)하도록 수정. 실기기에서 재현 시나리오 그대로 재검증해 수정 확인

9. Phase 2 기능 명세서 작성: `docs/T401_phase2_feature_spec.md`
   - T101처럼 상세 명세를 먼저 작성하기로 결정(일정표엔 한 줄짜리 설명만 있었음). 원본 기획안 PDF(`app_planning_pong_dang.pdf`) 4절 [Phase 2]를 근거로 F7-CALENDAR(달력 뷰)/F8-DECO(다꾸 스페이스)/F9-DECO-EXPORT(결과물 저장) 정의
   - 유저 피드백 반영: 하루 여러 장 다꾸 허용(`DecoEntry.date` UNIQUE 아님), 모든 날짜(과거/미래) 접근 제한 없음, 텍스트 요소 추가(스티커와 동일하게 드래그/확대/회전 — `DecoPlacement.type`로 sticker/text 구분)
   - T203용 자유 캔버스(이모지 데모)는 기술 검증용으로 남기고, Phase 2 MVP는 날짜 연동 다꾸에 집중하기로 범위 명확화
10. T401 구현: 달력(캘린더) 기본 UI
    - DB 스키마: `deco_entries`(날짜별 다꾸 페이지, 하루 여러 개 허용) + `deco_placements`(스티커/텍스트 배치, `CHECK` 제약으로 타입별 필수 필드 강제) 추가. 기존 설치 앱을 위해 `kSchemaVersion` 1→2 + `onUpgrade`로 기존 DB에도 신규 테이블 추가
    - `DecoRepository`: 엔트리 CRUD만 우선 구현(배치 CRUD는 T402), `listEntriesGroupedByDateInMonth`로 캘린더 그리드용 월별 조회를 쿼리 한 번에 처리
    - `CalendarScreen`: 직접 구현한 월별 그리드(요일 헤더, 인접 월 흐리게, 오늘 강조, 날짜별 점+개수 배지) — `table_calendar` 등 외부 패키지 없이 자체 구현(로직이 단순해 의존성 추가보다 직접 구현이 더 통제하기 쉬움)
    - 날짜 탭 플로우: 기록 없으면 바로 새 다꾸 스페이스, 있으면 `deco_entry_list_sheet.dart`(하루 여러 장 목록 + "새 다꾸 추가") 표시. 폴더 피커와 동일하게 "닫기"와 "선택"을 구분하는 sealed class(`DecoEntryPickOpen`/`DecoEntryPickCreateNew`)로 반환값 설계
    - 홈 화면에 "달력" 탭(3번째) 추가, 유닛테스트 3건 추가 — 전체 15개 테스트 통과
    - **실기기 검증 + 유저 피드백으로 설계를 두 번 수정**:
      1. `CalendarScreen._reload()`도 T302에서 이미 발견했던 것과 똑같은 `setState(() => future = load())` 화살표 함수 버그를 반복 — 실기기에서 즉시 크래시로 드러남. 블록 바디로 수정하고, 프로젝트 전체를 같은 패턴으로 재검색해 다른 곳엔 없음을 확인
      2. 유저가 "날짜를 열기만 해도 캘린더에 점이 찍히는 게 이상하다"고 지적 → 원래는 빈 날짜를 탭하면 바로 `DecoEntry`를 생성했는데, 저장 전까지 생성을 미루도록 `DecoSpaceScreen(date, entry?)`로 구조 변경. 이어서 "저장 버튼도 변경 사항 없으면 무의미하다"는 피드백을 받아, 저장 버튼을 `_hasUnsavedChanges` 플래그 기반으로 비활성화(T402에서 실제 배치가 생기면 활성화되도록 설계)
      3. F8.5 자동 저장도 제스처마다 즉시 DB 쓰기가 아니라 디바운스/주기적 flush(1~5분) 방식으로 설계 변경(유저 요청) — 실제 구현은 T402에서

**다음 세션 TODO:**
- [ ] (선택) T203 스티커 캔버스에서 드래그/핀치/회전 직접 조작 확인
- [ ] (선택) T303 폴더 편집/삭제/병합/서브폴더 플로우 실기기 추가 확인 (생성·이동·통계는 확인 완료, 이 3개는 코드상 동일 위젯 재사용이라 미확인 상태로 남음)
- [ ] T402 날짜별 다꾸 스페이스 구현: 도감 아이템 스티커 불러오기, 텍스트 추가, 드래그/확대/회전(T203 로직 재사용), 디바운스 자동 저장(1~5분) + 명시적 저장 버튼(변경 있을 때만 활성화)
- [ ] T403 다꾸 결과물 PNG 저장 + 공유 (`share_plus` 추가 필요)
- [ ] F3.5 검색/라벨 필터링 UI (리포지토리 쿼리는 준비돼 있음, 화면 미구현)
- [ ] 작업 단위별로 커밋 후 GitHub에 푸시하며 진행

---

## 기술 결정 사항

| 항목 | 결정 | 이유 | 결정일 |
|------|------|------|--------|
| 프레임워크 | Flutter | UI 자유도, 크로스플랫폼, AI 협업 최적화 | 기획 단계 |
| 로컬 DB | sqflite (SQLite) | 폴더 계층구조(parentId), item-folder FK, 정렬/필터/검색 쿼리에 적합. Phase 3 클라우드 동기화(Supabase/Postgres 등) 전환 시 스키마 매핑 자연스러움 | 2026-07-10 |
| 상태관리 | Riverpod | 컴파일 타임 안정성, BuildContext 불필요, 테스트 용이. 앱 규모(도감/폴더/테마/설정 등 다중 상태) 확장에 유리 | 2026-07-10 |
| 이미지 크롭 | 커스텀 마스킹 (`image_cropper` 미채택) | image_cropper는 사각형/원형만 지원, 하트·우유곽 등 비정형 프레임 불가. `CustomClipper<Path>`로 화면에 클립 후 `RepaintBoundary.toImage()`로 투명 PNG 직접 캡처 (실제 구현 시 `image` 패키지의 픽셀 마스킹은 불필요했음 — 해당 패키지는 향후 썸네일 생성(F2.6)에 사용 예정) | 2026-07-10 |
| 스티커 제스처 제어 (T203/Phase 2용) | `GestureDetector.onScale*` 네이티브 사용 (별도 패키지 없음) | `ScaleUpdateDetails`가 scale/rotation/focalPointDelta 모두 제공하여 이동·확대·회전 동시 처리 가능. `matrix_gesture_detector`는 7년간 미유지보수 + Dart 3 비호환이라 미채택 | 2026-07-10 |
| DB 스키마 - 라벨 정규화 (T301) | 라벨을 `items` 테이블 컬럼(CSV/JSON)으로 두지 않고 `labels` + `item_labels` 조인 테이블로 분리 | F3.5(라벨 기반 필터링/검색)를 인덱스 붙은 조인 쿼리로 처리하기 위함. CSV 방식은 특정 라벨 검색 시 풀스캔+문자열 파싱이 필요해 아이템 수가 늘면 성능이 나빠짐 | 2026-07-11 |
| DB 스키마 - 도감 번호 부여 (T301) | UUID PK(`items.id`)와 별도로 `doc_number` 정수 컬럼을 두고, 트랜잭션 내 `MAX(doc_number)+1`로 채번 | 스펙(F2.1)의 `id: UUID` + `docNumber: int` 요구를 그대로 반영. sqflite는 단일 로컬 writer라 동시성 문제 없음. 삭제 시 번호에 공백이 생길 수 있으나 재정렬은 하지 않기로 함(도감 번호는 등록 순서 기록용) | 2026-07-11 |
| 폴더-아이템 삭제 정책 (T301) | `items.folder_id`는 `ON DELETE SET NULL`(폴더 삭제 시 아이템은 미분류로 유지), `item_labels`는 `ON DELETE CASCADE` | 폴더를 지워도 수집한 아이템 자체가 사라지면 안 됨(F4.4 폴더 편집/삭제와 별개로 데이터 보존이 우선). 반면 아이템-라벨 연결은 아이템 삭제 시 같이 정리되는 게 자연스러움 | 2026-07-11 |
| DB 테스트 방식 (T301) | `sqflite_common_ffi`로 순수 Dart 유닛 테스트에서 스키마 검증 | `sqflite`는 Flutter Web을 지원하지 않아 T201~T203처럼 Chrome으로 실행 검증 불가. Android 에뮬레이터/실기기도 아직 미설치 상태라, ffi 기반 인메모리 DB로 CRUD·제약조건을 검증하는 것이 가장 빠르고 반복 가능한 방법 | 2026-07-11 |
| 데스크톱 DB 팩토리 (T302) | Windows/Linux에서는 `main()` 시작 시 `sqflite_common_ffi`의 `databaseFactoryFfi`로 교체(`AppDatabase.useFfiFactoryOnDesktop`), Android/iOS는 기본 `sqflite` 팩토리 그대로 사용 | 순정 `sqflite` 플러그인은 데스크톱용 플랫폼 채널이 없음. 개발 중 실행 타겟을 Chrome(Web 미지원)에서 Windows 데스크톱으로 옮기려면 필요. `sqflite_common_ffi`가 런타임에도 쓰이게 되어 dev → 일반 의존성으로 이동 | 2026-07-11 |
| 썸네일 생성 (T302, F2.6) | `image` 패키지로 크롭 PNG를 320px 폭으로 리사이즈해 별도 파일로 저장 | T202 결정사항에서 "향후 썸네일 생성에 사용 예정"으로 남겨뒀던 `image` 패키지를 실제로 사용. 그리드 뷰에서 원본 대신 썸네일을 그려 로딩 비용을 줄임(비기능 요구사항: 썸네일 로딩 100ms 이내) | 2026-07-11 |
| 위젯 테스트에서 sqflite 사용 (T302) | `testWidgets` 내에서 `sqflite_common_ffi`를 쓸 때는 `tester.runAsync()`로 감싸고, `pumpAndSettle()` 대신 실제 `Future.delayed` + `pump()` 사용 | `testWidgets`는 기본적으로 가상 시간(zone)에서 동작해 ffi가 사용하는 실제 비동기(격리 프로세스) 응답을 받지 못해 무한 대기함. `pumpAndSettle()`도 인디케이터의 반복 애니메이션 때문에 타임아웃됨 — 실제 원인을 T302에서 처음 발견 | 2026-07-11 |
| 실기기 검증 환경 (T302) | Windows 데스크톱/에뮬레이터 대신 실제 안드로이드 폰(USB 디버깅)으로 검증 | 디스크 용량이 제한적이라 Visual Studio C++ 워크로드(7~10GB)나 에뮬레이터 이미지보다 가벼운 경로 필요. 실기기가 최종 배포 타겟(Android 8+)과도 더 가까움 | 2026-07-11 |
| AGP 버전 (android/settings.gradle.kts) | `flutter create`가 기본 생성한 9.0.1 대신 8.11.1 + Kotlin 2.2.20 사용, `compileSdk`/`targetSdk`는 36 유지 | AGP 9.0.1은 "new DSL" 관련 버그로 Flutter Gradle 플러그인과 충돌(`android.newDsl=false`로도 회피 안 됨). 8.7.3 등 더 낮은 버전은 반대로 `androidx.core` 등 의존성이 AGP 8.9.1+/SDK 36을 요구해 실패 — 8.11.1이 현재 의존성 조합과 맞는 지점 | 2026-07-11 |
| 폴더 삭제 정책 - 서브폴더 (T303) | `folders.parent_id`는 `ON DELETE CASCADE` (T301에서 이미 결정됨), 병합(`mergeFolders`)은 아이템만 이관하고 서브폴더째 삭제 | 루트 폴더 삭제 시 서브폴더도 함께 정리되는 게 자연스러움(아이템은 T301 정책대로 미분류로 보존). 병합은 F4.4 스펙상 "서브폴더 병합" 케이스를 명시하지 않아 단순하게 아이템 이관 + 소스 삭제로 한정 | 2026-07-11 |
| 폴더 선택 시트 반환값 (T303) | `showFolderPickerSheet`가 `null`(닫기)/`''`(미분류)/폴더id 3가지를 구분해서 반환 | 처음엔 `null`을 "미분류"로 썼는데, 시트를 그냥 닫아도 `null`이 반환되어 기존 폴더 선택이 실수로 지워지는 버그가 될 뻔함 — "닫기"와 "미분류 선택"은 다른 사용자 의도이므로 반드시 구분해야 함 | 2026-07-11 |
| 폴더 탭 새로고침 (T303) | 홈 화면의 폴더 탭을, 아이템이 바뀔 때마다 증가하는 카운터를 `key`로 삼아 매번 새 위젯 인스턴스로 재생성 | `IndexedStack`으로 도감/폴더 탭 상태를 유지하다 보니 도감 탭에서 아이템을 폴더로 옮겨도 이미 살아있는 폴더 탭 인스턴스는 알 방법이 없어 통계가 stale해지는 실기기 버그를 발견 — RouteAware 등 정식 lifecycle보다 key 교체가 이 규모 앱에는 더 단순 | 2026-07-11 |
| Phase 2 착수 전 별도 명세서 작성 (T401) | T101처럼 `docs/T401_phase2_feature_spec.md`를 먼저 작성하고 나서 구현 시작 | 일정표엔 Phase 2 작업이 한 줄짜리 설명만 있어, 사전 설계 없이 바로 구현하면 데이터 모델(다꾸 엔트리/배치 저장 방식 등)을 임의로 추측하게 됨. Phase 1 때 T101 스펙이 실수를 줄여준 경험을 그대로 재적용 | 2026-07-11 |
| 다꾸 캘린더 자체 구현 (T401) | `table_calendar` 등 외부 패키지 없이 월별 그리드를 직접 구현 | 요구사항(날짜별 점/개수 배지, 하루 여러 장, 인접월 흐리게)이 단순해 서드파티 패키지의 builder API와 씨름하는 것보다 직접 구현이 통제하기 쉬움. 일정표엔 "table_calendar 커스텀 가이드"로 적혀 있었지만 실제로는 필요 없었음 | 2026-07-11 |
| 다꾸 엔트리 생성 시점 (T401) | 날짜를 열어보는 것만으로는 `DecoEntry`를 생성하지 않고, 실제 저장(버튼 또는 첫 배치) 시점에만 생성. 저장 버튼도 변경 사항이 없으면 비활성화 | 실기기 검증 중 빈 날짜를 열기만 해도 캘린더에 점이 찍히는 게 이상하다는 피드백을 받음 — "열어봄"과 "저장함"은 다른 사용자 의도이므로 구분 필요. 변경 없는 저장도 무의미하다는 후속 피드백까지 반영 | 2026-07-11 |
| 다꾸 배치 자동 저장 방식 (T401 설계, T402 구현 예정) | 제스처마다 즉시 DB 쓰기가 아니라 디바운스/주기적 flush(1~5분), 화면 이탈 시 즉시 flush | 매 프레임 DB 쓰기는 불필요한 부하 — 유저 피드백으로 인터벌 기반 저장을 요청받음 | 2026-07-11 |

---

## 이슈 및 논의 사항

| ID | 내용 | 상태 | 해결 방안 |
|----|------|------|----------|
| I001 | T302부터 실제 파일 저장(`path_provider`)이 들어가면서 sqflite가 Flutter Web을 지원하지 않아 Chrome 실행 검증이 불가능해짐. Windows 데스크톱 실행도 Visual Studio C++ 워크로드 미설치로 불가 | 해결 (2026-07-11) | Android SDK(커맨드라인 툴만, 에뮬레이터 없이)를 설치하고 실기기 USB 디버깅으로 검증 경로 확보. `flutter doctor`의 Android 툴체인 항목 초록불 확인 |
| I002 | Android 빌드 중 디스크가 804MB까지 떨어지는 위험 상황 발생. Gradle `transforms` 캐시가 AGP 버전을 바꿀 때마다 수 GB씩 재생성되고, 살아있는 Gradle 데몬/VS Code Java 확장이 캐시 파일을 잠가 정리도 어려웠음 | 해결 (2026-07-11) | 유저가 C드라이브 여유 공간을 12.4GB로 확보. 재발 방지를 위해 이후 세션에서 Android 빌드 전 `df -h /c`로 여유 공간(최소 5GB 권장) 먼저 확인할 것 |

---

## 참고 링크 및 리소스

- Flutter 공식 문서: https://flutter.dev/docs
- image_picker 패키지: https://pub.dev/packages/image_picker
- sqflite 패키지 (로컬 DB, 채택됨): https://pub.dev/packages/sqflite
- ~~Hive 패키지~~: https://pub.dev/packages/hive (검토 후 미채택, sqflite로 결정됨 — 기술 결정 사항 참고)
- archive 패키지 (ZIP): https://pub.dev/packages/archive
- share_plus 패키지: https://pub.dev/packages/share_plus
- file_picker 패키지: https://pub.dev/packages/file_picker

---

## 메모

> 새로운 세션에서 작업을 이어갈 때:
> 1. 이 `PROGRESS.md` 파일을 먼저 읽어주세요
> 2. 관련 명세서 파일들을 확인해주세요
> 3. "다음 세션 TODO" 섹션을 참고하여 작업을 이어가주세요

---

*마지막 업데이트: 2026-07-11 Session 3 (T203, T301, T302, T303 완료 — Phase 1 전체 완료 / Phase 2 T401 완료, T402 착수 예정)*
