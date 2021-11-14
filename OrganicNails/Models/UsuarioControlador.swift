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
                    //print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                    
                }
                let docRef = self.db.collection("clientes").document(documentoID)
           
                docRef.getDocument(source: .cache) { (document, error) in
                    if let document = document {
                        let property = document.get("direccion")
                        completion(.success((property as! String)+"|"+documentoID))
                    }
                }
                
                
            }
        }
        
        
    }
    
    func getUserDataForCreatingPedido(uid:String, completion: @escaping (Result<[String: String],Error>)->Void){
        var emptyDict: [String: String] = [:]
        db.collection("clientes").whereField("uid", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print("Error obteniendo datos del usuario con uid:",uid)
                        completion(.failure(err))
            
                    }else{
                        emptyDict["id_doc"] = querySnapshot!.documents[0].documentID
                        let userInfo = Result{
                            try querySnapshot!.documents[0].data(as: Cliente.self)
                            
                        }
                        switch userInfo {
                        case .success(let userData):
                            if let userData = userData {
                                //print("User: \(userData)")
                                emptyDict["direccion"] = userData.direccion
                                //print("diccionario ", emptyDict)
                                completion(.success(emptyDict))
                            } else {
                                print("User's document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding user: \(error)")
                        }
                    }
        }
    }
    
    
}
