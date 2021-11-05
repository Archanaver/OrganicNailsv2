//
//  ClienteControlador.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import Foundation
import Firebase

class ClienteControlador{
    
    let db = Firestore.firestore()
    
    func fetchRazas(completion: @escaping (Result <Clientes, Error>)->Void){
        var lista_clientes = [Cliente]()
        
        db.collection("clientes").getDocuments { (querySnapchot, err) in
            if let err = err {
                print("Error getting docs")
                completion(.failure(err))
            } else {
                for document in querySnapchot!.documents {
                    var c = Cliente(d: document)
                    lista_clientes.append(c)
                }
                completion(.success(lista_clientes))
            }
        }
    }
}


