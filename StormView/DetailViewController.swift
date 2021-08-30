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
        
        assert(selectedImage != nil, "There is no image provided to load")

        setTitle()
        addShareButton()
        
        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage {
            stormImageView.image = UIImage(named: imageToLoad)
        }
    }
    
    func getWatermarkedImage(with name: String) -> UIImage? {
        if let image = UIImage(named: name) {
            let renderer = UIGraphicsImageRenderer(size: image.size)
            
            let imageToDraw = renderer.image { context in
                image.draw(at: CGPoint(x: 0, y: 0))
                
                let string = "From Storm View"
                let watermark = getWatermarkString(for: string)
                let watermarkRect = CGRect(x: 0, y: image.size.height / 2, width: image.size.width, height: 100)
                watermark.draw(with: watermarkRect, options: .usesLineFragmentOrigin, context: nil)
            }
            
            return imageToDraw
        }
        return nil
    }
    
    func getWatermarkString(for string: String) -> NSAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 36, weight: .bold),
            .backgroundColor: UIColor.black.cgColor,
            .foregroundColor: UIColor.white.cgColor,
            .paragraphStyle: paraStyle
        ]
        
        return NSAttributedString(string: string, attributes: attrs)
    }
    
    func setTitle() {
        title = titleBarText
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func addShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        guard let imageName = selectedImage else {
            print("Invalid image name")
            return
        }
        guard let imageToShare = getWatermarkedImage(with: imageName)?.jpegData(compressionQuality: 0.8) else {
            print("Failed watermarking image")
            return
        }
        let vc = UIActivityViewController(activityItems: [imageName, imageToShare], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
