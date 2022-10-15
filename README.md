# ios-wanted-VideoRecorder

# Screenshot

| 비디오 리스트 페이지 | 비디오 촬영 페이지 | 비디오 플레이 페이지 |
| :----------------: | :----------------: | :----------------: |
| 영상1 | 영상2 | 영상3 |
<br>
<br>



# 폴더구조
<img width="500" alt="7" src="https://user-images.githubusercontent.com/73588175/195965183-6abca644-1584-4d5c-af71-0c60762738f5.png">
<br>
<br>

# Feature
### 비디오 리스트 페이지
- 코어데이터에서 8개씩 비디오 로드 (pagination)
- 스와이프 시 해당 비디오 삭제 (from FileManager, FireStore, CoreData)
- thumbnail caching
<br>
<br>

### 비디오 촬영 페이지
- `UIImagePickerController`에서 기본 카메라 접근
- 촬영이 완료되면 촬영날짜, 러닝타임과 함께 FileManager, FireStore, CoreData에 저장
<br>
<br>

### 비디오 플레이 페이지
- AVKit, AVFoundation을 활용해 AVPlayerViewController 사용 
<br>
<br>

# Contributors

| Eddy (권준상)                                               | Sole (진연서)                                  |
| :--------------------------------------------------: | :---------------------------------------------: |
|<img width="200" alt="7" src="https://user-images.githubusercontent.com/73588175/195965667-5a0b7bfc-a71a-4bce-be6f-caf4c14c901a.png">|<img width="200" alt="7" src="https://user-images.githubusercontent.com/73588175/195965811-9bc20c2e-d647-46e1-8f94-7fda39132437.png">|
|첫번째 화면 UI|첫번째 화면 UI|
|비디오 재생 구현|비디오 촬영 구현|
|FileManager, FireStore, CoreData 구현||
