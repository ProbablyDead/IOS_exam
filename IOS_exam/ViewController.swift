//
//  ViewController.swift
//  IOS_exam
//
//  Created by Илья Володин on 19.12.2023.
//

import UIKit
import PinLayout

class ViewController: UIViewController {
    private let network = Network()
    private var coinsArray: [Coin] = [] {
        didSet {
            DispatchQueue.main.async{
                self.button.backgroundColor = .blue
                let menuChildren: [UIMenuElement] = self.coinsArray.map { UIAction(title: $0.name, handler: self.getData) }
                
                self.button.menu = UIMenu(options: .displayInline, children: menuChildren)
                self.button.isEnabled = true
                self.button.showsMenuAsPrimaryAction = true
                self.button.changesSelectionAsPrimaryAction = true
            }
        }
    }
    
    private func getData(action: UIAction) {
        if let coin = coinsArray.first(where: { $0.name == action.title }) {
            DispatchQueue(label: "Load coin data").async {
                DispatchQueue.main.async {
                    let timeInterval = NSInteger(self.datePicker.date.timeIntervalSince1970)
                    self.network.getCoinPrice(time: String(timeInterval), uuid: coin.uuid) {data in
                        DispatchQueue.main.async {
                            if data == "fail"{
                                self.textLabel.text = coin.price
                                return
                            }
                            self.textLabel.text = data
                        }
                    }
                }
            }
        }
    }
    
    private let button: UIButton = {
        let controller = UIButton()
        controller.backgroundColor = .lightGray
        controller.setTitle("Coin", for: .normal)
        controller.isEnabled = false
        return controller
    }()

    private let textLabel: UILabel = {
        let controller = UILabel()
        controller.lineBreakMode = .byWordWrapping
        controller.numberOfLines = 0
        controller.backgroundColor = .systemGray
        controller.contentMode = .center
        return controller
    }()
    
    private let datePicker: UIDatePicker = {
        let controller = UIDatePicker()
        controller.datePickerMode = .dateAndTime
        
        let date = Date()
        controller.date = date
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        DispatchQueue(label: "Load data").async {
            DispatchQueue.main.async {
                self.network.getList(completion: { [weak self] coins in self?.coinsArray = coins })
            }
        }
        
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
       
        view.addSubview(textLabel)
        view.addSubview(datePicker)
        view.addSubview(button)
        
        datePicker.pin
            .topCenter(100)
        
        button.pin
            .left(50)
            .bottom(40%)
            .right(50)
            .height(30)
        
        textLabel.pin
            .below(of: button).marginVertical(20)
            .left(20)
            .right(20)
            .bottom()
    }
}
