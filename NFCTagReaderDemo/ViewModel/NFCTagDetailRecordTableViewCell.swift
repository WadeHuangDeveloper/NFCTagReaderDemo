//
//  RecordDetailTableViewCell.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import UIKit
import CoreNFC

class NFCTagDetailRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
