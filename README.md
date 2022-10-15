# ios-wanted-VideoRecorder
## 팀원: 소현수(쏘롱), 신병기(Bang71)

## 역할 분담 및 앱에서 기여한 부분

### 쏘롱
첫번째 화면 구현

### Bang71
카메라 UI 및 기능 구현, 동영상 플레이어 UI 및 기능 구현, 첫번째 페이지에서의 화면 전환과 관련된 데이터 획득 및 주입 기능 구현


## 뷰 구성 정보 및 기능

### 첫번째 페이지 - MainViewController
- 화면 구성
  - TableView를 이용하여 녹화된 영상들을 목록으로 구현
    - 녹화 첫 시작화면을 썸네일로 표시
    - 2개의 열을 가진 가변형 높이의 cell을 가진 레이아웃으로 구성
  
  - ScrollView를 이용하여 Pagination을 구현
    - cell이 화면 마지막도달시 새로운 데이터를 받아오도록 구현
    - PHFetchOptions()옵션중 fetchLimit를 이용하여 한번에 6개의 데이터를 불러들있도록 구현
  - cell 스와이프시 삭제할수 있도록 구현
  - timeString함수로 동영상 duration을 시간형식으로 구현

### 두번째 페이지 - CameraViewController
- 화면 구성
  - 카메라 previewView와 controlView가 존재
  - controlView의 leftButton 미구현
  - controlView의 녹화, 정지 및 저장 기능 구현
  - controlView의 rightButton(switching camera) 기능 구현
  - closeButton 구현
  
### 세번째 페이지 - MediaViewController
- 화면 구성
  - 동영상 playerView와 controlView가 존재
  - 첫번째 페이지로부터 videoURL을 주입받아 비디오 재생
  - 슬라이드 기능 구현
  - 재생 및 일시정지 구현
  - 초기화 구현
  - 공유 버튼 기능 미구현

### 프로젝트 후기 및 고찰
    

### 쏘롱
  - 프로젝트 과제 후기
    - 이번프로젝트는 첫번째 화면구성을 맡아 PHAsset의 형식에 대해서 공부를 할수있었다. 
    - Pagination을 구현해보았는데  한가지 아쉬운점이 있다면 스크롤뷰가 마지막셀에 도달햇을때 Indicator가 여러번 호출되어서  한번만 보여주고 싶었지만 이번프로젝트는 시간이 부족하여 구현하지못했는데 따로 공부를 해보야겠다.

### Bang71
  - 프로젝트 과제 후기
    - 시간 산정 실패로 일부 기능을 미구현한 것에 대해 아쉽습니다.
    - 95% 이상 공식 문서를 통해 구현한 것에 대해 뿌듯함을 느낍니다.
