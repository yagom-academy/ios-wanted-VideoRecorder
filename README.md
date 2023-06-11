# 📹 Video Recorder
> 일상을 영상으로 기록하는 앱입니다.
> * 주요 개념: `MVVM`, `Combine`, `Clean Architecture`
> 
> 프로젝트 기간: 2023.06.05 ~ 2023.06.11

### 💻 개발환경 및 라이브러리
<img src = "https://img.shields.io/badge/swift-5.8-orange"> <img src = "https://img.shields.io/badge/Minimum%20Diployment%20Target-14.0-blue"> 
<img src = "https://img.shields.io/badge/Firebase-10.9.0-red">

## ⭐️ 프로필
| Brody |
| :--------: |
 |<img height="200" src="https://avatars.githubusercontent.com/u/70146658?v=4" width="200"> |
|[Github Profile](https://github.com/seunghyunCheon) | 

</br>

## 📝 목차

1. [타임라인](#-타임라인)
2. [프로젝트 구조](#-프로젝트-구조)
3. [실행화면](#-실행화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [핵심경험](#-핵심경험)
6. [참고 링크](#-참고-링크)

</br>

# 📆 타임라인

- 2023.06.05: iOS녹화기능, CaptureSession 학습 
- 2023.06.06: 클린아키텍처 학습, 프로젝트 설정
- 2023.06.07: 비디오리스트 화면 UI구현 및 비디오 엔티티 정의
- 2023.06.08: 녹화화면 UI구현
- 2023.06.09: RecordingViewModel, RecordManager 모델, 코어데이터 서비스 구현
- 2023.06.10: CreateVideoUseCase, FetchVideoUseCase, VideoRepository 구현
- 2023.06.11: DeleteVideoUseCase, 비디오 플레이 화면 구현


</br>

# 🌳 프로젝트 구조

## UML Class Diagram
![](https://hackmd.io/_uploads/BkGzMLQP3.png)

</br>

## File Tree
```
└── ios-wanted-VideoRecorder
    ├── ios-wanted-VideoRecorder
    │   ├── AppDelegate.swift
    │   ├── SceneDelegate.swift
    │   ├── Data
    │   │   ├── Interfaces
    │   │   │   ├── CoreDataPersistenceServiceProtocol.swift
    │   │   │   └── CoreDataVideoPersistenceServiceProtocol.swift
    │   │   └── Repositories
    │   │       └── VideoRepository.swift
    │   ├── Domain
    │   │   ├── Entities
    │   │   │   └── VideoEntity.swift
    │   │   ├── Interfaces
    │   │   │   ├── Repositories
    │   │   │   │   └── VideoRepositoryProtocol.swift
    │   │   │   └── UseCases
    │   │   │       ├── CreateVideoUseCaseProtocol.swift
    │   │   │       ├── DeleteVideoUseCaseProtocol.swift
    │   │   │       ├── FetchVideoUseCaseProtocol.swift
    │   │   │       └── RefreshVideoUseCaseProtocol.swift
    │   │   └── UseCases
    │   │       ├── CreateVideoUseCase.swift
    │   │       ├── DeleteVideoUseCase.swift
    │   │       ├── FetchVideoUseCase.swift
    │   │       └── RefreshVideoUseCase.swift
    │   ├── VideoScene
    │   │   ├── VideoCell.swift
    │   │   ├── VideoListViewController.swift
    │   │   └── VideoListViewModel.swift
    │   ├── RecordingScene
    │   │   ├── RecordManager.swift
    │   │   ├── RecordingVideoViewController.swift
    │   │   ├── RecordingViewModel.swift
    │   │   └── VideoGenerator.swift
    │   ├── Service
    │   │   └── CoreData
    │   │       ├── CoreDataPersistenceService.swift
    │   │       ├── CoreDataVideoEntityPersistenceService.swift
    │   │       ├── Video+CoreDataClass.swift
    │   │       └── Video+CoreDataProperties.swift
    │   │────── Extension
    │   │   ├── CGImage+Extension.swift
    │   │   └── Combine
    │   │       ├── Double+Extension.swift
    │   │       ├── UIButton+Combine.swift
    │   │       └── UIControl+Combine.swift
    │   ├── Util
    │   │   └── ImageFileManager.swift
    │   ├── GoogleService-Info.plist
    │   ├── Info.plist
    └───└── model.xcdatamodeld
```

</br>

# 📱 실행화면

|비디오 녹화|비디오 삭제|비디오 화면전환|비디오 실행|
|:--:|:--:|:--:|:--:|
|<img src="https://github.com/seunghyunCheon/ios-wanted-VideoRecorder/assets/70146658/5c755ccf-112b-4763-a5a0-b2897dc61c81" width="700">|<img src="https://github.com/seunghyunCheon/ios-wanted-VideoRecorder/assets/70146658/873bbc6b-44fd-4226-aec8-acefb634ac55" width="700">|<img src="https://github.com/seunghyunCheon/ios-wanted-VideoRecorder/assets/70146658/80d26394-2ebe-4bdc-8054-835edf19f43b" width="700">|<img src="https://github.com/seunghyunCheon/ios-wanted-VideoRecorder/assets/70146658/7d9be2e2-79bd-45e2-84b5-7b26c6d70ee0" width="700">|




</br>

# 🚀 트러블 슈팅

## 1️⃣ 클린 아키텍처 적용

### 🔍 문제점
코어데이터 저장소로부터 패치된 데이터들을 뷰모델로 전달하는데 있어 외부 레이어가 내부 레이어를 직접참조하지 않는 방법으로 전달하는 방법을 고민함.

### ⚒️ 해결방안
* 뷰 로직은 ViewModel에서 갖도록 설계. 뷰컨과 뷰모델은 바인딩(Combine)을 통해서 의사소통. 뷰컨은 뷰모델의 Publisher를 관찰.
* 비즈니스 로직은 UseCase에서 갖도록 설계. 이 레이어에서는 repository를 소유하고 있으며 비즈니스 로직들이 캡슐화되어있으며 외부의 응답을 전달하는 역할을 가짐.
* 네트워크와 관련된 모델(Service)를 갖는 공간은 Repository에서 갖도록 설계. Repository에는 FirebaseService, CoreDataService 등의 데이터 저장소와의 상호작용을 추상화한 공간. 도메인 계층과 데이터 엑세스 로직을 분리하여 각자의 레이어를 명확하게 분리.
* 실제 데이터 저장소를 갖는 공간은 Service에서 갖도록 설계. CoreDataService, FirebaseService 등의 실제 데이터를 CRUD할 수 있는 레이어.
* View, ViewModel, UseCase, Data, Service로 분리하고 의존성 주입을 통해 내부레이어가 외부 레이어를 모르게 만듦.


### ⚒️ 추가 개선안
* 의존성 주입을 하기 위해 인스턴스가 생성되는 공간이 분산되어 있음.
* 이를 coordinate패턴을 통해 개선할 필요성이 있음.

</br>


## 2️⃣ CaptureSession 연결시점
### 🔍 문제점
* 앱을 처음 다운받고 녹화화면으로 이동했을 때 previewLayer가 제대로 보여지지 않는 문제 발생.

### ⚒️ 해결방안
* 카메라 권한을 체크하는 알럿은 비동기로 발생. 이 떄문에 viewDidLoad가 호출되었을 때 알럿이 띄워진 상태에서 previewLayer를 추가한다면 카메라가 설정되지않은 상태에서 실행되었기 떄문에 보여지지 않았던 것.
* 따라서 viewDidLoad에서 호출하는 것이 아니라 권한이 허용되었을 때 카메라를 설정하도록 변경

```swift
func checkPermission(about device: AVMediaType) {
    let status = AVCaptureDevice.authorizationStatus(for: device)
    switch status {
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: device) { granted in
            self.setupDevice()
        }
    case .authorized:
        self.setupDevice()
    default:
        return
    }
}
```

### 3️⃣ 코어데이터에 이미지를 저장했을 때 깨지는 문제
### 🔍 문제점
* 이미지 BinaryData를 코어데이터에 저장했을 때 불러올 때 깨지는 문제가 발생.

### ⚒️ 해결방안
* FileManager를 통해 디렉토리에 이미지를 저장해서 문제를 해결.
```swift
final class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()
    
    private init() { }
    
    func saveImageToDocumentDirectory(image: CGImage, fileName: String?) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let fileName else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        let uiImage = UIImage(cgImage: image)
        
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            return
        }
    }
    
    func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        return UIImage(data: imageData)
    }
}
```

</br>


# 📚 참고 링크

* [Apple Docs - AVKit](https://developer.apple.com/documentation/avkit)
* [Apple Docs - AVFoundation](https://developer.apple.com/documentation/avfoundation/)
* [Apple Docs - CMTime](https://developer.apple.com/documentation/coremedia/cmtime-u58)
* [Codeco - VideoRecord](https://www.kodeco.com/10857372-how-to-play-record-and-merge-videos-in-ios-and-swift)
* [Github - 클린아키텍처](https://github.com/boostcampwm-2021/iOS06-MateRunner/blob/dev/MateRunner/MateRunner/Data/Repository/Common/Protocol/FirestoreRepository.swift#L12)
* [StackOverFlow - CMTime](https://stackoverflow.com/questions/44267013/get-the-accurate-duration-of-a-video)
* [Swipe Action](https://luen.tistory.com/168)
* [Save Video](https://www.appsloveworld.com/swift/100/405/how-to-save-and-retrieve-mp4-in-core-data-swift)
* [AVFoundation, Camera 다루는 방법](https://ios-development.tistory.com/319)
