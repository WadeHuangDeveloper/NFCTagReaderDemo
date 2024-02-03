//
//  NFCNDEFRecordDetailViewController.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/25.
//

import UIKit
import CoreNFC

class NFCNDEFRecordDetailViewController: UIViewController {

    private let NFCNDEFRecordDetailTableViewCellIdentifier = "NFCNDEFRecordDetailTableViewCell"
    private let recordTitles = ["Type", "TNF", "Language", "Value", "Raw data", "Payload length", "Payload"]
    private var record: NFCNDEFPayload?
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    private func initializeUI() {
        detailTableView.dataSource = self
        
        
    }
    
    func setNFCNDEFPayload(_ payload: NFCNDEFPayload) {
        self.record = payload
    }
}

extension NFCNDEFRecordDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let record = record,
           let cell = tableView.dequeueReusableCell(withIdentifier: NFCNDEFRecordDetailTableViewCellIdentifier) as? NFCNDEFRecordDetailTableViewCell {
            let index = indexPath.row
            cell.titleLabel.text = recordTitles[index]
            
            var description = ""
            switch index {
            case 0:
                // payload type
                description = record.type.toString() == NFCNDEFPayloadType.T.description ? NFCNDEFPayloadType.T.description : NFCNDEFPayloadType.U.description
            case 1:
                // TNF
                description = record.typeNameFormat.description
            case 2:
                // locate
                description = record.wellKnownTypeTextPayload().1?.identifier ?? ""
            case 3:
                // payload
                description = record.wellKnownTypeTextPayload().0 ?? ""
            case 4:
                // payload raw data
                description = record.payload.toString()
            case 5:
                description = "\(record.payload.count) \(record.payload.count > 1 ? " bytes" : " byte")"
            case 6:
                description = record.payload.toFormattedHexString()
                cell.descriptionLabel.font = UIFont(name: "Courier New", size: 12)
            default:
                break
            }
            cell.descriptionLabel.text = description
            cell.descriptionLabel.numberOfLines = 0
            cell.descriptionLabel.sizeToFit()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
