//
//  NFCNDEFRecordDetailTableViewCell.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/25.
//

import UIKit
import CoreNFC

class NFCNDEFRecordDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
