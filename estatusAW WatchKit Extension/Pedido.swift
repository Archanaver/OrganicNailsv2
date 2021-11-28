//
//  Pedido.swift
//  estatusAW WatchKit Extension
//
//  Created by user189966 on 11/28/21.
//

import Foundation
import Firebase

struct Pedido{
    var estatus: String
    var fecha: String
    
    init(estatus:String, fecha:String){
        self.estatus = estatus
        self.fecha = fecha
    }

}
