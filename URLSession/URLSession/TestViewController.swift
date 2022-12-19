//
//  TestViewController.swift
//  URLSession
//
//  Created by HWAKSEONG KIM on 2022/11/10.
//

import UIKit

class TestViewController: UIViewController {
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    var receivedData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoad()
    }
    
    func startLoad() {
        let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(1011)")!
        receivedData = Data()
        let task = session.dataTask(with: url)
        task.resume()
    }

    
}


extension TestViewController: URLSessionDataDelegate {
    
    // data
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.receivedData?.append(data)
        print("🐙🐙🐙🐙\(receivedData)")
    }
    
    //
    // response
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            completionHandler(.cancel)
            return
        }
        // load operation 을 계속해라
        completionHandler(.allow)
    }
    

    //error
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            if let error = error  {
                print(error.localizedDescription)
            } else if let receivedData = self.receivedData {
                do {
                    let data = try JSONDecoder().decode(Lotto.self, from: receivedData)
                    print("😄\(data)")
                } catch {
                    print("👻\(error.localizedDescription)")
                }
            }
        }

    }
}
