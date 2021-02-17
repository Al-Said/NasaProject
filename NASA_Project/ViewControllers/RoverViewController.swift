//
//  RoverViewController.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import UIKit

class RoverViewController: BaseViewController {

    @IBOutlet weak var largeActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dataTableView: UITableView!
    
    var selectedCamera: Camera? = nil
    var pageNumber = 1
    var paginating = false
    var roverName: Rovers = .CURIOSITY
    
    var data: [NasaPhoto] = [] {
        didSet {
            DispatchQueue.main.async {
                self.dataTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = roverName.rawValue.uppercased()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterCamera))
        setupTableView()


    }
    
    func setupTableView() {
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
        self.dataTableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
        self.dataTableView.separatorStyle = .none
    }

    @objc func filterCamera() {

    }
    
    func setData() {
        let model = PhotoRequestModel(roverName: roverName, page: pageNumber, sol: 1000, camera: selectedCamera)
        RoverPhotoManager.shared.getRoverPhotos(model) { (response) in
            self.stopActivityIndicator()
            self.data = response.photos
        } failure: { (code, message) in
            self.stopActivityIndicator()
            self.showInfoPopup(title: "Error", message: "Error code: \(code)... \(message)", buttonText: "OK")
        }
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.largeActivityIndicator.isHidden = false
            self.largeActivityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.largeActivityIndicator.stopAnimating()
            self.largeActivityIndicator.isHidden = true
        }
    }
    
    func createSpinnerFooter() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footer.center
        footer.addSubview(spinner)
        spinner.startAnimating()
        return footer
    }
}

extension RoverViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as? PhotoTableViewCell {
            cell.configureCell(data[indexPath.row].img_src)
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "\(data[indexPath.row].id)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailViewController") as? PhotoDetailViewController {
            viewController.data = data[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            self.showInfoPopup(title: "Error", message: "An error has occured", buttonText: "OK")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
    
        if position > (self.dataTableView.contentSize.height - scrollView.frame.size.height + 80) {
            //Need more data...
            if !paginating {
                DispatchQueue.main.async {
                    self.dataTableView.tableFooterView = self.createSpinnerFooter()
                }
                paginating = true
                self.pageNumber += 1
                let model = PhotoRequestModel(roverName: roverName, page: pageNumber, sol: 1000, camera: selectedCamera)
                RoverPhotoManager.shared.getRoverPhotos(model) { [unowned self] (response) in
                    self.data.append(contentsOf: response.photos)
                    self.dataTableView.tableFooterView = nil
                    self.paginating = false
                } failure: { [unowned self] (code, message) in
                    self.showInfoPopup(title: "Error", message: "Error code: \(code)... \(message)", buttonText: "OK")
                    self.dataTableView.tableFooterView = nil
                    self.pageNumber -= 1
                    self.paginating = false
                }
            }
        }
    }
}

extension RoverViewController: FilterCameraDelegate {
    func cameraSelected(_ selected: Camera?) {
        self.pageNumber = 1
        self.selectedCamera = selected
        self.data = []
        self.startActivityIndicator()
        setData()
    }
}
