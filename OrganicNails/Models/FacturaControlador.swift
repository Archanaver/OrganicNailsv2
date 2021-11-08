//
//  FacturaControlador.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/8/21.
//

import Foundation
import Firebase
class FacturaControlador{
    
    let db = Firestore.firestore()
    
    func crearFactura(nuevaFactura:Factura, completion: @escaping (Result<String,Error>)->Void ){
        var ref: DocumentReference? = nil
        //let newDocumentID = UUID().uuidString
        ref = db.collection("facturas").addDocument(data:[
            "nombre": nuevaFactura.nombre,
            "rfc": nuevaFactura.rfc,
            "calle": nuevaFactura.calle,
            "colonia": nuevaFactura.colonia,
            "cp": nuevaFactura.cp,
            "delegacion": nuevaFactura.delegacion,
            "estado": nuevaFactura.estado,
            "pais": nuevaFactura.pais,
            "id_cliente": nuevaFactura.id_cliente
 
        ]){ err in
            if let err = err{
                print("Error al añadir factura: \(err)")
                completion(.failure(err))
            }else{
                completion(.success("Factura añadida \(ref!.documentID)"))
            }
        }
}
    
    func fetchFactura(uid:String,completion: @escaping (Result<Facturas, Error>)->Void){
            var facturas = [Factura]()
            db.collection("facturas").whereField("id_cliente", isEqualTo: uid).getDocuments(){ (querySnapshot, err) in
                if let err = err{
                    print("error getting facturas: \(err)")
                    completion(.failure(err))
                }else{
                    for document in querySnapshot!.documents{
                        let i = Factura(d: document)
                        facturas.append(i)
                    }
                    
                    completion(.success(facturas))
                }
                
            }
            
        }
    
    
    func updateFactura(uid:String,factura:Factura, completion: @escaping (Result<String,Error>)->Void){
        db.collection("facturas").whereField("id_cliente", isEqualTo: uid)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error obteniendo factura: \(err)")
                completion(.failure(err))
            } else {
                var documentoID:String = ""
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                    self.db.collection("facturas").document(documentoID).updateData([
                        "nombre": factura.nombre,
                        "rfc": factura.rfc,
                        "calle": factura.calle,
                        "colonia": factura.colonia,
                        "cp": factura.cp,
                        "delegacion": factura.delegacion,
                        "estado": factura.estado,
                        "pais": factura.pais,
                        //"id_cliente": nuevaFactura.id_cliente
                        
                        
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
    func deleteFactura(uid:String,completion: @escaping (Result<String,Error>)->Void){
        db.collection("facturas").whereField("id_cliente", isEqualTo: uid)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error obteniendo factura: \(err)")
                completion(.failure(err))
            }else {
                var documentoID:String = ""
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                    self.db.collection("facturas").document(documentoID).delete(){err in
                        if let err = err {
                            print("Error al remover factura:\(err)")
                            completion(.failure(err))
                        }else{
                      
                                    completion(.success("Su datos de facturación han sido eliminados"))
                                
                              }
                            
                        
                    }
                }
                
            }
          }
    }
    
    
    func checarFacturaExistente(uid:String,completion: @escaping (Result<String,Error>)->Void){
        db.collection("facturas").whereField("id_cliente", isEqualTo: uid)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error obteniendo factura: \(err)")
                completion(.failure(err))
            } else {
                var documentoID:String = ""
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                }
                completion(.success(documentoID))
                
            }
        }
        
        
    }

}
