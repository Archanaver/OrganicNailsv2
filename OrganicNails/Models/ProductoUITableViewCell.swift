//
//  ProductoUITableViewCell.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/15/21.
//

import UIKit

class ProductoUITableViewCell: UITableViewCell {

    @IBOutlet weak var tituloCell: UILabel!
    @IBOutlet weak var colorCell: UILabel!
    @IBOutlet weak var cantidadCell: UILabel!
    @IBOutlet weak var precioCell: UILabel!
    @IBOutlet weak var descuentoCell: UILabel!
    @IBOutlet weak var totalCell: UILabel!
    @IBOutlet weak var eliminarCell: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
