//
//  ViewController.swift
//  URLSession
//
//  Created by HWAKSEONG KIM on 2022/11/09.
//

import UIKit
import AVKit



class ViewController: UIViewController {
    
    @IBOutlet weak var textlabel: UITextView!
    
    let defaultSession = DownloadManager()
    
    let url = URL(string: "https://raw.githubusercontent.com/haha1haka/URLSession/main/Asset/pizzTime.mp4")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSession.delegate = self
        textlabel.font = .systemFont(ofSize: 50, weight: .bold)
    }
    
    @IBAction func downloadButton(_ sender: UIBarButtonItem) {
            self.defaultSession.downloadTask(url: self.url)
    }
    
    @IBAction func showVideo(_ sender: UIButton) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        let url =  DocumentManager.localFilePath(for: self.url)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
}


extension ViewController: DataPassDelegate {
    func pass(_ object: DownloadManager, currentProgress: Float, totalSize: String) {
        print("current Progress : \(currentProgress) / totalSize : \(totalSize)")
        DispatchQueue.main.async {
            self.textlabel.text = String(format: "%.1f%% of %@", currentProgress * 100, totalSize)
        }
    }
}
