//
//  DireccionPedidoViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/28/21.
//
import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import Firebase

class DireccionPedidoViewController:  UIViewController,UISearchBarDelegate  {
    var total:Float = 0
    var ahorro:Float = 0
    var envio:Float = 0
    var add: String = ""
    let db = Firestore.firestore()
    @IBOutlet weak var map: MKMapView!
    let clienteControlador = ClienteControlador()
    let fascinoLoc: CLLocation = CLLocation(latitude: 19.3686049, longitude: -99.1808505)
    
    @IBOutlet weak var dir: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        let userID = Auth.auth().currentUser!.uid
        clienteControlador.fetchCliente(uid: userID){
            (resultado) in
            switch resultado{
            case .success(let exito):
                self.add = exito[0].direccion!
            case .failure(let error):print(error)
            }
        
        let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(self.add){ [self](placemarks, error) in
           
            let placemarks = placemarks?.first
            let location = placemarks?.location?.coordinate
                    let lat = placemarks?.location?.coordinate.latitude
                let long = placemarks?.location?.coordinate.longitude
            let newLoc: CLLocation = CLLocation(latitude: lat!, longitude: long!)
            self.addMapPin(with: newLoc)
                let meters = newLoc.distance(from: fascinoLoc)
                print("distancia en m ", meters)
                if meters > 5000.0 && meters < 10000{
                    print("mayor a ")
                    self.envio = 50.0
                }else if meters > 10000{
                    self.envio = 100.0
                }else{
                    self.envio = 10.0
                }
            
                print(self.envio)
        }
       
        
            print(self.total)
            print(self.ahorro)
            print(self.envio)
        // Do any additional setup after loading the view.
        
        
    }
    }
        func addMapPin(with location: CLLocation){
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            map .setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
            map.addAnnotation(pin)
            LocationControlador.shared.resolveLocationName(with: location) { [weak self] locationName in
                
                self!.dir.text = locationName
                
            }
        }
    
   
        
      
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            if response == nil {
                let alerta =  UIAlertController(title: "Error ", message: "Por favor incluye la calle y la colonia que buscas.", preferredStyle: .alert)
               alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
               self.present(alerta, animated: true, completion: nil)
            }
            else{
                //Remove annotation
                let annotations = self.map.annotations
                self.map.removeAnnotations(annotations)
                
                //Get data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.map.addAnnotation(annotation)
    
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.map.setRegion(region, animated: true)
                
                let loc = CLLocation(latitude: latitude!, longitude: longitude!)
                LocationControlador.shared.resolveLocationName(with: loc) { [weak self] locationName in
                    self!.dir.text = locationName
                    
                }
            }
        }
    }
    

    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated:true, completion: nil)
    }
    
    @IBAction func guardarDir(_ sender: Any) {
        let userID = Auth.auth().currentUser!.uid
    
        LocationControlador.shared.updateDir(uid: userID, dir: LocationControlador.shared.add, cp: LocationControlador.shared.cp){
            (resultado) in
            switch resultado{
            case .success(let exito): print("Direccion actualizada")
                
            case .failure(let error):print(error)
        }
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let siguiente = segue.destination as! DetallePedidoViewController
        siguiente.ahorro = ahorro
        siguiente.total = total
        siguiente.envio = envio
    }

}
