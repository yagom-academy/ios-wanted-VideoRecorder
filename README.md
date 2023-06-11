# 📹 Video Recorder

> 동영상을 촬영, 저장하고 실행할 수 있는 앱
> 
> 프로젝트 기간: 2023.06.05-2023.06.11
> 
> <img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white">
> <img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=UIKit&logoColor=white">

## 팀원

| 혜모리 |
|:---:| 
|<Img src ="https://github.com/hyemory/ios-wanted-VideoRecorder/blob/develop/images/hyemory.png?raw=true" width="200" height="200"/>|
|[Github Profile](https://github.com/hyemory)|

---
## 목차
1. [타임라인](#타임라인)
2. [프로젝트 구조](#프로젝트-구조)
3. [실행 화면](#실행-화면)
4. [트러블 슈팅](#트러블-슈팅) 
5. [참고 링크](#참고-링크)

---
# 타임라인 

| 날짜 | 내용 |
| --- | --- |
| 2023.06.05 | 프로젝트 파악 및 일정 산정 |
| 2023.06.06 | 비디오 목록 테이블 뷰 구현 |
| 2023.06.07 | 비디오 목록 뷰 컨트롤러 구현 및 모델 추가 |
| 2023.06.08 | 카메라 뷰 구현 및 AVFoundation 학습 |
| 2023.06.09 | 카메라 기능 구현 |
| 2023.06.10 | 로컬 저장소에 저장하기 위해 Core Data 구현 |
| 2023.06.11 | 데이터 저장, 삭제 기능 및 재생 뷰 구현 |

<br/>

---
# 프로젝트 구조
## Class Diagram

![](https://github.com/hyemory/ios-wanted-VideoRecorder/blob/develop/images/Class%20Diagram.png?raw=true)

## File Tree
<details>
<summary> 파일 트리 보기 (클릭) </summary>
<div markdown="1">

```typescript!
├── Resource
│   ├── Assets.xcassets
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   └── Info.plist
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── CoreData
│   ├── CoreDataManager.swift
│   ├── Video.xcdatamodeld
│   │   └── Model.xcdatamodel
│   │       └── contents
│   ├── VideoEntity+CoreDataClass.swift
│   └── VideoEntity+CoreDataProperties.swift
├── Extension
│   ├── Date+.swift
│   └── TimeInterval+.swift
├── Protocol
│   └── IdentifierType.swift
├── Utility
│   └── SystemImageName.swift
├── Model
│   └── VideoInfo.swift
├── VideoList
│   ├── Controller
│   │   └── VideoListViewController.swift
│   └── View
│       ├── PaddingLabel.swift
│       ├── VideoListCell.swift
│       └── VideoListTitleView.swift
├── AddVideo
│   ├── Controller
│   │   └── AddVideoViewController.swift
│   └── View
│       └── ShutterButton.swift
└── WatchVideo
    └── Controller
        └── WatchVideoViewController.swift
```
    
</div>
</details>

---
# 실행 화면

| <center>동영상 촬영, 저장</center> | <center>동영상 보기</center> | <center>동영상 목록, 삭제</center> |
| --- | --- | --- |
| ![](https://github.com/hyemory/ios-wanted-VideoRecorder/blob/develop/images/add.gif?raw=true) | ![](https://github.com/hyemory/ios-wanted-VideoRecorder/blob/develop/images/play.gif?raw=true) | ![](https://github.com/hyemory/ios-wanted-VideoRecorder/blob/develop/images/remove.gif?raw=true) |


---
# 트러블 슈팅

## 1️⃣ UILabel 주변에 Padding 주는 방법

### 🔍 문제점

목록에 재생시간 (duration)을 표시하는 레이블 뷰 주변에 Padding을 주고싶어
방법을 고민해 보았습니다.

1. 재생시간 레이블을 서브뷰로 추가하는 빈 UIView를 만들어 여백 주기
2. 커스텀 레이블 뷰 만들기 ✅

### ⚒️ 해결방안

[intrinsicContentSize](https://developer.apple.com/documentation/uikit/uiview/1622600-intrinsiccontentsize)를 사용하여 레이블 뷰의 크기를 조정할 수 있었습니다.

> UIView 클래스의 프로퍼티로, 해당 뷰의 content 크기를 나타낸다

``` swift
import UIKit

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    // 텍스트를 그리기 전에 호출되는 메서드로, 주어진 사각형(rect) 내에 텍스트를 그려준다.
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // 외부에서 패딩 값을 설정하며 초기화 할 수 있음
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
}
```

## 2️⃣ reloadData

### 🔍 문제점

셀을 등록, 삭제할 때 컬렉션 뷰를 업데이트 해야하는데 `reloadData` 메서드를 사용하면 기존의 모든 데이터를 버리고 전체 데이터를 다시 불러와서 뷰를 업데이트합니다. 
이는 데이터가 크고 복잡한 경우에는 비효율적입니다. 몇 개의 변경된 항목만 있는 경우에도 전체 데이터를 다시 불러와야 하기 때문입니다.

### ⚒️ 해결방안

뷰를 업데이트하기위한 방법으로 테이블 뷰의 Data Source를 UITableViewDiffableDataSource로 리팩토링하고, Snapshot을 사용하였습니다. 
데이터 변경사항이 발생하면 applySnapshot을 호출하여 테이블 뷰를 업데이트 해주도록 구현했습니다.

``` swift
// MARK : - VideoListViewController.swift

// DataSource 구성 메서드
private func configureDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, VideoInfo>(tableView: videoListTableView) {
        [weak self] (tableView, indexPath, video) -> UITableViewCell? in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier) as? VideoListCell else {
            return UITableViewCell()
        }

        let contents = self?.videoInfoList?[indexPath.row]

        guard let playbackTime = contents?.duration,
              let fileName = contents?.fileName,
              let date = contents?.registrationDate.translateDayFormat(),
              let thumbnailData = contents?.thumbnailImage else {
            return UITableViewCell()
        }

        cell.configure(playbackTime: playbackTime,
                       fileName: fileName,
                       date: date,
                       thumbNail: thumbnailData)
        return cell
    }
}

// SnapShot 메서드
private func applySnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, VideoInfo>()

    guard let videoInfoList else { return }

    snapshot.appendSections([.main])
    snapshot.appendItems(videoInfoList, toSection: .main)
    dataSource?.apply(snapshot)
}
```

## 3️⃣ temp 동영상 파일을 document directory로 이동할 때 파일명 문제

### 🔍 문제점

``` swift
private func saveVideoToDocumentDirectory(id: UUID, url: URL, thumbnail: UIImage) {
    let fileManager = FileManager.default
    let documentDirectory = fileManager.urls(for: .documentDirectory,
                                             in: .userDomainMask).first

    guard let destinationURL = documentDirectory?.appendingPathComponent("\(id.uuidString).mp4") else {
        print("Failed to create destination URL")
        return
    }

    do {
        try fileManager.moveItem(at: url, to: destinationURL)
        createVideo(id: id, url: destinationURL, thumbnail: thumbnail)
    } catch {
        print("Failed to save documents directory")
    }
}
```

1. document directory에 고정된 파일 이름으로 저장하면 </br> `print("Failed to create destination URL")`이 호출되는 현상이 있었습니다.
2. 저장한 동영상을 재생하는 뷰를 구현했는데, 동영상의 레이어가 화면에 표시되지 않았습니다.

### ⚒️ 해결방안

1. temp 동영상 파일을 document directory로 이동할 때 파일명이 중복되어선 안된다는 문제를 파악하고 </br> 데이터의 UUID를 사용하여 파일명을 설정하였습니다.
2. `.appendingPathComponent`에 확장자 없이 UUID로만 설정 했었던게 문제가 되었습니다. </br> 아이폰 동영상 파일 확장자인 "name.mp4" 형식으로 이름을 설정하니 정상적으로 동영상이 표시되었습니다.

---
# 참고 링크

## 공식 문서
- [intrinsicContentSize](https://developer.apple.com/documentation/uikit/uiview/1622600-intrinsiccontentsize)
- [UIImage.SymbolConfiguration](https://developer.apple.com/documentation/uikit/uiimage/symbolconfiguration)
- [draw(_:)](https://developer.apple.com/documentation/uikit/uiview/1622529-draw)
- [FileManager - urls(for:in:)](https://developer.apple.com/documentation/foundation/filemanager/1407726-urls)
- [FileManager - NSTemporaryDirectory()](https://developer.apple.com/documentation/foundation/1409211-nstemporarydirectory)
- [FileManager - fileExists(atPath:isDirectory:)](https://developer.apple.com/documentation/foundation/filemanager/1410277-fileexists)
- [appendingPathComponent(_:)](https://developer.apple.com/documentation/foundation/nsurl/1410614-appendingpathcomponent)
- [AVCaptureSession](https://developer.apple.com/documentation/avfoundation/avcapturesession)
- [AVCaptureDevice](https://developer.apple.com/documentation/avfoundation/avcapturedevice)
- [AVCaptureMovieFileOutput](https://developer.apple.com/documentation/avfoundation/avcapturemoviefileoutput)
- [AVCaptureVideoPreviewLayer](https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer)
- [AVCaptureFileOutputRecordingDelegate - fileOutput(_:didFinishRecordingTo:from:error:)](https://developer.apple.com/documentation/avfoundation/avcapturefileoutputrecordingdelegate/1390612-fileoutput)
- [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer/)
- [AVPlayerLayer](https://developer.apple.com/documentation/avfoundation/avplayerlayer)
- [AVPlayer - Status](https://developer.apple.com/documentation/avfoundation/avplayer/1388096-status)

## 유튜브
- [Swift: Custom Camera Like Snapchat](https://www.youtube.com/watch?v=ZYPNXLABf3c)

## 블로그
- [How to Play, Record and Merge Videos in iOS and Swift](https://www.kodeco.com/10857372-how-to-play-record-and-merge-videos-in-ios-and-swift#toc-anchor-002)
