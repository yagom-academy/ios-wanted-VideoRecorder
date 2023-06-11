# 🎥 비디오레코더

> 영상을 촬영하고 재생하는 앱입니다.
> 
> 프로젝트 기간: 2023-06-05 ~ 2023-06-11
>
> [소스 코드: master branch](https://github.com/kokkilE/ios-wanted-VideoRecorder/tree/master)


</br>

## ⭐️ 팀원
| kokkilE |
| :---: |
| <Img src = "https://hackmd.io/_uploads/SJL_ZRGw2.jpg"  height="300"/> |
| [Github Profile](https://github.com/kokkilE) |

</br>

## 💻 개발환경 및 라이브러리
<img src = "https://img.shields.io/badge/swift-5.8-orange"> <img src = "https://img.shields.io/badge/Xcode-14.3-orange"> <img src = "https://img.shields.io/badge/Minimum%20Deployments-14.0-orange"> <img src = "https://img.shields.io/badge/Firebase-10.10.0-green">

### 적용 프레임워크
<img src = "https://img.shields.io/badge/UIKit--green"> <img src = "https://img.shields.io/badge/Combine--green"> <img src = "https://img.shields.io/badge/AVFoundation--green"> <img src = "https://img.shields.io/badge/CoreData--green">  <img src = "https://img.shields.io/badge/Foundation--green">

</br>

## 📝 목차
1. [타임 라인](#-타임-라인)
2. [프로젝트 구조](#-프로젝트-구조)
3. [구현 기능](#-구현-기능)
4. [아쉬운 점](#-아쉬운-점)
5. [참고 링크](#-참고-링크)

</br>

# 📆 타임라인
| 일자 | <center>구현 내용 |
| :---: | --- |
| 23.06.05(월) | - 요구사항 분석 </br> - 목록 화면의 컬렉션뷰 레이아웃 구성 |
| 23.06.06(화) | - 컬렉션뷰 셀 구현 </br> - 데이터 모델 및 데이터 관리 객체 구현 |
| 23.06.07(수) | - 영상 녹화 화면 구현 </br> |
| 23.06.08(목) | - 영상 녹화 기능 및 UI 개선 </br> - 코어데이터 모델 구현|
| 23.06.09(금) | - 코어데이터 CRUD 기능 구현 </br> - 영상 재생 기능 구현  |
| 23.06.10(토) | - 영상 시간 표시 레이블 구현 </br> - 목록 화면의 썸네일 구현 </br> - pagination 구현 |
| 23.06.11(일) | - 영상 상세 정보 화면 구현 |

</br>

# ⚒️ 프로젝트 구조
## Fire Tree

<details>
    <summary><big>📂 펼치기 / 접기 </big></summary>

```
VideoRecorder
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── Resources
│   └── Assets.xcassets
│
├── Source
│   ├── Common
│   │   ├── Utilitiy
│   │   │   ├── Extension
│   │   │   │   ├── Array+Subscript.swift
│   │   │   │   ├── CMTime+formattedTime.swift
│   │   │   │   ├── DateFormatter+dateToText.swift
│   │   │   │   ├── UICollectionViewCell+ReuseIdentifying.swift
│   │   │   │   └── URL+createURL.swift
│   │   │   ├── AlertManager.swift
│   │   │   └── ThumbnailManager.swift
│   │   ├── Protocol
│   │   │   ├── DataTransferObject.swift
│   │   │   └── DataAccessObject.swift
│   │   └── Model
│   │      └── Video.swift
│   ├── Database
│   │   ├── Local
│   │   │   ├── CoreDataManager.swift
│   │   │   └── VideoEntity+CoreDataClass.swift
│   │   ├── Remote
│   │   │   ├── FirebaseManager.swift
│   │   │   └── CodeManager.swift
│   │   └── Manager
│   │       ├── VideoManager.swift
│   │       └── VideoRecorderService.swift
│   ├── VideoList
│   │   ├── Components
│   │   │   ├── LoadingView.swift
│   │   │   └── VideoListCell.swift
│   │   ├── VideoListViewController.swift
│   │   └── VideoListViewModel.swift
│   ├── PlayVideo
│   │   ├── Components
│   │   │   └── PlayControlView.swift
│   │   ├── PlayVideoViewController.swift
│   │   └── PlayVideoViewModel.swift
│   └── RecordVideo
│       ├── Components
│       │   └── RecordControlView.swift
│       ├── Manager
│       │   ├── Recorder.swift
│       │   └── TimerManager.swift
│       ├── RecordVideoViewController.swift
│       └── RecordVideoViewModel.swift
│
├── GoogleService-Info.plist
└── Info.plist
```

</details>

## Class Diagram

![](https://hackmd.io/_uploads/rkb8_X7w3.png)
</br>

<details>
    <summary><big>📂 계층 별 확대 펼치기 / 접기 </big></summary>

![](https://hackmd.io/_uploads/Sk71d7QPn.png)

![](https://hackmd.io/_uploads/r13JdXQvh.png)

![](https://hackmd.io/_uploads/BJWe_7Xwn.png)

![](https://hackmd.io/_uploads/rkNeuQmDh.png)

</details>


# 📜 구현 기능
## 영상 목록 화면
|**10개 단위의 pagination** | **스와이프로 삭제** |
|:---: | :---: |
| <img src="https://hackmd.io/_uploads/BkwsOkXDn.gif" width=200> | <img src="https://hackmd.io/_uploads/rk2rFkQvh.gif" width=200> |

- 10개 단위로 pagination됩니다. 더이상 읽어올 데이터가 없을 경우 읽어오기를 시도하지 않습니다.
- 스와이프로 영상을 삭제합니다. 영상을 삭제하면 로컬 데이터베이스와 원격 데이터베이스에서 모두 삭제됩니다.

## 영상 녹화 화면
| **카메라 회전** | **녹화된 영상 및 저장/취소** |
| :---: | :---: |
| <img src="https://hackmd.io/_uploads/SyGyHgQvh.gif" width=200> | <img src="https://hackmd.io/_uploads/Bkkj7xXv3.gif" width=200> |

- 회전 아이콘을 클릭하면 카메라가 회전합니다. 영상 녹화 중에는 회전이 불가능합니다.
- 영상 녹화가 완료되면 파일명을 입력받습니다. 취소 버튼을 클릭하면 다시 녹화가 가능합니다.

## 영상 재생 화면
| **재생↔일시정지 토글** | **공유 기능** | **재생 시간 슬라이더로 조정** |
| :---: | :---: | :---: |
| <img src="https://hackmd.io/_uploads/SkZ2W-mv3.gif" width=200> | <img src="https://hackmd.io/_uploads/Hkd4GbXvn.gif" width=200> | <img src="https://hackmd.io/_uploads/SkgXXbQwn.gif" width=200> |

- 재생 중 일시정지 버튼을 클릭하면 영상이 일시정지됩니다. 일시정지 중 재생 버튼을 클릭하면 영상이 계속 재생됩니다.
- 공유 버튼을 클릭하면 영상 정보의 공유가 가능합니다.
- 현재 재생 시간을 슬라이더로 조정할 수 있습니다.

| **재생 시간 처음으로 이동** | **영상 컨트롤러 보이기/숨기기** | **영상 정보 표시** |
| :---: | :---: | :---: |
| <img src="https://hackmd.io/_uploads/SkerKQWXDn.gif" width=200> | <img src="https://hackmd.io/_uploads/HJsGwZXv3.gif" width=200> | <img src="https://hackmd.io/_uploads/HyZ3DZXw2.gif" width=200> |

- 처음으로 돌아가는 버튼을 누르면 영상의 처음으로 이동합니다.
- 영상을 터치하면 영상 컨트롤러 보이기/숨기기 상태가 토글됩니다.
- 상단의 Info 버튼을 클릭하면 간단한 영상의 정보가 Alert으로 표시됩니다.

## 영상 데이터 백업
| **영상 저장** | **영상 저장 시 원격 DB에 업로드** |
| :---: | :---: |
| <img src="https://hackmd.io/_uploads/S1A4MlXD3.gif" width=170> | <img src="https://hackmd.io/_uploads/rJwsGlXD2.gif" width=500> |

- 영상을 저장하면 로컬 데이터베이스와 원격 데이터베이스에 모두 저장됩니다.
- 원격 데이터베이스는 제목으로 고유한 데이터를 식별하기 위해, 영상의 제목과 ID를 조합하여 파일명으로 업로드됩니다.

</br>

# 😢 아쉬운 점
## 1️⃣ 원격 데이터베이스의 활용 부족
### 미구현 기능
- 원격 데이터베이스로부터 읽어오는 기능이 구현되어있지 않습니다.
- 원격 데이터베이스와 로컬 데이터베이스의 동기화가 보장되지 않습니다.

### 배경
새로운 영상이 저장될 때 로컬 데이터베이스의 원격 데이터베이스에 모두 저장됩니다.

하지만 원격 데이터베이스는 네트워크 환경에서만 사용이 가능한 문제가 있습니다.
네트워크가 연결되지 않은 환경에서 새로운 데이터를 저장한다면 로컬 데이터베이스에만 저장이 될 것이고, 앱을 재실행한 후 네트워크 데이터베이스를 기준으로 데이터를 읽어온다면 네트워크가 연결되지 않은 환경에서 새롭게 생성된 데이터가 사라지게 됩니다.

이 문제를 해결하기 위해 다음과 같은 방안을 고려하였습니다.

1. 네트워크가 연결된 환경에서만 영상 데이터를 저장하여 항상 동기화 상태를 보장한다.
2. 원격 데이터베이스는 백업의 용도로만 활용하고, 앱은 로컬 데이터베이스를 기반으로 동작하게 한다.

1번 방안에 대해서는 기존에 녹화된 영상을 시청하는데도 네트워크 환경이 꼭 필요하다면, 앱의 유용성이 낮다고 생각했습니다.

따라서 **2번 방안을 채택**하였으며 현재 앱은 다음과 같이 동작이 구현되어 있습니다.

- 새로운 영상 생성 → 로컬/원격 데이터베이스에 모두 저장합니다.
- 앱 실행 → 로컬 데이터베이스에 저장된 데이터를 읽어옵니다.

추후 로그인과 같은 인증 기능을 구현한다면, 원격 데이터베이스를 활용한 기기 간 데이터 동기화와 같은 기능을 추가할 수 있을 것이라고 생각합니다.

## 2️⃣ 공유 기능의 활용 부족
현재 공유 기능은 `UIActivityViewController`를 `present`하도록 구현되어 있으나, 실질적인 데이터의 공유는 이루어지지 않고 있습니다.

원격 데이터베이스의 URL을 공유해서 공유된 영상을 시청할 수 있게끔 하는 등의 추후 보완이 필요한 기능입니다.

</br>

# 📚 참고 링크
- [영상 기능 구현을 위한 프레임워크 선택에 참고한 자료 - AVFoundation vs UIImagePickerController](https://velog.io/@heyksw/iOS-AVFoundation-으로-custom-camera-구현)

## 애플 공식 문서
- [Combine](https://developer.apple.com/documentation/combine)
- [AVFoundation](https://developer.apple.com/av-foundation/)
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [Capture setup](https://developer.apple.com/documentation/avfoundation/capture_setup)
- [Choosing a Capture Device](https://developer.apple.com/documentation/avfoundation/capture_setup/choosing_a_capture_device)
