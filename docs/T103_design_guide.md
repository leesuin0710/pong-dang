# T103: UI/UX 디자인 가이드

> 작성일: 2026-07-08
> 상태: 작성중
> 관련 태스크: T103 - UI/UX 컬러 톤앤매너 및 디자인 에셋 준비

---

## 1. 디자인 콘셉트

### 브랜드 키워드
| 키워드 | 설명 |
|--------|------|
| **감성 수집** | 일상 속 예쁜 것들을 모으는 즐거움 |
| **아날로그 터치** | 펀치 기계, 스크랩북, 다이어리의 손맛 |
| **포근한 레트로** | 빈티지하지만 따뜻하고 친근한 느낌 |
| **미니멀 귀여움** | 복잡하지 않으면서 사랑스러운 디테일 |

### 무드보드 방향
```
┌─────────────────────────────────────────────────┐
│                                                 │
│   빈티지 엽서  +  파스텔 문구류  +  필름 카메라  │
│                                                 │
│   스크랩북     +  마스킹테이프   +  폴라로이드   │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 2. 테마 시스템

퐁당은 **3가지 컬러 테마**를 제공하여 사용자가 취향에 맞게 앱 분위기를 변경할 수 있다.

### 테마 개요

| 테마 ID | 테마 이름 | 느낌 | 기본값 |
|---------|----------|------|--------|
| `peach` | 복숭아 우유 | 포근하고 달콤한 | O (기본) |
| `mint` | 민트 소다 | 청량하고 시원한 | |
| `lavender` | 포도 캔디 | 몽환적이고 달콤한 | |

### 테마 전환 구조

```dart
// theme_provider.dart (Riverpod)
class ThemeNotifier extends Notifier<String> {
  @override
  String build() => 'peach'; // 기본 테마

  void setTheme(String themeId) {
    state = themeId;
    _saveToPrefs(themeId); // 로컬 저장
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, String>(ThemeNotifier.new);

final themeDataProvider = Provider<ThemeData>((ref) {
  final themeId = ref.watch(themeProvider);
  switch (themeId) {
    case 'mint': return MintSodaTheme.data;
    case 'lavender': return GrapeCandyTheme.data;
    default: return PeachMilkTheme.data;
  }
});
```

---

### 테마 1: 복숭아 우유 (Peach Milk) - 기본 테마

따뜻하고 부드러운 복숭아빛 톤. 다꾸 감성과 잘 어울림.

| 역할 | 이름 | HEX | 미리보기 | 용도 |
|------|------|-----|----------|------|
| **Primary** | Soft Peach | `#FFAB91` | ![#FFAB91](https://via.placeholder.com/20/FFAB91/FFAB91) | 퐁당 버튼, 주요 액션 |
| **Primary Light** | Cream Peach | `#FFDDC1` | ![#FFDDC1](https://via.placeholder.com/20/FFDDC1/FFDDC1) | 선택 상태, 하이라이트 |
| **Secondary** | Dusty Rose | `#D4A5A5` | ![#D4A5A5](https://via.placeholder.com/20/D4A5A5/D4A5A5) | 보조 버튼, 태그 |
| **Background** | Warm Cream | `#FFF8F0` | ![#FFF8F0](https://via.placeholder.com/20/FFF8F0/FFF8F0) | 앱 배경 |
| **Surface** | Pure White | `#FFFFFF` | ![#FFFFFF](https://via.placeholder.com/20/FFFFFF/FFFFFF) | 카드, 모달 |
| **Text Primary** | Cocoa Brown | `#5D4E4E` | ![#5D4E4E](https://via.placeholder.com/20/5D4E4E/5D4E4E) | 본문 텍스트 |
| **Text Secondary** | Warm Gray | `#9E8E8E` | ![#9E8E8E](https://via.placeholder.com/20/9E8E8E/9E8E8E) | 보조 텍스트, 힌트 |
| **Accent** | Terracotta | `#E07A5F` | ![#E07A5F](https://via.placeholder.com/20/E07A5F/E07A5F) | 강조, 알림 뱃지 |
| **Star** | Honey Gold | `#F4C430` | ![#F4C430](https://via.placeholder.com/20/F4C430/F4C430) | 별점 |

```dart
// 복숭아 우유 테마 컬러
class PeachMilkColors {
  static const primary = Color(0xFFFFAB91);
  static const primaryLight = Color(0xFFFFDDC1);
  static const secondary = Color(0xFFD4A5A5);
  static const background = Color(0xFFFFF8F0);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF5D4E4E);
  static const textSecondary = Color(0xFF9E8E8E);
  static const accent = Color(0xFFE07A5F);
  static const star = Color(0xFFF4C430);
}
```

---

### 테마 2: 민트 소다 (Mint Soda)

시원하면서도 레트로한 민트 톤. 청량하고 깔끔한 느낌.

| 역할 | 이름 | HEX | 용도 |
|------|------|-----|------|
| **Primary** | Soft Mint | `#88D4AB` | 퐁당 버튼, 주요 액션 |
| **Primary Light** | Pale Mint | `#C5E8D5` | 선택 상태, 하이라이트 |
| **Secondary** | Sage | `#A8C69F` | 보조 버튼, 태그 |
| **Background** | Mint Cream | `#F5FBF7` | 앱 배경 |
| **Surface** | Pure White | `#FFFFFF` | 카드, 모달 |
| **Text Primary** | Forest | `#3D5A45` | 본문 텍스트 |
| **Text Secondary** | Moss | `#7A9E7E` | 보조 텍스트 |
| **Accent** | Coral | `#FF8A80` | 강조, 알림 |
| **Star** | Sunflower | `#FFD54F` | 별점 |

---

### 테마 3: 포도 캔디 (Grape Candy)

몽환적이고 감성적인 보라빛 톤. 독특하고 세련된 느낌.

| 역할 | 이름 | HEX | 용도 |
|------|------|-----|------|
| **Primary** | Soft Lavender | `#B8A9C9` | 퐁당 버튼, 주요 액션 |
| **Primary Light** | Pale Lilac | `#E6D7F1` | 선택 상태, 하이라이트 |
| **Secondary** | Dusty Violet | `#9C89B8` | 보조 버튼, 태그 |
| **Background** | Lavender Mist | `#FAF8FC` | 앱 배경 |
| **Surface** | Pure White | `#FFFFFF` | 카드, 모달 |
| **Text Primary** | Deep Plum | `#4A3F55` | 본문 텍스트 |
| **Text Secondary** | Muted Mauve | `#8E7F9A` | 보조 텍스트 |
| **Accent** | Berry | `#E8788A` | 강조, 알림 |
| **Star** | Amber | `#FFCA28` | 별점 |

---

## 3. 타이포그래피

### 폰트 선택

| 용도 | 추천 폰트 | 대안 | 특징 |
|------|----------|------|------|
| **한글 메인** | Pretendard | Noto Sans KR | 깔끔하고 가독성 좋음 |
| **한글 포인트** | 마루부리 | 나눔명조 | 감성적인 제목용 |
| **영문/숫자** | Poppins | Nunito | 둥글고 친근한 느낌 |
| **도감 번호** | Space Mono | Roboto Mono | 레트로 타자기 느낌 |

### 텍스트 스타일

```dart
class PongdangTextStyles {
  // 앱 타이틀
  static const appTitle = TextStyle(
    fontFamily: 'MaruBuri',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: PongdangColors.textPrimary,
  );

  // 화면 제목
  static const heading = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: PongdangColors.textPrimary,
  );

  // 본문
  static const body = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: PongdangColors.textPrimary,
  );

  // 보조 텍스트
  static const caption = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: PongdangColors.textSecondary,
  );

  // 도감 번호
  static const docNumber = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    color: PongdangColors.textSecondary,
  );

  // 태그/라벨
  static const tag = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: PongdangColors.secondary,
  );
}
```

### 텍스트 크기 시스템

| 레벨 | 크기 | 용도 |
|------|------|------|
| Display | 28px | 온보딩 타이틀 |
| H1 | 24px | 앱바 타이틀 |
| H2 | 20px | 섹션 제목 |
| H3 | 18px | 카드 제목 |
| Body | 16px | 본문 |
| Caption | 14px | 보조 설명 |
| Small | 12px | 도감 번호, 날짜 |

---

## 4. 아이콘 & 그래픽 스타일

### 아이콘 스타일

| 항목 | 스타일 | 예시 |
|------|--------|------|
| **라인 두께** | 2px (Rounded) | 부드러운 인상 |
| **모서리** | 둥근 끝 (Round cap) | 친근한 느낌 |
| **스타일** | Outlined + 포인트 Fill | 선택 시 채워짐 |

```
일반 상태:     선택 상태:
  ☆              ★
  ◇              ◆
  ○              ●
```

### 추천 아이콘 팩
- **Lucide Icons** - 깔끔하고 일관된 라인 아이콘
- **Phosphor Icons** - 다양한 굵기 지원, 레트로 느낌 가능

### 퐁당 버튼 디자인

```
    ┌─────────┐
    │         │
    │    +    │   ← 그라데이션 or 단색
    │         │   ← 그림자 (elevation: 6)
    └─────────┘
       ◠ ◠        ← 미세한 물결 효과 (선택)

크기: 56 x 56 dp
모서리: 완전 원형 (circular)
색상: Primary (Soft Peach)
아이콘: + (또는 펀치 아이콘)
```

```dart
FloatingActionButton(
  onPressed: goToPunchMode,
  backgroundColor: PongdangColors.primary,
  elevation: 6,
  child: Icon(Icons.add, size: 28, color: Colors.white),
)
```

---

## 5. 컴포넌트 스타일

### 카드 (Collection Card)

```
┌─────────────────────┐
│                     │
│      (이미지)       │   ← border-radius: 12px
│                     │
├─────────────────────┤
│ No.007       ⭐ 4   │   ← padding: 8px
└─────────────────────┘
     ↑
  shadow: 0 2px 8px rgba(0,0,0,0.08)
```

```dart
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  clipBehavior: Clip.antiAlias,
  child: Container(
    decoration: BoxDecoration(
      color: PongdangColors.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    // ...
  ),
)
```

### 버튼 스타일

#### Primary Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: PongdangColors.primary,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24), // pill shape
    ),
    elevation: 2,
  ),
  child: Text("저장"),
)
```

#### Secondary Button (Outlined)
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: PongdangColors.primary,
    side: BorderSide(color: PongdangColors.primary, width: 1.5),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),
  child: Text("취소"),
)
```

### 태그 칩 (Label Chip)

```dart
Chip(
  label: Text("#카페", style: PongdangTextStyles.tag),
  backgroundColor: PongdangColors.primaryLight,
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  deleteIcon: Icon(Icons.close, size: 16),
  onDeleted: () => removeTag("카페"),
)
```

### 입력 필드 (TextField)

```dart
TextField(
  decoration: InputDecoration(
    hintText: "메모를 입력하세요",
    hintStyle: TextStyle(color: PongdangColors.textSecondary),
    filled: true,
    fillColor: PongdangColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: PongdangColors.primaryLight, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: PongdangColors.primary, width: 2),
    ),
    contentPadding: EdgeInsets.all(16),
  ),
)
```

---

## 6. 간격 & 레이아웃

### Spacing System (8px 기반)

| 토큰 | 값 | 용도 |
|------|-----|------|
| `xs` | 4px | 아이콘-텍스트 간격 |
| `sm` | 8px | 요소 내부 패딩 |
| `md` | 16px | 섹션 간 간격 |
| `lg` | 24px | 카드 간 간격 |
| `xl` | 32px | 화면 상하 여백 |

### 모서리 반경 (Border Radius)

| 토큰 | 값 | 용도 |
|------|-----|------|
| `sm` | 8px | 작은 요소, 태그 |
| `md` | 12px | 카드, 입력 필드 |
| `lg` | 16px | 모달, 바텀시트 |
| `xl` | 24px | 버튼 (pill) |
| `full` | 9999px | 원형 (퐁당 버튼) |

---

## 7. 애니메이션 & 인터랙션

### 크롭 완료 시 피드백

```dart
// 햅틱 피드백
HapticFeedback.mediumImpact();

// 사운드 (찰칵/탁 소리)
AudioPlayer().play(AssetSource('sounds/punch_click.mp3'));

// 시각적 피드백 (작은 파티클 또는 스케일 애니메이션)
ScaleTransition(
  scale: Tween(begin: 1.0, end: 1.1).animate(controller),
  child: croppedImage,
);
```

### 기본 애니메이션 값

| 종류 | Duration | Curve |
|------|----------|-------|
| 화면 전환 | 300ms | easeInOut |
| 버튼 피드백 | 100ms | easeOut |
| 카드 등장 | 200ms | easeOutCubic |
| 모달 열기 | 250ms | easeOutBack |

---

## 8. 앱 아이콘 & 스플래시

### 앱 아이콘 콘셉트

```
┌─────────────────┐
│                 │
│    ╭─────╮      │   ← 펀치 프레임 모양
│    │  ◉  │      │   ← 중앙에 물방울 또는 +
│    ╰─────╯      │
│                 │
└─────────────────┘

배경: Primary 컬러 (Soft Peach)
아이콘: 흰색 펀치 프레임 + 심볼
스타일: 미니멀, 둥근 모서리
```

### 스플래시 화면

```
┌─────────────────────────────────┐
│                                 │
│                                 │
│                                 │
│           [앱 아이콘]           │
│                                 │
│            퐁 당               │  ← 앱 이름 (마루부리 폰트)
│                                 │
│                                 │
│                                 │
└─────────────────────────────────┘

배경: Background 컬러 (Warm Cream)
```

---

## 9. 다크모드 (추후 확장)

> MVP에서는 라이트 모드만 지원. Phase 2 이후 다크모드 추가 검토.

| 라이트 모드 | 다크 모드 |
|------------|----------|
| Background: #FFF8F0 | Background: #1A1616 |
| Surface: #FFFFFF | Surface: #2D2626 |
| Text Primary: #5D4E4E | Text Primary: #F5EFEF |
| Primary: #FFAB91 | Primary: #FFAB91 (유지) |

---

## 10. 변경 이력

| 날짜 | 버전 | 변경 내용 | 작성자 |
|------|------|----------|--------|
| 2026-07-08 | v0.1 | 초안 작성 - 3가지 컬러 옵션 제안 | Claude + 개발자 |
| 2026-07-08 | v0.2 | 테마 시스템으로 변경, 테마명 확정 (복숭아 우유/민트 소다/포도 캔디) | Claude + 개발자 |
