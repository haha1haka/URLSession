//
//  ViewController.swift
//  URLSession
//
//  Created by HWAKSEONG KIM on 2022/11/09.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let defaultSession = DownloadManager()
    
    let imageUrl = URL(string: "https://raw.githubusercontent.com/haha1haka/URLSession/main/Asset/subak.png")!
    let url = URL(string: "https://raw.githubusercontent.com/haha1haka/URLSession/main/Asset/testsimulation.mp4")!
    
    @IBAction func downloadButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.defaultSession.downloadTask(url: self.url)
            self.playDownload()
        }
    }
    
}
extension ViewController {
    func playDownload() {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        let url =  DocumentManager.localFilePath(for: self.url)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
}
