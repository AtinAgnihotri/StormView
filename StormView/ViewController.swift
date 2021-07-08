//
//  ViewController.swift
//  StormView
//
//  Created by Atin Agnihotri on 05/07/21.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        loadImagesFromBundle()
        addRecommendButton()
        print(pictures)
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
    
    func loadImagesFromBundle() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    func giveTitleTextForDetailVC(_ index: Int) -> String {
        "Picture \(index + 1) of \(pictures.count)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let index = indexPath.row
            vc.selectedImage = pictures[index]
            vc.titleBarText = giveTitleTextForDetailVC(index)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

