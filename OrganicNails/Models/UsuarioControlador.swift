//
//  UsuarioControlador.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/5/21.
//

import Foundation
import Firebase

class UsuarioControlador{
    
    let db = Firestore.firestore()
    
    func getDireccionUsuario(uid:String, completion: @escaping (Result<String,Error>)->Void){
        db.collection("clientes").whereField("uid", isEqualTo: uid)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error obteniendo id usuario: \(err)")
                completion(.failure(err))
            } else {
                var documentoID:String = ""
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                    
                }
                let docRef = self.db.collection("clientes").document(documentoID)
           
                docRef.getDocument(source: .cache) { (document, error) in
                    if let document = document {
                        let property = document.get("direccion")
                        completion(.success(property as! String))
                    }
                }
                
                
            }
        }
        
        
    }
}
