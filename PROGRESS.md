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

### Phase 1-3: 로컬 MVP 개발 (진행 중)

| 태스크 ID | 작업 내용 | 완료일 | 산출물 |
|-----------|----------|--------|--------|
| T301 | 로컬 DB(sqflite) 구조 설계 | 2026-07-11 | `app/lib/data/db/schema.dart`, `app/lib/data/db/app_database.dart`, `app/lib/data/collection_repository.dart`, `app/lib/models/folder.dart`, `app/lib/models/collection_item.dart` — folders/items/labels/item_labels 정규화 테이블 + FK(ON DELETE CASCADE/SET NULL) + 인덱스. `sqflite_common_ffi`로 `test/data/collection_repository_test.dart` 작성해 검증(순차 도감번호 부여, 라벨 중복방지, 폴더 삭제 시 아이템 미분류 처리) — sqflite는 Flutter Web 미지원이라 Chrome 대신 순수 Dart 테스트로 확인 |

### 진행 중인 태스크

| 태스크 ID | 작업 내용 | 시작일 | 상태 |
|-----------|----------|--------|------|
| - | - | - | - |

### 대기 중인 태스크

> 일정표상 날짜는 참고용이며, 실제로는 완료된 작업 기준으로 다음 작업을 바로 이어서 진행합니다.

**Phase 1-3: 로컬 MVP 개발**
| 태스크 ID | 작업 내용 | 예정일 |
|-----------|----------|--------|
| T302 | 도감 등록 및 리스트 조회 화면 개발 | 2026-07-20 ~ 07-24 |
| T303 | 폴더 생성 및 카테고리 분류 시스템 구현 | 2026-07-25 ~ 07-28 |

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

**다음 세션 TODO:**
- [ ] (선택) T203 스티커 캔버스에서 드래그/핀치/회전 직접 조작 확인
- [ ] T302 도감 등록 및 리스트 조회 화면 개발 (T301 리포지토리 기반으로 실제 등록 폼/그리드 뷰 구현, 정렬·검색·필터 포함)
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
| DB 테스트 방식 (T301) | `sqflite_common_ffi`(dev 전용)로 순수 Dart 유닛 테스트에서 스키마 검증 | `sqflite`는 Flutter Web을 지원하지 않아 T201~T203처럼 Chrome으로 실행 검증 불가. Android 에뮬레이터/실기기도 아직 미설치 상태라, ffi 기반 인메모리 DB로 CRUD·제약조건을 검증하는 것이 가장 빠르고 반복 가능한 방법 | 2026-07-11 |

---

## 이슈 및 논의 사항

| ID | 내용 | 상태 | 해결 방안 |
|----|------|------|----------|
| - | 현재 이슈 없음 | - | - |

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

*마지막 업데이트: 2026-07-11 Session 3 (T203, T301 완료)*
