# 🎥Video Recorder 

## 📚 목차
- [소개](#-소개)
- [타임라인](#-타임라인)
- [파일구조](#-파일구조)
- [실행화면](#-실행화면)
- [구현내용](#-구현내용)
- [참고 링크](#참고-링크)

## 🗣 소개
### 프로젝트 소개
#### 프로젝트 기간 : 23.06.05 ~ 23.06.11
- 동영상을 촬영하고 저장하는 앱


| 송준 |
| :--------: |
| <img src="https://user-images.githubusercontent.com/88870642/210026753-591175fe-27c1-4335-a2cb-f883bfeb2784.png" width="200" height="200"/>|
|[Github](https://github.com/kimseongj)|


## ⏱ 타임라인
|날짜|활동|
|---|---|
|2023.06.05|- 파일 분리 및 요구사항 파악|
|2023.06.06|- DiffableDataSource를 통한 TableView 구현|
|2023.06.07|- RecordingView 구현|
|2023.06.08|- RecordingButton을 CoreGraphic을 통해 구현|
|2023.06.09|- Timer 구현 </br> - RecordingButton 기능 구현|
|2023.06.10|- thumbnailImage 구현 </br> - rotatingCameraButton 구현|
|2023.06.11|- ReadMe 작성|

## 📂 파일구조
```swift

├── VideoRecoder
    ├── Resource
    │   ├── Assets.xcassets
    │   │ ├── AccentColor.colorset
    │   │   │   └── Contents.json
    │   │   ├── AppIcon.appiconset
    │   │   │   └── Contents.json
    │   │   └── Contents.json
    │   ├── Base.lproj
    │   │   └── LaunchScreen.storyboard
    │   └── Info.plist
    └── Source
        ├── Application
        │   ├── AppDelegate.swift
        │   └── SceneDelegate.swift
        ├── Model
        │   ├── CoreDataManager.swift
        │   └── Video.swift
        ├── Protocol
        │   └── IdentifierType.swift
        ├── Util
        │   └── Extension
        │       └── Double + Extension.swift
        └── View
            ├── PlayerViewController.swift
            ├── Recording
            │   ├── RecordingButton.swift
            │   ├── RecordingViewController.swift
            │   └── RecordingViewModel.swift
            └── VideoList
                ├── VideoListCell.swift
                ├── VideoListViewController.swift
                └── VideoListViewModel.swift

```

## 💻 실행화면

| 사용자 접근 | 카메라 전환 | 동영상 녹화 |
| :--------: | :--------: | :--------: |
| ![허용](https://github.com/kimseongj/TIL/assets/88870642/62a3a6d0-dc6c-4b21-a8d9-d6ff5a64053d)|![카메라 전환](https://github.com/kimseongj/TIL/assets/88870642/f77857a2-0079-497f-849e-82e83dd1a079)|![동영상촬영](https://github.com/kimseongj/TIL/assets/88870642/1cdd2928-ee47-4e18-8b4b-50e25ec238d8)|


## :fire: 구현내용
### 구현한 점 
- AVFoundation을 통한 동영상 녹화 구현
- FileManager를 사용하여 동영상 저장 

### 아쉬운 점
- CoreData와 FireStorage를 사용해보지 못한 점
- 데이터와 UI에 대한 분리작업을 완료하지 못한 점 


## 참고 링크
- [Swift Document AVFoundation](https://developer.apple.com/documentation/avfoundation/)
- [Swift Document CoreGraphics](https://developer.apple.com/documentation/coregraphics)

