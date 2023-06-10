# 🎥 Video Recording App
> 직접 촬영한 비디오를 녹화, 저장, 재생을 할 수 있는 어플입니다  

### 📅 프로젝트 기간
* 2023.6.5.(월)~2023.6.10.(토)

### 사용 스택
|UI|구조|Local Database|
|:--:|:--:|:--:|
|SwiftUI|MVVM|Realm|

- - - -
## 목차 📋
1. [팀원 소개](#1-팀원-소개)
2. [프로젝트 구조](#2-프로젝트-구조)
3. [실행화면](#3-실행화면)
4. [구현내용](#4-구현내용)
5. [프로젝트 핵심 경험](#5-프로젝트-핵심-경험)

- - - -
## 1. 팀원 소개
|레옹아범|
|:--:|
|<img src="https://github.com/hyemory/ios-bank-manager/blob/step4/images/leon.jpeg?raw=true" width="150">|
| [<img src="https://i.imgur.com/IOAJpzu.png" width="22"/> Github](https://github.com/fatherLeon) |

</details>

## 2. 프로젝트 구조

### 1️⃣ 폴더 구조
```
.
└── ios-wanted-VideoRecorder
    └── ios-wanted-VideoRecorder
        ├── Application
        │   └── ios_wanted_VideoRecorderApp.swift
        ├── Data
        │   ├── Entity
        │   │   ├── LocalFileURLs.swift
        │   │   ├── Video.swift
        │   │   └── VideoObject.swift
        │   └── Protocol
        │       └── Storable.swift
        ├── Domain
        │   ├── DefaultCameraUseCase.swift
        │   ├── DefaultVideoUseCase.swift
        │   ├── LocalDBUseCase.swift
        │   └── Protocol
        │       ├── CameraUseCase.swift
        │       ├── DBUseCase.swift
        │       └── VideoUseCase.swift
        ├── Presentation
        │   ├── CameraScene
        │   │   ├── View
        │   │   │   ├── CameraInterfaceView.swift
        │   │   │   ├── CameraSceneView.swift
        │   │   │   ├── CameraView.swift
        │   │   │   ├── PlayCircle.swift
        │   │   │   └── StopCircle.swift
        │   │   └── ViewModel
        │   │       └── CameraViewModel.swift
        │   ├── InfoScene
        │   │   └── View
        │   │       └── InfoView.swift
        │   ├── MainScene
        │   │   ├── View
        │   │   │   ├── MainListCell.swift
        │   │   │   ├── MainListView.swift
        │   │   │   └── ThumbnailImage.swift
        │   │   └── ViewModel
        │   │       └── MainViewModel.swift
        │   └── VideoScene
        │       ├── View
        │       │   ├── VideoInterfaceButtons.swift
        │       │   ├── VideoInterfaceView.swift
        │       │   ├── VideoPlayButton.swift
        │       │   ├── VideoSlider.swift
        │       │   └── VideoView.swift
        │       └── ViewModel
        │           └── VideoViewModel.swift
        └── Utility
            └── Extension
                └── Date++Extension.swift
```
### 2️⃣ 클래스 다이어그램
![](https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/ClassDiagram.drawio.png?raw=true)

## 3. 실행화면

|첫 실행화면(권한)|영상 촬영|영상 삭제|
|:--:|:--:|:--:|
|<img src="https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/첫화면.gif?raw=true">|<img src="https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/영상촬영.gif?raw=true">|<img src="https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/영상삭제.gif?raw=true">|

|영상 재생|영상 3초전으로 이동|영상 상세정보 보기|영상 제목 수정|
|:--:|:--:|:--:|:--:|
|<img src="https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/영상재생.gif?raw=true">|<img src="https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/영상3초전으로.gif?raw=true">|<img src="https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/영상상세정보보기.gif?raw=true">|<img src="https://github.com/fatherLeon/ios-wanted-VideoRecorder/blob/develop/Image/영상제목수정.gif?raw=true">|

## 4. 구현내용

* `Realm`을 이용한 영상 기본 데이터 저장
* `AVPlayer`를 통한 영상 플레이어 구현
* 영상 플레이어 인터페이스 구현

## 5. 프로젝트 핵심 경험
* `SwiftUI`를 이용한 UI구현
* `AVPlayer`를 통한 영상 재생
* `AVCapture`관련 타입을 통한 영상 녹화
