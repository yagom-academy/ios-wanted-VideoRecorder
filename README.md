# ios-wanted-VideoRecorder


</br>

## 팀원  소개

|Julia(김지인)|Beeem(김수빈)|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/37897873/194696643-2c42d5b0-4bd8-4780-bf16-e902756afa04.png" width="200" height="200"/>|<img src="https://user-images.githubusercontent.com/31722496/192567901-5f1ede08-e89e-4adf-b987-2af47ec2d1a3.png" width="200" height="200"/>|
|[Github](https://github.com/julia0926)|[Github](https://github.com/skyqnaqna)|
|동영상 재생|동영상 녹화|
|FireStorage|CoreData|
|FileManager|썸네일|

</br>

## 개발 기간

- 2022-10-10 ~ 2022-10-15

</br>

## 구조 및 기능

</br>

https://user-images.githubusercontent.com/31722496/195970612-9e4a7d18-fb95-4ce4-a4db-407bf97c98ab.mov

</br>

### 첫 번째 페이지

<table>
	<tr>
		<td>
<img src="https://user-images.githubusercontent.com/31722496/195969095-3e9f5906-630d-45a4-825c-ac30773b8a6e.jpeg" width=300px>
		</td>
		<td>
- UITableView로 동영상 목록 구성 </br>
- 최대 6개씩 불러오는 pagination </br>
- 영상 썸네일 이미지 적용 </br>
- 행 스와이프해서 삭제 기능 </br>
- 길게 누르면 영상 미리보기 기능
		</td>
	</tr>
</table>


</br>

### 두 번째 페이지

<table>
	<tr>
		<td>
<img src="https://user-images.githubusercontent.com/31722496/195969121-5f4e38af-333b-4ccb-a083-29d3405a84af.jpeg" width=300px>
		</td>
		<td>
- 동영상 녹화 기능 </br>
- 전면, 후면 카메라 전환 가능 </br>
- 녹화 시간 타이머 기능 </br>
- 로컬에 저장 후 FireStorage에 백업 </br>
- TableView에 나타낼 정보는 CoreData로 관리 </br>
- 가장 최근 영상 썸네일 이미지 적용
		</td>
	</tr>
</table>

</br>

### 세 번째 페이지

<table>
	<tr>
		<td>
<img src="https://user-images.githubusercontent.com/31722496/195969144-9da1a65b-2788-4b65-803e-25f22444c46c.jpeg" width=300px>
		</td>
		<td>
- 동영상 재생 및 슬라이더 기능 </br>
- 버튼 재생, 정지 토글 기능</br>
- 슬라이더로 동영상 재생 위치 변경</br>
- 이전 버튼 탭시 10초 이전</br>
- 비디오 배경 탭시 컨트롤러 숨기고 보임</br>
- 녹화된 재생 시간 보임
		</td>
	</tr>
</table>


</br>


## 해결하지 못한 문제

<img src="https://user-images.githubusercontent.com/31722496/195970447-deec1109-9334-4544-a95c-bea585f07c46.png" width=100%>

- Firestorage에 업로드 할 때 발생하는 경고 문구
- `Thread running at QOS_CLASS_USER_INTERACTIVE waiting on a lower QoS thread running at QOS_CLASS_BACKGROUND. Investigate ways to avoid priority inversions`
- [google-gtm-session-fetcher](https://github.com/google/gtm-session-fetcher)에 문제가 있는 것으로 추측
- Xcode 14의 스레드 성능 이슈 관련 Firebase realtimebase에서 유사한 문제가 해결된 것을 발견했지만, Firestorage에서는 아직 해결되지 않은 상태로 추정됩니다.
	- https://github.com/firebase/firebase-ios-sdk/issues/10130
	- https://github.com/google/gtm-session-fetcher/pull/324
