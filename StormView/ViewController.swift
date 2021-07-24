//
//  ViewController.swift
//  StormView
//
//  Created by Atin Agnihotri on 05/07/21.
//

import UIKit

class ViewController: UICollectionViewController {

    var pictures = [String]()
    var clicks = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        performSelector(inBackground: #selector(loadImagesFromBundle), with: nil)
        addRecommendButton()
    }
    
    func setNavigationTitle() {
        title = "Storm View"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addRecommendButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAppTapped))
    }
    
    @objc func shareAppTapped() {
        let vc = UIActivityViewController(activityItems: ["If you like this app, please share it across"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func loadImagesFromBundle() {
        let clicksDict = UserDefaults.standard.dictionary(forKey: "clicks")
        var cleanDict = [String: Int]()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                cleanDict[item] = 0
            }
        }
        if !cleanDict.isEmpty {
            clicks = clicksDict as? [String: Int] ?? cleanDict
        }
        pictures.sort()
        printClicks()
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Storm", for: indexPath) as? StormCell else {
            fatalError("Cannot dequeue resuable cells")
        }
        let imageToLoad = pictures[indexPath.item]
        cell.nameLabel.text = imageToLoad
        cell.imageView.image =  UIImage(named: imageToLoad)
        return cell
    }
    
    
    func giveTitleTextForDetailVC(_ index: Int) -> String {
        "Picture \(index + 1) of \(pictures.count)"
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let index = indexPath.row
            vc.selectedImage = pictures[index]
            updateClicks(for: index)
            vc.titleBarText = giveTitleTextForDetailVC(index)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateClicks(for index: Int) {
        let picture = pictures[index]
        if let noOfClicks = clicks[picture] {
            clicks[picture] = noOfClicks + 1
            UserDefaults.standard.set(clicks, forKey: "clicks")
        }
    }
    
    func printClicks() {
        for key in clicks.keys {
            print("\(key) : \(clicks[key] ?? 0)")
        }
    }

}

