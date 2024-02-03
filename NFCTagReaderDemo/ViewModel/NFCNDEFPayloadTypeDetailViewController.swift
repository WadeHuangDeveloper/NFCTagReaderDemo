//
//  NFCNDEFPayloadTypeDetailViewController.swift
//  NFCTagReaderDemo
//
//  Created by WadeGigatms on 2024/1/26.
//

import UIKit
import CoreNFC

class NFCNDEFPayloadTypeDetailViewController: UIViewController {
    
    private var payloadType: NFCNDEFPayloadType?
    private var text: String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    private func initializeUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        titleLabel.text = payloadType?.fullDescription
        inputTextField.text = text ?? "eninfineon"
        inputTextField.delegate = self
    }
    
    @objc
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc
    private func done() {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        
        for viewController in viewControllers {
            if let writerViewController = viewController as? NFCWriterViewController {
                if let record = createRecord() {
                    writerViewController.insertRecord(record)
                }
                
                self.navigationController?.popToViewController(writerViewController, animated: true)
                return
            }
        }
    }
    
    func createRecord() -> NFCNDEFPayload? {
        guard let input = inputTextField.text else { return nil }
        
        let type = NFCNDEFPayloadType.T.description.data(using: .utf8)!
        let identifier = Data()
        let payload = input.data(using: .utf8)!
        let record = NFCNDEFPayload(format: .nfcWellKnown,
                                    type: type,
                                    identifier: identifier,
                                    payload: payload,
                                    chunkSize: 1)
        return record
    }
    
    func setPayloadTypeDetail(_ type: NFCNDEFPayloadType, text: String? = nil) {
        self.payloadType = type
        self.text = text
    }
}

extension NFCNDEFPayloadTypeDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
