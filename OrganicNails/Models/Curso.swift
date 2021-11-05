//
//  Producto.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import Foundation
import Firebase

struct Curso: Decodable{
    var nombre:String
    var fecha:String
    var instructor:String
    var precio:Float
    var descripcion:String
    var servicio:String
    var id:String
    
    enum CodingKeys: String, CodingKey {
            case nombre
            case fecha
            case instructor
            case precio
            case descripcion
            case servicio
            case id
        }
    init(nombre:String, fecha:String, instructor:String, precio:Float, descripcion:String, servicio:String, id:String){
        self.nombre = nombre
        self.fecha = fecha
        self.instructor = instructor
        self.precio = precio
        self.descripcion = descripcion
        self.servicio = servicio
        self.id = id
    }
    
    init(d:DocumentSnapshot){
        self.id = d.documentID
        self.nombre = d.get("nombre") as? String ?? ""
        self.descripcion = d.get("descripcion") as? String ?? ""
        self.id = d.get("id") as? String ?? ""
        self.precio = d.get("precio") as? Float ?? 0
        self.fecha = d.get("fecha") as? String ?? ""
        self.instructor = d.get("instructor") as? String ?? ""
        self.servicio = d.get("servicio") as? String ?? ""
        
    }

}

typealias Cursos = [Curso]
