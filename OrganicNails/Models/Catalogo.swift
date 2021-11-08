//
//  Menu.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/1/21.
//

import Foundation

struct Catalogo{
    var producto: String?
    var categoria: [String]?
    
    init(producto:String, categoria:[String]){
        self.producto = producto
        self.categoria = categoria

    }
    
}
extension Catalogo{
    static func listaCatalogo()->[Catalogo]{
        return[
        Catalogo(producto: "Catálogo general", categoria: ["Ver todo","Acrílicos", "Kits", "Glitters", "Líquidos", "Consumibles", "Herramientas", "Tratamientos", "Accesorios", "Arte","TechGel", "Color Gel","Gel"])
        ]
    }
    
  
}

typealias Catalogos = [Catalogo]
//Catalogo(producto: "Cursos", categoria: ["Ver todo"]
