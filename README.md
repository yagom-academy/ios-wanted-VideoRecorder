# ios-wanted-VideoRecorder

## 👥 팀원 소개

| Eddy (권준상)                                               | Sole (진연서)                                  |
| :--------------------------------------------------: | :--------------------------------------------------: |
|<img width="200" alt="7" src="https://user-images.githubusercontent.com/73588175/195965667-5a0b7bfc-a71a-4bce-be6f-caf4c14c901a.png">|<img width="200" alt="7" src="https://user-images.githubusercontent.com/73588175/195965811-9bc20c2e-d647-46e1-8f94-7fda39132437.png">|
|첫번째 화면 UI|첫번째 화면 UI|
|비디오 재생 구현|비디오 촬영 구현|
|FileManager, FireStore, CoreData|리팩토링|

<br>

## 📁 폴더 구조
<img width="500" alt="7" src="https://user-images.githubusercontent.com/73588175/195965183-6abca644-1584-4d5c-af71-0c60762738f5.png">
<br>

## 🛠 기능 구현
### 비디오 리스트 페이지
- 코어데이터에서 8개씩 비디오 로드 (pagination)
- 스와이프 시 해당 비디오 삭제 (from FileManager, FireStore, CoreData)
- thumbnail caching
<br>

### 비디오 촬영 페이지
- `UIImagePickerController`에서 기본 카메라 접근
- 촬영이 완료되면 촬영날짜, 러닝타임과 함께 FileManager, FireStore, CoreData에 저장
<br>

### 비디오 플레이 페이지
- AVKit, AVFoundation을 활용해 AVPlayerViewController 사용 
<br>


## 📱 실행 화면

### 비디오 리스트 페이지


https://user-images.githubusercontent.com/61138164/195970104-453f5470-dc26-453d-a9c9-4400f918546d.mov


<br>

### 비디오 촬영 페이지

https://user-images.githubusercontent.com/61138164/195969050-0c1d0f37-2aa8-4a94-aeec-76ad3d04d92a.mov

<br>

### 비디오 플레이 페이지

https://user-images.githubusercontent.com/61138164/195969074-54c7147c-dea6-457c-bc2f-8d35a3ba401d.mov


<br>
