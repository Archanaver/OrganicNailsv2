//
//  DireccionEnvioViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/23/21.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth

class DireccionEnvioViewController: UIViewController,UISearchBarDelegate {
    var total:Float = 0
    var ahorro:Float = 0
    var envio:Float = 0

    let clienteControlador = ClienteControlador()
    
    @IBOutlet weak var dir: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        LocationControlador.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func updateDireccion(_ sender: Any) {
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
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let siguiente = segue.destination as! DetallePedidoViewController
        siguiente.ahorro = ahorro
        siguiente.total = total
    }
    
 
*/
}
