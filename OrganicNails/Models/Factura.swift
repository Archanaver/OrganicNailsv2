//
//  Factura.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/8/21.
//

import Foundation
import Firebase

struct Factura: Decodable{
    var nombre:String
    var rfc:String
    var calle:String
    var colonia:String
    var cp:String
    var delegacion:String
    var estado:String
    var pais:String
    var id_cliente:String
    
    func Nombre()->String {
        return nombre
    }
    
    func Rfc()->String {
        return rfc
    }
    func Calle()->String {
        return calle
    }
    
    func Colonia()->String {
        return colonia
    }
    
    func Cp()->String {
        return cp
    }
    func Delegacion()->String {
        return delegacion
    }
    func Estado()->String {
        return estado
    }
    
    func Pais()->String {
        return pais
    }
    
    func Id_cliente()->String {
        return id_cliente
    }
    
    enum CodingKeys: String, CodingKey {
        case nombre
        case rfc
        case calle
        case colonia
        case cp
        case delegacion
        case estado
        case pais
        case id_cliente
        
    }
    init(id_cliente:String, nombre:String, rfc:String, calle:String, colonia:String, cp:String, delegacion:String, estado:String, pais:String){
        self.id_cliente = id_cliente
        self.nombre = nombre
        self.rfc = rfc
        self.calle = calle
        self.colonia = colonia
        self.cp = cp
        self.delegacion = delegacion
        self.estado = estado
        self.pais = pais
    
        
    }
    
    init(id_cliente:String){
        self.id_cliente = id_cliente
        self.nombre = ""
        self.rfc = ""
        self.calle = ""
        self.colonia = ""
        self.cp = ""
        self.delegacion = ""
        self.estado = ""
        self.pais = ""
    
        
    }
    
    init(d:DocumentSnapshot){
        self.id_cliente = d.documentID
        self.nombre = d.get("nombre") as? String ?? ""
        self.rfc = d.get("rfc") as? String ?? ""
        self.calle = d.get("calle") as? String ?? ""
        self.colonia = d.get("colonia") as? String ?? ""
        self.cp = d.get("cp") as? String ?? ""
        self.delegacion = d.get("delegacion") as? String ?? ""
        self.estado = d.get("estado") as? String ?? ""
        self.pais = d.get("pais") as? String ?? ""
        self.id_cliente = d.get("id_cliente") as? String ?? ""
        
    }

}

typealias Facturas = [Factura]
