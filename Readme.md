## 팀원

### Mango
<img src="https://user-images.githubusercontent.com/61138164/194685598-2fb5ef98-a001-44d2-b020-50554b1cf939.png" width="200" height="200"/></img>

### Eric
<img src="https://user-images.githubusercontent.com/65443311/194688047-aef1f883-c1ae-4822-884c-028da5c4cc03.jpg" width="200" height="200"></img>
## 폴더구조

- LifeCycles
    - 앱의 생명주기와 관련된 파일들을 담고 있습니다.
- Views
    - UI와 관련된 파일들을 담고 있습니다.
    - VIews, ViewControllers, ViewModels
- Model
    - 앱의 모델 계층과 관련된 파일들을 담고 있습니다.
    - CoreData의 xcdatamodel 파일, Dummy 데이터 생성 클래스
- Managers
    - View와 Model 계층간의 통신을 도와주는 Manager 클래스들이 위치합니다.
- Extensions
    - UIKit, Foundation, Combine 클래스의 Extension들을 모아두는 폴더입니다.
- Combine
    - UIKit Component들과 Combine으로 상호작용하기 위한 클래스들이 위치합니다.

## 구현화면

### 첫번째 화면
![Untitled](https://user-images.githubusercontent.com/65443311/195968295-a9d543d7-781f-467d-b767-7b229be2bc1e.png)

### 두번째 화면
![Untitled 1](https://user-images.githubusercontent.com/65443311/195968283-9962e97a-7cd6-46ed-a56b-c2fe9f04a9da.png)

### 세번째 화면
![Untitled 2](https://user-images.githubusercontent.com/65443311/195968293-4dbff202-91eb-4e6f-8612-c13b6f5deed7.png)

## 기능 구현 방식

### 첫번째 화면

- 비디오버튼 터치시 두번째 화면으로 이동
- TableView
    - CoreData에서 영상 목록 불러오기
    - Cell 터치시 세번째 화면으로 이동

### 두번째 화면

- 녹화버튼 누르면 비디오 녹화
    - 한번 더 누르면 녹화 종료 및 저장
- 카메라 전환 버튼 누르면 카메라 전환
    - 녹화중 버튼 클릭 X

### 세번째 화면

- 기능
    - 화면 아무곳이나 터치할 시, NavigationBar와 ControlView를 숨기거나 보여줄 수 있습니다.
    - 현재 진행시간을 표시하는 진행바가 있으며, 진행바에 대한 PanGesture와 TapGesture로 영상의 현재 재생중인 구간을 변경할 수 있습니다.
    - 뒤로가기 버튼을 클릭 시 영상을 제일 처음부터 재생합니다.
- 구조
    - MVVM 아키텍쳐를 이용해 구현하였습니다.
    - MVVM 아키텍쳐에서 필요한 Command 패턴과 Binding 패턴의 구현을 위해 Combine을 사용하였습니다.

### 공통

- VideoManager
    - UI에 가장 가까운 계층의 Manager로, CoreDataManager와 FireBaseManager를 사용해서, UI 계층에 Video 추가, 삭제, 불러오기와 같은 기능들을 제공합니다.
- CoreDataManager
    - CoreData와 관련된 CRUD 기능을 제공하는 클래스 입니다.
- FirebaseManager
    - Firebase Storage와 관련된 작업을 하는 클래스 입니다.
    - 영상의 업로드 / 다운로드 기능을 지원합니다.

## 역할분담

### Mango

- 첫번째 화면 구현
- 두번째 화면 구현
- CoreData를 이용해 영상 목록을 TableView로 구현
- AVFoundation을 이용해 Video 녹화기능구현

### Eric

- 세번째 화면 구현
- Video의 CRUD를 전반적으로 담당하는 VideoManager 구현
- VideoManager에서 사용하는 FirebaseManager와 CoreDataManager 구현
- VideoPlayerViewModel과 VideoManager의 UnitTest 작성
