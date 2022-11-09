//
//  DownloadManager.swift
//  URLSession
//
//  Created by HWAKSEONG KIM on 2022/11/09.
//

import Foundation

class DownloadManager: NSObject, URLSessionDelegate {
    var downloadSession : URLSession?
    
    override init() {
        super.init()
        self.downloadSession = setURLSession()
    }
    
    func setURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func downloadTask(url : URL){
        let task = downloadSession?.downloadTask(with: url)
        task?.resume()
    }
}

extension DownloadManager : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished Downloading to \(location)")
        //location은 임시적인 위치입니다. 다운 받고 함수가 끝나면 해당 파일은 사라집니다.
        
        guard let sourcURL = downloadTask.originalRequest?.url else {return}
        
        print("Source URL : \(sourcURL)")
        
        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentURL.appendingPathComponent(sourcURL.lastPathComponent)
        print("Destination URL : " ,destinationURL)
        
        try? fileManager.removeItem(at: destinationURL)
        
        do{
            try fileManager.copyItem(at: location, to: destinationURL)
        }
        catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

            let currentProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

            print("current Progress : \(currentProgress) / totalSize : \(totalSize)")

        }

        
    
}
