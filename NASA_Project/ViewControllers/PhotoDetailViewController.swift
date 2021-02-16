//
//  PhotoDetailViewController.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    
    var data: NasaPhoto?
    var tableData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let strongData = data else { return }
        configure(strongData)
        setupTable()
    }
    
    func configure(_ data: NasaPhoto) {
        DispatchQueue.main.async {
            let src = URL(string: data.img_src)
            self.photoImageView.kf.setImage(with: src)
        }
        setTableData(data)
    }
    
    func setTableData(_ data: NasaPhoto) {
        self.tableData.append("ID: \(data.id)")
        self.tableData.append("Captured Date: \(data.earth_date)")
        self.tableData.append("ROVER DETAILS")
        self.tableData.append("Rover ID: \(data.rover.id)")
        self.tableData.append("Rover Name: \(data.rover.name)")
        self.tableData.append("Rover Launch Date: \(data.rover.launch_date)")
        self.tableData.append("Rover Landing Date: \(data.rover.landing_date)")
        self.tableData.append("Rover Status: \(data.rover.status)")
        self.tableData.append("CAMERA DETAILS")
        self.tableData.append("ID: \(data.camera.id)")
        self.tableData.append("Name: \(data.camera.name)")
        self.tableData.append("Full Name: \(data.camera.full_name)")
    }
    
    func setupTable() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.allowsMultipleSelection = false
        detailTableView.allowsSelection = false
        detailTableView.reloadData()
    }
}

extension PhotoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let txt = tableData[indexPath.row]
        
        cell.textLabel?.text = txt
        cell.textLabel?.adjustsFontSizeToFitWidth = true

        if !txt.contains(":") {
            cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        } else {
            cell.textLabel?.font = .systemFont(ofSize: 16)
        }
        return cell
    }
    
    
}
