//
//  Cliente.swift
//  OrganicNails
//
//  Created by user189475 on 10/25/21.
//

import Foundation
import Firebase

struct Cliente: Decodable{
    var id : String?
    var nombre : String?
    var direccion: String?
    var cp : String?
    var telefono : String?
    var rfc : String?
    
    enum CodingKeys: String, CodingKey {
        case id,nombre,direccion,cp,telefono,rfc
    }
    
    init(id: String, nombre:String, direccion : String, cp: String, telefono : String, rfc : String ){
        self.nombre = nombre
        self.direccion = direccion
        self.cp = cp
        self.telefono = telefono
        self.rfc = rfc
        self.id = id
    }
    init(d:DocumentSnapshot){
        self.id = d.documentID
        self.id = d.get("uid") as? String ?? ""
        self.nombre = d.get("nombre") as? String ?? ""
        self.direccion = d.get("direccion") as? String ?? ""
        self.cp = d.get("codigoPostal") as? String ?? ""
        self.telefono = d.get("telefono") as? String ?? ""
        self.rfc = d.get("rfc") as? String ?? ""
        
    }
}

typealias Clientes = [Cliente]

typealias Client = Cliente
