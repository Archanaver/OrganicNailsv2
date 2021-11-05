//
//  ProductoControlador.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import Foundation

import Firebase

class ProductoControlador{
    
    let db = Firestore.firestore()
    
    func fetchProductos(completion: @escaping (Result<Productos, Error>)->Void){
        var lista_productos = [Producto]()
        db.collection("productos").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                print("error getting docuemnts: \(err)")
                completion(.failure(err))
            }else{
                for document in querySnapshot!.documents{
                    let i = Producto(d: document)
                    lista_productos.append(i)
                }
                completion(.success(lista_productos))
            }
            
        }
    }
}

