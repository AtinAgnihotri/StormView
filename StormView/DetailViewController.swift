//
//  DetailViewController.swift
//  StormView
//
//  Created by Atin Agnihotri on 06/07/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var stormImageView: UIImageView!
    var titleBarText: String?
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "View Picture: \(selectedImage ?? "Unknown Image")"
        title = titleBarText
        
        navigationItem.largeTitleDisplayMode = .never
        
        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage {
            stormImageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
