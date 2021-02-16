//
//  FilterViewController.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import UIKit

protocol FilterCameraDelegate {
    func cameraSelected(_ selected: Camera?)
}
class FilterViewController: UIViewController {

    @IBOutlet weak var pickerHolderView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate: FilterCameraDelegate? = nil
    var rover: Rovers = .CURIOSITY
    var data: [Camera] = []
    var oldCamera: Camera? = nil
    var selectedCamera: Camera? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerRadius()
        setData()
        setPickerView()
    }
    
    func setCornerRadius() {
        pickerHolderView.layer.cornerRadius = 10.0
        pickerHolderView.layer.shadowColor = UIColor.black.cgColor
        pickerHolderView.layer.shadowRadius = 5.0
        pickerHolderView.layer.shadowOpacity = 0.7
        pickerHolderView.layer.masksToBounds = true
        pickerHolderView.clipsToBounds = true
    }
    
    func setData() {
        switch rover {
        case .CURIOSITY:
            data = RoverCameras.curiosity
        case .OPPORTUNITY:
            data = RoverCameras.opportunity
        case .SPIRIT:
            data = RoverCameras.spirit
        }
    }
    
    func setPickerView() {
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        if let old = oldCamera {
            guard let rowNum = self.data.firstIndex(of: old) else { return }
            guard rowNum < self.data.count else { return }
            self.pickerView.selectRow(rowNum + 1, inComponent: 0, animated: false)
        }
    }

    @IBAction func cameraSelected(_ sender: Any) {
        self.delegate?.cameraSelected(selectedCamera)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "ALL"
        } else {
            return data[row - 1].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.selectedCamera = nil
        } else {
            self.selectedCamera = data[row - 1]
        }
    }
}
