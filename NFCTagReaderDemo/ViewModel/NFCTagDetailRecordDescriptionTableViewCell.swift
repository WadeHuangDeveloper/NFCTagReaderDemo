//
//  NFCTagDetailRecordDescriptionTableViewCell.swift
//  NFCTagReaderDemo
//
//  Created by WadeGigatms on 2024/1/26.
//

import UIKit
import CoreNFC

class NFCTagDetailRecordDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRecord(_ record: NFCNDEFPayload, at index: Int) {
        titleLabel.text = "Record \(index + 1) - \(record.type.toString() == "T" ? "Text" : "URI")"
        lengthLabel.text = "\(record.payload.count) \(record.payload.count > 1 ? "bytes" : "byte")"
        descriptionLabel.text = "\(record.payload.toString())"
    }
}
