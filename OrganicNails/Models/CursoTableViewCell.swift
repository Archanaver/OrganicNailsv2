//
//  CursoTableViewCell.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/16/21.
//

import UIKit

class CursoTableViewCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var total: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
