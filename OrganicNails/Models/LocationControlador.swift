//
//  LocationControlador.swift
//  OrganicNails
//
//  Created by user189475 on 11/25/21.
//
import CoreLocation
import Foundation
import Firebase

class LocationControlador:  NSObject, CLLocationManagerDelegate {
    static let shared = LocationControlador()
    let manager = CLLocationManager()
    var completion: ((CLLocation)-> Void)?
    
    let db = Firestore.firestore()
    
    public func getUserLocation(completion: @escaping ((CLLocation)->Void)){
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    public func resolveLocationName(with location: CLLocation, completion: @escaping ((String?)-> Void)){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) {
            placemarks, error in
            guard let place = placemarks?.first,error == nil else{
                completion(nil)
                return
            }
            let pm = placemarks! as [CLPlacemark]

                           if pm.count > 0 {
                               let pm = placemarks![0]
                               print(pm.country)
                               print(pm.locality)
                               print(pm.subLocality)
                               print(pm.thoroughfare)
                               print(pm.postalCode)
                               print(pm.subThoroughfare)
                               var addressString : String = ""
                            if pm.thoroughfare != nil {
                                addressString = addressString + pm.thoroughfare! + " "
                            }
                            if pm.subThoroughfare != nil {
                            addressString = addressString + pm.subThoroughfare! + ", "
                            }
                               if pm.subLocality != nil {
                                   addressString = addressString + pm.subLocality! + ", "
                               }
                               
                               if pm.locality != nil {
                                   addressString = addressString + pm.locality! + ", "
                               }
                               if pm.country != nil {
                                   addressString = addressString + pm.country! + ", "
                                
                               }
                               if pm.postalCode != nil {
                                   addressString = addressString + pm.postalCode! + " "
                               }

                            print(addressString)
                            completion(addressString)
                           }
                                       }
    }
    func updateDireccion(clienteActualizar : Cliente, completion: @escaping (Result <String, Error>)->Void){
        db.collection("clientes").document(clienteActualizar.id!).updateData(["direccion":clienteActualizar.direccion, "codigoPostal":clienteActualizar.cp]) {
            err in
            if let err = err {
                completion(.failure(err))
            }else {
                completion(.success("Direccion actualizada"))
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.first else{
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
}
