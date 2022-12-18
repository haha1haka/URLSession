## URLSession Weekly Conference



<br/><br/>

매주 동료들에게 지식을 공유하는 conference 가 있습니다.

URLSession 이라는 주제로 발표를 진행 하였습니다.

<br/><br/>

내용을 요약 해서만 기술 합니다.

<br/>





<img width="654" alt="스크린샷 2022-12-10 02 48 22" src="https://user-images.githubusercontent.com/106936018/206761984-ca6de768-4f2b-4f82-874e-89c57ba6d6b6.png">



<br/><br/>

<img width="933" alt="스크린샷 2022-12-10 02 48 55" src="https://user-images.githubusercontent.com/106936018/206762104-3ca0ff56-d868-46ff-86b5-6ba5411fae26.png">





<br/><br/>

세션은 서버와 통신 할 수 있는 작은 통로라고 설명 하였습니다.

일관성 있게, 다른 종류의 세션들도 그냥 성격이 다른 Session 임을 설명하기 위해 

해당 그림 처럼 설명 



<br/><br/>

<img width="949" alt="스크린샷 2022-12-10 02 49 02" src="https://user-images.githubusercontent.com/106936018/206762150-cb70b8a3-f4a5-4ad3-846b-4a04d8417991.png">

<br/><br/>

구체적으로 3가지 세션 종류를 살펴 보기 전에

<br/><br/>



우리는 어떤 세션을 써왔을까?

<br/><br/>



⭐️그냥 애플이 구현 해 놓은 shared 싱글톤 객체를 사용 했을뿐 어떤 종류의 세션에 해당 하지 않습니다.

따라서 위의 세션 3개와 혼동을 방지하세요!

<br/>

shared 한계 설명



<br/>

<img width="942" alt="스크린샷 2022-12-10 02 49 09" src="https://user-images.githubusercontent.com/106936018/206762195-d537ff9a-b674-4145-858b-1ad2f1d65be3.png">





<br/><br/>



본격 세션 3가지 설명

<br/><br/>

<img width="947" alt="스크린샷 2022-12-10 02 49 18" src="https://user-images.githubusercontent.com/106936018/206762245-2a571569-cb43-4640-a1c2-6db76605cbd3.png">



<br/><br/><br/><br/>

<img width="914" alt="스크린샷 2022-12-10 02 49 25" src="https://user-images.githubusercontent.com/106936018/206762286-8f774e94-9740-4411-9b29-1b458edbbf16.png">





<br/><br/><br/><br/>

<img width="928" alt="스크린샷 2022-12-10 02 49 30" src="https://user-images.githubusercontent.com/106936018/206762313-e9f86fae-fee6-4ce1-9295-d3e8a5eba866.png">





<br/><br/>

다음으로는 어떤 task 들이 있는지 알아 보았습니다. (대표로 downloadTask 만)



<br/><br/>



<img width="922" alt="스크린샷 2022-12-10 02 49 57" src="https://user-images.githubusercontent.com/106936018/206762503-c6ea59ce-1bdd-4f9c-83b8-bf30963e1ff9.png">



<br/><br/>



downloadTask 에 익숙치 않기 때문에 

미리 깃헙에 저장한 사진과 영상을 download 해보는 실습 진행



<br/><br/>



<img width="910" alt="스크린샷 2022-12-10 02 50 01" src="https://user-images.githubusercontent.com/106936018/206762533-a09af2d4-eb4a-4816-8bb7-fdcb546221c6.png">





<br/><br/>

영상 두개 올리기



![111왼쪽](https://user-images.githubusercontent.com/106936018/208288119-05059dfa-49cb-4b73-8a4d-ff0a4ed351e3.gif)



![222오른쪽](https://user-images.githubusercontent.com/106936018/208288123-cfe858af-1cc6-4c46-8711-cacff88c0df2.gif)

<br/><br/>



URLSessionDownloadDelegate 매서드 살펴보기

1. 다운로드 한 사진 or 영상을 filManager 를 통해 저장 해야 한다는점
2. URLSessionDownloadDelegate

<br/><br/>





### URLSessionDownloadDelegate



<br/>



이 URLSessionDownloadTask 매서드를 통해 넘어오는 Location 으로 디렉토리 생성 후 저장

```swift
    //delegate에서 임시 파일 위치에 대한 url 을 제공
    //FileManager 를 통해 앱의 샌드박스 컨테이너 디렉토리로 옮기기
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished Downloading to \(location)")
        
        //original request 추출: https://raw.githubusercontent.com/haha1haka/URLSession/main/Asset/testsimulation.mp4
        guard let sourcURL = downloadTask.originalRequest?.url else {return}
        
        
        //destinationURL 만들기
        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("♥️\(documentURL)") // documentURL: ..../Document
        
        // sourceURL.lastComponent: testsimulation.mp4
        let destinationURL = documentURL.appendingPathComponent(sourcURL.lastPathComponent)
        print("Destination URL : " ,destinationURL)
        
        //덮어쓰기 위해
        try? fileManager.removeItem(at: destinationURL)
        
        do{ //Data
            try fileManager.copyItem(at: location, to: destinationURL)
        }
        catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }


```



<br/><br/>





다운로드 진행 상황을 구현 하는 코드

<br/>

totalByteWritten: 총 바이트 수 

totalBytesExpectedToWrite: 예상되는 총 바이트 수

totalSize: 총 파일 크기

<br/><br/>

```swift
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //totalBytesWritten: 총 바이트수 ,totalBytesExpectedToWrite: 예상되는 바이트수 --> 두 값의 비율로 진행률을 계산!
        let currentProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        //ByteCountFormatter: 총 다운로드 파일 크기를 보여줌
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        self.delegate?.pass(self, currentProgress: currentProgress, totalSize: totalSize)

    }
```





<br/><br/>



마지막으로

URLSession 을 쉽게 설명하기위해 저만의 언어로 설명한 지점들이 있어서

동료들에게 apple 제공하는 그림들을 보면서 다시한번 복습(추후 공부 했을시 헷갈리지 마시라고ㅎ)



<br/><br/>

데이터 받아오는 2가지 방법 api 그림



<br/><br/>

<img width="918" alt="스크린샷 2022-12-10 02 50 14" src="https://user-images.githubusercontent.com/106936018/206762617-045c3553-2b71-4b65-a0dc-44a6bc406703.png">

<br/><br/>



emperal 세션을 설명 할때 많이 나오는 그림 

<br/><br/>

<img width="929" alt="스크린샷 2022-12-10 02 50 19" src="https://user-images.githubusercontent.com/106936018/206762654-ffaf77bc-83a2-401d-a346-13012a708962.png">





<br/><br/>



상속을 받고 있는 구조여서 블로그를 보면 이런 사진들이 많이 나오는데 

그냥 각각 task 들이 어떤 목적을 가지고 있는지 알고 적절하게 쓰면 됨

<br/><br/>



<img width="946" alt="스크린샷 2022-12-10 02 50 24" src="https://user-images.githubusercontent.com/106936018/206762685-65e774b7-d8ea-4f3e-9ce2-61d7ff0343d2.png">



<br/><br/>



최종 apple 에서 말하는 URL Loding System 설명 으로 마무리



<br/><br/>

<img width="943" alt="스크린샷 2022-12-10 02 50 37" src="https://user-images.githubusercontent.com/106936018/206762718-be2cf99f-dd6a-4bd8-af5a-36393c5e4c6b.png">

