//
//  ViewController.swift
//  URLSession
//
//  Created by HWAKSEONG KIM on 2022/11/09.
//

import UIKit

class ViewController: UIViewController {

    let service = DownloadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let urlStr = "https://github.com/haha1haka/URLSession/blob/main/Asset/스크린샷%2020221007%2023.32.36.png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://raw.githubusercontent.com/haha1haka/URLSession/main/Asset/Simulator Screen Recording-iPhone14-2022-10-06at 01.37.45.mp4") else {
            print("이건가")
            return
        }
        print(url)
        service.downloadTask(url: url)
    }
    


}
class DayflyCell: UICollectionViewCell {
    
}
