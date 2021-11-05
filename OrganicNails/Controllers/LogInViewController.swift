//
//  LogInViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate    {

    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var contraTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var contraOlvidadaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.correoTextField.delegate = self
        self.contraTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        correoTextField.resignFirstResponder()
       
        contraTextField.resignFirstResponder()
       
        
        return(true)
    }
  
    func validateFields() -> String?{
      //Todas estan llenas
      if correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  contraTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
          return "Llena todas los espacios"
      }
      // contra segura
      
      return nil
    }
      

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func iniciandoSesion(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            
            print("hay un error al crear una cuenta")
            
           
        }else {
            let email = correoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let contra = contraTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: contra) { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    
                }
                else{
                    print("successful")
                }
            }
        }
    }
    
}
    

