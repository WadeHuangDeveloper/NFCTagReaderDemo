//
//  NFCTagDetailViewController.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import UIKit
import CoreNFC

class NFCTagDetailViewController: UIViewController {
    
    private let NFCTagDetailMessageTableViewCellIdentifier = "NFCTagDetailMessageTableViewCell"
    private let NFCTagDetailRecordTableViewCellIdentifier = "NFCTagDetailRecordTableViewCell"
    private let NFCNDEFRecordDetailViewControllerIdentifier = "NFCNDEFRecordDetailViewController"
    private let messageTitles = ["Tag type", "Serial number", "Available capacity", "Status"]
    private var nfcTag: NFCTag?
    private var message: NFCNDEFMessage?
    private var status: NFCNDEFStatus?
    private var serialNumber: String?

    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    private func initializeUI() {
        detailTableView.dataSource = self
        detailTableView.delegate = self
    }
    
    func setNFCTag(_ tag: NFCTag) {
        self.nfcTag = tag
    }
    
    func setNDEFMessage(_ message: NFCNDEFMessage) {
        self.message = message
    }
    
    func setStatus(_ status: NFCNDEFStatus) {
        self.status = status
    }
    
    func setSerialNumber(_ serialNumber: String) {
        self.serialNumber = serialNumber
    }
}

extension NFCTagDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? messageTitles.count : message?.records.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            // message details
            if let cell = tableView.dequeueReusableCell(withIdentifier: NFCTagDetailMessageTableViewCellIdentifier) as? NFCTagDetailMessageTableViewCell, 
                let message = message, 
                let nfcTag = nfcTag,
                let serialNumber = serialNumber,
                let status = status {
                
                cell.titleLabel.text = messageTitles[row]
                
                var description = ""
                switch row {
                case 0: description = nfcTag.description
                case 1: description = serialNumber
                case 2: description = "\(message.length) \(message.length > 1 ? "bytes" : "byte")"
                case 3: description = status.description
                default: break
                }
                cell.descriptionLabel.text = description
                cell.isSelected = false
                
                return cell
            }
            
        } else {
            // record details
            if let cell = tableView.dequeueReusableCell(withIdentifier: NFCTagDetailRecordTableViewCellIdentifier) as? NFCTagDetailRecordTableViewCell,
               let message = message {
                let type = "\(message.records[row].type.toString() == "T" ? "Text" : "URI")"
                cell.titleLabel.text = "Record \(row + 1) - \(type)"
                cell.lengthLabel.text = "\(message.records[row].payload.count) \(message.records[row].payload.count > 1 ? "bytes" : "byte")"
                cell.accessoryType = .disclosureIndicator
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 1 {
            if let record = message?.records[row],
               let viewController = storyboard?.instantiateViewController(withIdentifier: NFCNDEFRecordDetailViewControllerIdentifier) as? NFCNDEFRecordDetailViewController {
                viewController.setNFCNDEFPayload(record)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
