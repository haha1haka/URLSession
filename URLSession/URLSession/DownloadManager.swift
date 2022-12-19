//
//  DownloadManager.swift
//  URLSession
//
//  Created by HWAKSEONG KIM on 2022/11/09.
//

import Foundation


protocol DataPassDelegate {
    func pass(_ object: DownloadManager, currentProgress: Float, totalSize: String)
}

class DownloadManager: NSObject, URLSessionDelegate {
    var downloadSession : URLSession?
    
    override init() {
        super.init()
        self.downloadSession = setURLSession()
    }
    
    var delegate: DataPassDelegate?
    
    func setURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func downloadTask(url : URL) {
        let task = self.downloadSession?.downloadTask(with: url)
        task?.resume()
    }
}


extension DownloadManager : URLSessionDownloadDelegate {
    
    ///delegate에서 임시 파일 위치에 대한 url 을 제공
    ///FileManager 를 통해 앱의 샌드박스 컨테이너 디렉토리로 옮기기
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished Downloading to \(location)")
        
        ///original request 추출: https://raw.githubusercontent.com/haha1haka/URLSession/main/Asset/testsimulation.mp4
        guard let sourcURL = downloadTask.originalRequest?.url else {return}
        
        ///destinationURL 만들기
        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("♥️\(documentURL)") // documentURL: ..../Document
        
        /// sourceURL.lastComponent: testsimulation.mp4
        let destinationURL = documentURL.appendingPathComponent(sourcURL.lastPathComponent)
        print("Destination URL : " ,destinationURL)
        
        ///덮어쓰기
        try? fileManager.removeItem(at: destinationURL)
        
        do{ //Data
            try fileManager.copyItem(at: location, to: destinationURL)
        }
        catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
    
    
    /// progress 구하는 코드
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        ///totalBytesWritten: 총 바이트수 ,totalBytesExpectedToWrite: 예상되는 바이트수 --> 두 값의 비율로 진행률을 계산!
        let currentProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        ///ByteCountFormatter: 총 다운로드 파일 크기를 보여줌
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        self.delegate?.pass(self, currentProgress: currentProgress, totalSize: totalSize)

    }
    
    
    
}
