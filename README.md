# 🎥 VideoRecorder
> Device Camera를 이용해 동영상을 촬영/재생하는 앱입니다.
> 촬영한 동영상은 Photo Album에 저장됩니다.
> * 주요 개념: `AVFoundation`, `PhotoKit`, `MVVM`, `Combine`
> 
> 프로젝트 기간: 2023.06.05 ~ 2023.06.11

### 💻 개발환경 및 라이브러리
<img src = "https://img.shields.io/badge/swift-5.8-orange"> <img src = "https://img.shields.io/badge/Minimum%20Diployment%20Target-14.0-blue">

## ⭐️ 팀원
| Rowan | 
| :--------: | 
| <Img src = "https://i.imgur.com/S1hlffJ.jpg"  height="200"/> |
| [Github Profile](https://github.com/Kyeongjun2) |

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

- 2023.06.05: AVFoundation, Photos 프레임워크 학습
- 2023.06.06: AVCaptureSession 학습, RecordingView 관련 객체 구현
- 2023.06.07: CaptureSession 카메라 포지션 스위칭 기능, view-viewmodel binding 구현
- 2023.06.08: AlbumRepository, VideoFetchService 구현
- 2023.06.09: 코드 리팩토링, tableview 관련 기능, VideoPlayerView 관련 객체 구현(AVPlayer 기능 포함)
- 2023.06.10: UI 컴포넌트 및 data binding 리팩토링
- 2023.06.11: README 작성

</br>

# 🌳 프로젝트 구조

## UML Class Diagram
![](https://hackmd.io/_uploads/ryUnu0Wwn.jpg)

</br>

## File Tree
```
└── VideoRecorder
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    ├── Service
    │   ├── VideoAlbumService.swift
    │   └── VideoRecordingService.swift
    ├── Repository
    │   └── AlbumRepository.swift
    ├── Domain
    │   └── VideoData.swift
    ├── VideoListView
    │   ├── VideoListCell.swift
    │   ├── VideoListCellAccessoryView.swift
    │   ├── VideoListViewController.swift
    │   └── VideoListViewModel.swift
    ├── RecordingView
    │   ├── RecordingViewController.swift
    │   └── RecordingViewModel.swift
    ├── VideoPlayerView
    │   ├── VideoControllerView.swift
    │   ├── VideoPlayerViewController.swift
    │   └── VideoPlayerViewModel.swift
    ├── Extensions
    │   ├── Array.swift
    │   └── UIControl+Combine.swift
    ├── Resources
    │   ├── Assets
    │   └── LaunchScreen.storyboard
    └── Info.plist
```

</br>

# 📱 실행화면


| VideoList | Recording | VideoPlayer |
| :--------: | :--------: | :--------: |
| <Img src = "https://github.com/Kyeongjun2/ios-wanted-VideoRecorder/assets/114981173/93493704-3c8e-417c-a7da-f4a4e9df87d5" height="400">     | <Img src = "https://github.com/Kyeongjun2/ios-wanted-VideoRecorder/assets/114981173/5cb1b60f-37ad-48bd-967e-48f8b3ccfa38" height="400">   | <Img src = "https://github.com/Kyeongjun2/ios-wanted-VideoRecorder/assets/114981173/c043d3b7-296c-4edd-885e-8ac2d7c04adf"  height="400">     |

</br>

# 🚀 트러블 슈팅
## 1️⃣ 녹화 시간 출력
### 🔍 문제점
Recording View에서 녹화 버튼을 눌렀을 때, label에 녹화 시간을 표시하지 못하고 00:00 인 채로 녹화를 진행했습니다.

</br>

### ⚒️ 해결방안
ViewModel에서 Timer publisher를 통해 녹화버튼이 눌렸을 때 Capture Session이 Recording 중인 상태라면 녹화시간에 0.001을 더해주었습니다. 변경된 시간 정보를 업데이트할 수 있도록 label과 바인딩해서 문제를 해결했습니다.

```swift
// ViewModel ...
lazy var recordingTimer = Timer
    .TimerPublisher(interval: 0.001, runLoop: .main, mode: .default)
    .autoconnect()
    .map { [weak self] date in
        guard let self,
              let isRecording = self.videoRecordingService.isRecording
        else { return Double.zero }

        if isRecording {
            self.recordingTime += Double(0.001)
            return self.recordingTime
        }

        return Double.zero
    }
    .map { second in
        let secondString = String(format: "%02d", Int(second.truncatingRemainder(dividingBy: 60)))
        let minuteString = String(format: "%02d", Int(second / 60))

        return "\(minuteString):\(secondString)"
    }


// ViewController ...
private func bindState() {
    viewModel.recordingTimer
        .sink { [weak self] labelText in
            guard let self else { return }
            self.timerLabel.text = labelText
        }
        .store(in: &cancellables)
}
```


</br>


## 2️⃣ VideoPlayer 화면에 video의 duration 전달
### 🔍 문제점
AVPlayerItem 객체의 duration 프로퍼티를 활용하여 동영상의 총 재생 시간을 뷰에 전달하려고 했습니다.

```swift
// ViewModel
var videoDuration: Float {
    guard videoItem?.status == .readyToPlay,
          let duration = videoItem?.duration else { return .zero }

    return Float(CMTimeGetSeconds(duration))
}


//ViewController
private func bindState() {
        viewModel.itemStatusPublisher()
            .sink { [weak self] duration in
                self?.setupSliderValue(maximumValue: duration)
            }
            .store(in: &cancellables)
    // ...
}
```

하지만 위 코드를 실행해보면 duration이 제대로 전달되지 않았습니다.
lldb를 통해 이유를 알아본 결과, videoItem의 status가 `unknown`이기 때문에 duration이 전달되지 않았던 것으로 확인했습니다.

</br>

###  ⚒️ 해결방안
videoItem의 status를 확인하려면 KVO를 활용해야 한다는 공식 문서의 내용을 확인하고 리팩토링을 진행했습니다.

Combine에서 제공하는 KVO publisher를 이용했습니다.
```swift
// ViewModel
func itemStatusPublisher() -> AnyPublisher<(Float, String), Never> {
    return videoItem.publisher(for: \.status)
        .compactMap { [weak self] status in
            status == .readyToPlay ? self?.videoPlayer.currentItem?.duration : nil
        }
        .map { [weak self] duration in
            guard let self else { return (0, "") }

            let seconds = CMTimeGetSeconds(duration)
            let durationText = self.convertToTimeString(from: seconds)

            return (Float(seconds), durationText)
        }
        .eraseToAnyPublisher()
}


// ViewController
private func bindState() {
    viewModel.itemStatusPublisher()
        .sink { [weak self] (duration, durationText) in
            guard let self else { return }
            self.setupSliderValue(maximumValue: duration)
            self.videoControllerView.runtimeLabel.text = durationText
        }
        .store(in: &cancellables)
    // ...
}
```

</br>

## 3️⃣ CaptureSesson.startRunning
### 🔍 문제점
AVCaptureSession 객체의 startRunning 메서드를 main 스레드에서 호출하면 session의 시작을 main 스레드에서 할 경우 UI의 반응성을 저하시킬 수 있다는 오류가 발생했습니다.

![](https://hackmd.io/_uploads/HywsCJXDh.png)

</br>

###  ⚒️ 해결방안
session에 관한 메서드를 global dispatchQueue에서 호출하였습니다.

```swift
func startSession() {
    DispatchQueue.global().async {
        self.captureSession.startRunning()
    }
}
    
func stopSession() {
    DispatchQueue.global().async {
        self.captureSession.stopRunning()
    }
}
```

메서드에 DispatchQueue.global()을 쓰기 보다는 VideoRecordingService 내부에 serial dispatch queue를 프로퍼티로 갖게 하여 해당 큐에서 비동기적으로 호출될 수 있도록 처리하는 방식으로 개선할 수 있을 것 같습니다.

</br>


# ✨ 핵심경험

<details>
    <summary><big>✅ AVFoundation</big></summary>
    
</br>

## 🔸 AVCaptureSession
캡처 동작을 구성하고 입력 장치에서 출력 캡처로의 데이터 흐름(data flow)을 조정하는 객체

</br>

### Overview
실시간 캡처를 수행하려면 캡처 세션을 인스턴스화하고 적절한 입력 및 출력을 추가한다. 다음 코드는 오디오를 녹음하도록 캡처 장치를 구성하는 방법을 보여준다.

```swift
// Create the capture session.
let captureSession = AVCaptureSession()

// Find the default audio device.
guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }

do {
    // Wrap the audio device in a capture device input.
    let audioInput = try AVCaptureDeviceInput(device: audioDevice)
    // If the input can be added, add it to the session.
    if captureSession.canAddInput(audioInput) {
        captureSession.addInput(audioInput)
    }
} catch {
    // Configuration failed. Handle error.
}
```

`startRunning()` 메서드를 호출하여 입력에서 출력으로의 data flow를 시작하고 `stopRunning()` 메서드를 호출하여 flow를 중지한다.

> **🔺Important** </br>
> _startRunning()_ 메서드는 다소 시간이 걸릴 수 있는 차단 호출(blocking call)이므로 serial dispatch queue에서 세션을 시작하여 main queue를 차단하지 않도록 해야한다. (UI 응답성 유지를 위함)

`sessionPreset` 프로퍼티를 사용하여 출력에 대한 품질 수준, 비트 전송률 또는 기타 설정을 customizing 한다. 가장 일반적인 캡처 구성은 세션 preset을 통해 사용할 수 있다. 그러나 일부 특수한 옵션(ex: high frame rate)은 [AVCaptureDevice](https://developer.apple.com/documentation/avfoundation/avcapturedevice) 인스턴스에서 캡처 형식을 직접 설정해야 한다.

</br>

## 🔸 Setting Up a Capture Session
사진 또는 비디오를 캡처하기 전에 입력 장치, 출력 미디어, 미리 보기 뷰 및 기본 설정을 구성하자.

### Overview
`AVCaptureSession`은 iOS 및 macOS에서 모든 미디어 캡처의 기반이 된다. OS 캡처 인프라 및 캡처 장치에 대한 앱의 독점 액세스와 입력 장치에서 미디어 출력으로의 데이터 흐름을 관리한다. 입력과 출력 간의 연결을 구성하는 방법에 따라 CaptureSession의 기능이 정의된다. 예를 들어, 아래 다이어그램은 사진과 동영상을 모두 캡처할 수 있고 iPhone 후면 카메라와 마이크를 사용하여 카메라 미리 보기를 제공하는 capture session을 보여준다.

[**그림 1** Capture Session Architecture]
![](https://hackmd.io/_uploads/HJ9Ihemvn.png)

</br>

#### ▪️ 세션에 입력 및 출력 연결하기
모든 capture session에는 하나 이상의 캡처 입력 및 출력이 필요하다. AVCaptureInput의 서브클래스인 Capture input은 일반적으로 iOS 장치 또는 Mac에 내장된 카메라 및 마이크와 같은 기록 장치인 미디어 소스이다. AVCaptureOutput 서브클래스인 Capture output은 capture input에서 제공하는 데이터를 사용하여 이미지 및 동영상 파일과 같은 미디어를 생성한다.

비디오 입력(사진 또는 동영상 캡처)에 카메라를 사용하려면 적절한 AVCaptureDevice를 선택하고 해당 AVCaptureDeviceInput을 생성한 다음 세션에 추가한다.

```swift
captureSession.beginConfiguration()
let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                          for: .video, 
                                          position: .unspecified)
guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
      captureSession.canAddInput(videoDeviceInput)
else { return }
captureSession.addInput(videoDeviceInput)

```

> **Note** </br>
> iOS는 카메라 장치를 선택하는 몇 가지 방법을 제공한다. 자세한 내용은 [Choosing a Capture Device](https://developer.apple.com/documentation/avfoundation/capture_setup/choosing_a_capture_device) 참고.

다음으로 선택한 카메라에서 캡처하려는 미디어 종류에 대한 output을 추가한다. 예를 들어, 사진 캡처를 활성화하려면 AVCapturePhotoOutput을 세션에 추가한다.

```swift
let photoOutput = AVCapturePhotoOutput()
guard captureSession.canAddOutput(photoOutput) else { return }
captureSession.sessionPreset = .photo
captureSession.addOutput(photoOutput)
captureSession.commitConfiguration()
```

세션에는 여러 input 및 output이 있을 수 있다.

* movie에서 비디오와 오디오를 모두 녹음하려면 카메라와 마이크 장치 모두에 대한 input을 추가할 것.
* 동일한 카메라에서 사진과 동영상을 모두 캡처하려면 세션에 AVCapturePhotoOutput 및 AVCaptureMovieFileOutput을 모두 추가할 것.

> **🔺 Important** </br>
> 중요한 세션의 input / output 출력을 변경하기 전에 [beginConfiguration()](https://developer.apple.com/documentation/avfoundation/avcapturesession/1389174-beginconfiguration)을 호출하고 변경 후 [commitConfiguration()](https://developer.apple.com/documentation/avfoundation/avcapturesession/1388173-commitconfiguration)을 호출할 것.

</br>

#### ▪️ 카메라 미리 보기 표시하기
기존 카메라의 viewfinder에서와 같이 사진을 찍거나 비디오 녹화를 시작하기 전에 사용자가 카메라의 입력을 볼 수 있도록 하는 것이 중요하다. [AVCaptureVideoPreviewLayer](https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer)를 captrue session에 연결하여 이러한 미리 보기를 제공할 수 있다. 그러면 세션이 실행될 때마다 카메라의 라이브 비디오 피드가 표시된다.

`AVCaptureVideoPreviewLayer`는 CoreAnimation layer이므로 다른 CALayer 서브클래스와 마찬가지로 인터페이스에서 표시하고 스타일을 지정할 수 있다. UIKit 앱에 preview layer를 추가하는 가장 간단한 방법은 아래와 같이 layerClass가 AVCaptureVideoPreviewLayer인 UIView 서브클래스를 정의하는 것이다.

```swift
class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
```

그 다음, capture session에서 preview layer를 사용하려면 레이어의 `session` 프로퍼티를 설정한다.

```swift
self.previewView.videoPreviewLayer.session = self.captureSession
```

> **Note** </br>
> 앱이 여러 인터페이스 방향을 지원하는 경우 capture session에 대한 preview layer의 `connection`을 사용하여 UI와 일치하는 videoOrientation을 설정한다.

</br>

#### ▪️ Capture Session 실행하기
Input, Output 및 preview를 구성한 후 `startRunning()`을 호출해 데이터가 input에서 output으로 흐르도록 한다.

일부 capture output의 경우, 세션을 실행하기만 하면 미디어 캡처를 시작할 수 있다. 예를 들어 세션에 AVCaptureVideoDataOutput이 포함된 경우 세션이 실행되는 즉시 제공되는 비디오 프레임을 수신하기 시작한다.

다른 capture output의 경우 먼저 실행 중인 세션을 시작한 다음 capture output 클래스 자체를 사용하여 캡처를 시작한다. 예를 들어 사진 앱에서 세션을 실행하면 viewfinder 스타일의 미리 보기가 가능하지만 `AVCapturePhotoOutput capturePhoto(with:delegate:)` 메서드를 사용하여 사진을 찍는다.

</br>

## 🔸 AVCaptureDevice
카메라나 마이크와 같은 하드웨어 또는 가상 캡처 장치를 나타내는 객체.

</br>

### Overview
Capture Device는 AVCaptureSession에 연결하는 세션 입력을 캡처하기 위해 미디어 데이터를 제공한다. 개별 장치는 특정 타입의 미디어 스트림을 하나 이상 제공할 수 있다.

캡처 장치 인스턴스를 직접 생성하지 말 것. 대신에, AVCaptureDevice.DiscoverySession의 인스턴스를 사용하거나 `default(_:for:position:)` 메서드를 호출하여 검색한다.

캡처 장치는 몇 가지 configuration 옵션을 제공한다. 포커스 모드, 노출 모드 등과 같은 장치 속성을 구성하기 전에 먼저 `lockForConfiguration()` 메서드를 호출하여 장치에 대한 잠금을 획득해야 한다. 또한 설정하려는 새 모드가 장치에 유효한지 확인하기 위해 장치의 기능을 쿼리해야 한다. 그 다음 속성을 설정하고 `unlockForConfiguration()` 메서드를 사용하여 잠금을 해제할 수 있다. 설정 가능한 모든 장치 속성이 변경되지 않도록 하려면 잠금을 유지할 수 있다. 그러나 불필요하게 기기 잠금을 유지하면 기기를 공유하는 다른 앱에서 캡처 품질이 저하될 수 있으므로 권장되지 않는다.

</br>

## 🔸 미디어 탐색하기
미디어 아이템을 검색하거나 스크러빙하여 특정 시점에 빠르게 액세스 하자.

### Overview
일반적인 선형 playback 외에도 사용자는 미디어 내의 다양한 관심 지점에 빠르게 도달하기 위해 비선형 방식으로 검색하거나 스크러빙할 수 있는 기능을 원한다. AVKit은 자동으로 스크러빙 컨트롤을 제공하지만(미디어에서 지원하는 경우) 사용자 지정 플레이어를 구축하는 경우 이 기능을 직접 구축해야 한다. AVKit을 사용하는 경우에도 사용자가 미디어의 다양한 위치로 빠르게 건너뛸 수 있는 테이블 뷰 또는 컬렉션 뷰와 같은 추가 사용자 인터페이스를 제공할 수 있다.

</br>

#### ▪️ 특정 시간으로 빠르게 이동하기
AVPlayer 및 AVPlayerItem 메서드를 사용하여 여러가지 방법으로 재생 시간 검색이 가능하다. 가장 일반적인 방법은 AVPlayer의 [seek(to:)](https://developer.apple.com/documentation/avfoundation/avplayer/1385953-seek) 메서드를 사용하여 다음과 같이 대상 [CMTime](https://developer.apple.com/documentation/coremedia/cmtime) 값을 전달받는 것이다.

```swift
// Seek to the 2 minute mark
let time = CMTime(value: 120, timescale: 1)
player.seek(to: time)
```

`seek(to:)` 메서드는 표시중인 영상을 빠르게 탐색할 수 있는 편리한 방법이지만 정확성보다는 속도에 더 중점을 두고 있다. 이는 플레이어가 이동하는 실제 시간이 요청한 시간과 다를 수 있음을 의미한다.

</br>

#### ▪️ 특정 시간으로 정확하게 이동하기
정확한 검색 동작을 구현해야 하는 경우 목표 시간(이전 및 이후)에서 허용되는 편차를 나타낼 수 있는 [seek(to:toleranceBefore:toleranceAfter:)](https://developer.apple.com/documentation/avfoundation/avplayer/1387741-seek) 메서드를 사용할 것. 만약 정확한 샘플 검색 동작을 제공해야 하는 경우 허용 오차가 0이 되도록 지정할 수 있다.

```swift
// Seek to the first frame at 3:25 mark
let seekTime = CMTime(seconds: 205, preferredTimescale: Int32(NSEC_PER_SEC))
player.seek(to: seekTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
```

> **🔺 Important** </br>
> 허용 오차를 작게 또는 0으로 하여 `seek(to:toleranceBefore:toleranceAfter:)` 메서드를 호출하면 추가 디코딩 지연이 발생할 수 있으며, 이는 앱의 검색 동작에 영향을 줄 수 있다.

</details>

<details>
    <summary><big>✅ Photos</big></summary>

</br>

## 🔸 PHPhotoLibrary
사용자의 사진 라이브러리에 대한 액세스 및 변경을 관리하는 객체.

### Overview
해당 객체는 로컬 기기에 저장된 asset과 iCloud 사진에 저장된 asset을 포함하여 사진 앱이 관리하는 전체 asset 및 collection Set을 나타낸다. 아래 작업에 이 객체를 사용한다.

* 사진 컨텐츠에 액세스할 수 있는 앱에 대한 사용자 권한 검색 또는 확인
* Asset 및 Collection 변경 (ex: Asset Metadata/컨텐츠 편집, 새 asset 삽입 또는 collection member 재정렬)
* 사진 라이브러리의 이전 상태 이후로 변경된 레코드 확인
* 라이브러리가 변경될 때 시스템이 보내는 업데이트 메시지 등록

#### ▪️ 프로젝트에서 활용
* 새 asset 삽입
```swift
PHPhotoLibrary.shared().performChanges {
    if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL),
       let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset,
       let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection) {
        let assets: NSArray = [assetPlaceHolder]
        albumChangeRequest.addAssets(assets)
    }
}
```

* asset 삭제
```swift
PHPhotoLibrary.shared().performChanges {
    PHAssetChangeRequest.deleteAssets([video] as NSArray)
}
```

* 권한 확인 / 요청
```swift
if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in }
}

if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
    self.createAlbum()
} else {
    PHPhotoLibrary.requestAuthorization(for: .readWrite,
                                        handler: requestAuthorizationHandler)
}
```

* 새 collection 만들기
```swift
PHPhotoLibrary.shared().performChanges({
    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: Self.albumName)
}, completionHandler: { [weak self] isSuccessed, error in
    guard let self else { return }

    if isSuccessed {
        self.assetCollection = self.fetchAssetCollectionForAlbum()
    } else {
        print(error ?? "Unexpected result occured while creating PHAssetCollection")
    }
})
```

</br>

## 🔸 Fetching Assets
Asset metadata를 검색하거나 전체 asset 컨텐츠 요청하기

### Overview
Asset을 활용한 작업을 시작하기 위해 asset을 fetch한다. 본 문서에 나열된 클래스 메서드를 사용하여 표시하거나 편집하려는 asset을 나타내는 하나 이상의 `PHAsset` 인스턴스를 검색한다. 예를 들어 asset collection(ex: Album or moment)의 모든 asset을 가져오려면 [fetchAssets(in:options:)](https://developer.apple.com/documentation/photokit/phasset/1624757-fetchassets) 메서드를 사용한다. 각 fetch 메서드는 검색할 asset과 정렬 방법을 지정하는 데 사용하는 [PHFetchOptions](https://developer.apple.com/documentation/photokit/phfetchoptions) 파라미터를 사용한다.

> **🔺 Important** </br>
> 사진 라이브러리에 액세스하거나 수정하려면 사용자의 명시적인 승인이 필요하다. 본 문서에 나열된 메서드 중 하나를 처음 호출하면 Photos 프레임워크에서 자동으로 사용자에게 인증을 요청한다. 또는 PHPhotoLibrary의 [requestAuthorization(_:)](https://developer.apple.com/documentation/photokit/phphotolibrary/1620736-requestauthorization) 메서드를 사용하여 선택한 시간에 사용자에게 메시지를 표시할 수 있다. 자세한 내용은 `Requesting Authorization to Acess Photos` 참고.

</br>

## 🔸 Asset 및 thumbnail 로드 및 캐싱하기
빠른 재사용을 위해 이미지, 비디오 또는 Live Photos 컨텐츠 및 캐시를 요청하자.

### Overview
Photos 프레임워크는 자동으로 이미지를 사양에 따라 다운로드하거나 생성하여 빠르게 재사용할 수 있도록 캐싱한다. [PHImageManager](https://developer.apple.com/documentation/photokit/phimagemanager) 클래스를 사용하여 지정된 크기의 Asset image를 요청하거나 AVFoundation 객체를 사용하여 video asset과 함께 작업할 것. 많은 수의 asset으로 작업할 때(ex: 콜렉션 뷰를 thumbnail로 채울 때) [PHCachingImageManager](https://developer.apple.com/documentation/photokit/phcachingimagemanager) 서브클래스를 사용하여 이미지를 배치로 미리 로드한다.

</details>

<details>
    <summary><big>✅ Combine - KVO</big></summary>
    
</br>

## 🔸 Combine을 통한 Key-Value Observing
Combine 프레임워크에서는 NSObject 객체에 대한 KVO Publisher를 제공한다. 이를 활용하여 기존의 KVO 메서드를 Publisher로 convert할 수 있다.

이번 프로젝트에 적용한 방법은 아래 코드와 같다.

```swift
// ViewModel
func itemStatusPublisher() -> AnyPublisher<(Float, String), Never> {
    return videoItem.publisher(for: \.status)
        .compactMap { [weak self] status in
            status == .readyToPlay ? self?.videoPlayer.currentItem?.duration : nil
        }
        .map { [weak self] duration in
            guard let self else { return (0, "") }

            let seconds = CMTimeGetSeconds(duration)
            let durationText = self.convertToTimeString(from: seconds)

            return (Float(seconds), durationText)
        }
        .eraseToAnyPublisher()
}


// ViewController
private func bindState() {
    viewModel.itemStatusPublisher()
        .sink { [weak self] (duration, durationText) in
            guard let self else { return }
            self.setupSliderValue(maximumValue: duration)
            self.videoControllerView.runtimeLabel.text = durationText
        }
        .store(in: &cancellables)
    // ...
}
    
```

</details>

---

</br>

# 📚 참고 링크

* [🍎 Apple Docs - Combine](https://developer.apple.com/documentation/combine)
* [🍎 Apple Docs - Performing Key-Value Observing with Combine](https://developer.apple.com/documentation/combine/performing-key-value-observing-with-combine)
* [🍎 Apple Docs - PhotoKit](https://developer.apple.com/documentation/photokit)
* [🍎 Apple Docs - PHPhotoLibrary](https://developer.apple.com/documentation/photokit/phphotolibrary)
* [🍎 Apple Docs - Fetching Assets
](https://developer.apple.com/documentation/photokit/phasset/fetching_assets)
* [🍎 Apple Docs - Loading and Caching Assets and Thumbnails](https://developer.apple.com/documentation/photokit/loading_and_caching_assets_and_thumbnails) 
* [🍎 Apple Docs - AVFoundation](https://developer.apple.com/documentation/avfoundation)
* [🍎 Apple Docs - Setting Up a Capture Session](https://developer.apple.com/documentation/avfoundation/capture_setup/setting_up_a_capture_session)
* [🍎 Apple Docs - Seeking Through Media
](https://developer.apple.com/documentation/avfoundation/media_playback/seeking_through_media)
* [곰튀김 YouTube - MVVM](https://www.youtube.com/watch?v=M58LqynqQHc)
