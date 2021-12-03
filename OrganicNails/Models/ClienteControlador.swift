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
    
    func getClientes(completion: @escaping (Result <Clientes, Error>)->Void){
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
    
    func getClienteData(uid:String, completion: @escaping (Result<String,Error>)->Void){
    
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
                        let property = document.get("nombre")
                        completion(.success((property as! String)))
                    }
                }
                
                
            }
        }
        
        
    }
    
    func updateClienteFactura(clienteActualizar : Cliente, completion: @escaping (Result <String, Error>)->Void){
        db.collection("clientes").document(clienteActualizar.id!).updateData(["rfc":clienteActualizar.rfc, "codigoPostal":clienteActualizar.cp]) {
            err in
            if let err = err {
                completion(.failure(err))
            }else {
                completion(.success("Informacion de facturacion modificada "))
            }
        }
        
    }
    
    
 
    
    func fetchCliente(uid:String,completion: @escaping (Result<Clientes, Error>)->Void){
            var clientes = [Cliente]()
            db.collection("clientes").whereField("uid", isEqualTo: uid).getDocuments(){ (querySnapshot, err) in
                if let err = err{
                    print("error getting documents: \(err)")
                    completion(.failure(err))
                }else{
                    for document in querySnapshot!.documents{
                        let i = Cliente(d: document)
                        clientes.append(i)
                    }
                    completion(.success(clientes))
                }
                
            }
            
        }
    
    
   /* func updateCliente(cliente:Cliente, completion:@escaping (Result<String, Error>)->Void){
        db.collection("clientes").whereField("uid", isEqualTo: cliente.id)
            .getDocuments(){ (querySnapshot, err) in
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
        
    }*/
    
    func updateCliente(uid:String,cliente:Cliente, completion: @escaping (Result<String,Error>)->Void){
        db.collection("clientes").whereField("uid", isEqualTo: uid)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error obteniendo cliente: \(err)")
                completion(.failure(err))
            } else {
                var documentoID:String = ""
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                    self.db.collection("clientes").document(documentoID).updateData([
                        "cp": cliente.cp,
                        //"direccion": cliente.direccion,
                        "nombre": cliente.nombre,
                        "rfc": cliente.rfc,
                        "telefono": cliente.telefono,
                        //"uid": cliente.id
                        
                        
                    ]){ err in
                        if let err = err{
                            completion(.failure(err))
                        }else{
                            completion(.success("Se han modificado y guardado sus datos"))
                        }
                    }
                }
            
                
            }
        }
        
        
    }
    func deleteCliente(uid:String,completion: @escaping (Result<String,Error>)->Void){
        db.collection("clientes").whereField("uid", isEqualTo: uid)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error obteniendo cliente: \(err)")
                completion(.failure(err))
            }else {
                var documentoID:String = ""
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                    let user = Auth.auth().currentUser
                   
                    
                    self.db.collection("clientes").document(documentoID).delete(){err in
                        if let err = err {
                            print("Error al remover cliente:\(err)")
                            completion(.failure(err))
                        }else{
                            let user = Auth.auth().currentUser
                            user?.delete{ error in
                                if let error = error {
                                    print("Error al remover cliente:\(error)")
                                    completion(.failure(error))
                                } else {
                                    print("Cuenta eliminada")
                                    completion(.success("Su cuenta ha sido eliminada"))
                                }
                              }
                            
                        }
                    }
                    user?.delete {
                        error in
                        if let error = error {
                            print("error al eliminar cuenta")
                        }else{print("cuenta eliminada")}
                    }
                }
                
            }
          }
    }
    
    // obtiene la direccion y el id del documento del cliente
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
    

   /* func getDireccionUsuario(uid:String, completion: @escaping (Result<String,Error>)->Void){
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
        
        
    }*/
    
}


