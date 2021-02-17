//
//  CuriosityViewController.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import UIKit

class CuriosityViewController: RoverViewController {

    override func viewDidLoad() {
        roverName = .CURIOSITY
        selectedCamera = nil
        super.viewDidLoad()
        startActivityIndicator()
        setData()
    }

    @objc override func filterCamera() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else {
            return
        }
        viewController.rover = roverName
        viewController.oldCamera = selectedCamera
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
}
