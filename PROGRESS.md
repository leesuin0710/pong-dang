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

### Phase 1-2: 기술 검증 (진행 중)

| 태스크 ID | 작업 내용 | 완료일 | 산출물 |
|-----------|----------|--------|--------|
| T201 | Flutter 개발 환경 세팅 | 2026-07-10 | `app/` (Flutter 3.44.6, Chrome 검증 완료) |
| T202 | 이미지 크롭 패키지 테스트 및 펀치 UI 구현 | 2026-07-10 | `app/lib/screens/punch/`, `app/lib/widgets/frame_clipper.dart` — 6종 프레임(엽서/우유곽/원형/사각/폴라로이드/하트) 커스텀 마스킹 + 투명 PNG 크롭 캡처, Chrome에서 검증 완료 |

### 진행 중인 태스크

| 태스크 ID | 작업 내용 | 시작일 | 상태 |
|-----------|----------|--------|------|
| - | - | - | - |

### 대기 중인 태스크 (업데이트된 일정)

**Phase 1-2: 기술 검증**
| 태스크 ID | 작업 내용 | 예정일 |
|-----------|----------|--------|
| T203 | 다꾸 스페이스 스티커 제어 검증 (드래그/확대/회전 구현 — 사전조사 완료, 구현은 미착수) | 2026-07-15 ~ 07-17 |

**Phase 1-3: 로컬 MVP 개발**
| 태스크 ID | 작업 내용 | 예정일 |
|-----------|----------|--------|
| T301 | 로컬 DB 구조 설계 | 2026-07-18 ~ 07-19 |
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

---

## 기술 결정 사항

| 항목 | 결정 | 이유 | 결정일 |
|------|------|------|--------|
| 프레임워크 | Flutter | UI 자유도, 크로스플랫폼, AI 협업 최적화 | 기획 단계 |
| 로컬 DB | sqflite (SQLite) | 폴더 계층구조(parentId), item-folder FK, 정렬/필터/검색 쿼리에 적합. Phase 3 클라우드 동기화(Supabase/Postgres 등) 전환 시 스키마 매핑 자연스러움 | 2026-07-10 |
| 상태관리 | Riverpod | 컴파일 타임 안정성, BuildContext 불필요, 테스트 용이. 앱 규모(도감/폴더/테마/설정 등 다중 상태) 확장에 유리 | 2026-07-10 |
| 이미지 크롭 | 커스텀 마스킹 (`image_cropper` 미채택) | image_cropper는 사각형/원형만 지원, 하트·우유곽 등 비정형 프레임 불가. `CustomClipper<Path>`로 화면에 클립 후 `RepaintBoundary.toImage()`로 투명 PNG 직접 캡처 (실제 구현 시 `image` 패키지의 픽셀 마스킹은 불필요했음 — 해당 패키지는 향후 썸네일 생성(F2.6)에 사용 예정) | 2026-07-10 |
| 스티커 제스처 제어 (T203/Phase 2용) | `GestureDetector.onScale*` 네이티브 사용 (별도 패키지 없음) | `ScaleUpdateDetails`가 scale/rotation/focalPointDelta 모두 제공하여 이동·확대·회전 동시 처리 가능. `matrix_gesture_detector`는 7년간 미유지보수 + Dart 3 비호환이라 미채택 | 2026-07-10 |

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

*마지막 업데이트: 2026-07-10 Session 2 (T201/T202 완료, GitHub 연동)*
