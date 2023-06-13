//
//  SignUpViewModel.swift
//  HYN
//
//  Created by Hadia Yehia on 11/06/2023.
//

import Foundation
import Firebase
import FirebaseDatabase

class SignUpViewModel{
    var myCustomer : Customer = Customer(first_name: "", last_name: "", email: "", phone: "", verified_email: false, password: "", password_confirmation: "", send_email_welcome: false)
    var customerResponse : CustomerResponse = CustomerResponse(customer: CustomerResponsed())
    var userId : Int?
    var favId : Int?
    var cartId : Int?
    var email = "unregistered_email"
    var ref: DatabaseReference = Database.database().reference().child("usersInfo")
    func rigesterNewCustomer(customer : Customer)->String{
        var res = ""
        Auth.auth().createUser(withEmail: customer.email, password: customer.password){ authResult , error in
            if let e = error{
                print(e)
                res = e.localizedDescription
            }else {
                
                NetworkService.getInstance().postingNewCustomer(customer: CustomerRequest(customer: customer), completionHandler: {result in
                    
                    switch result{
                    case .success(let data):
                        self.customerResponse = data
                        self.userId = data.customer.id
                        if let email = data.customer.email{
                            self.email = email}
                       // self.ref.child(Auth.auth().currentUser!.uid).setValue(["userId": self.userId])
                        res = "success"
                        NetworkService.getInstance().postingNewDraftOrder(completionHandler: {result in
                            switch result{
                            case .success(let data):
                                self.favId = data.draftOrder?.id
                                res = "success"
                                //self.ref.child(Auth.auth().currentUser!.uid).setValue(["favId": self.favId])
                                NetworkService.getInstance().postingNewDraftOrder(completionHandler: {result in
                                    switch result{
                                    case .success(let data):
                                        self.cartId = data.draftOrder?.id
                                        res = "success"
                                        
                                        self.ref.child(Auth.auth().currentUser!.uid).setValue(["userId": self.userId,"favId": self.favId,"cartId": self.cartId])
                            
                                        break
                                    case .failure(let error):
                                        res = "error in cart creation : \(error.localizedDescription)"
                                        break
                                    }
                                    
                                })
                                break
                            case .failure(let error):
                                res = "error in fav creation : \(error.localizedDescription)"
                                break
                            }})
                        break
                    case .failure(let error):
                        res = error.localizedDescription
                        break
                    }
                })}}
        return res
    }
//    func rigesterNewCustomer(customer : Customer)->String{
//        myCustomer = customer
//        var res = ""
//        NetworkService.getInstance().postingNewDraftOrder(completionHandler: {result in
//            switch result{
//            case .success(let data):
//                self.favId = data.draftOrder?.id
//               // customer.tags = data.draftOrder?.id
//                self.myCustomer.tags = "\(self.favId)*"
//                print("7war el tags\(self.favId)")
//                res = "success"
//                NetworkService.getInstance().postingNewDraftOrder(completionHandler: {result in
//                    switch result{
//                    case .success(let data):
//                        self.cartId = data.draftOrder?.id
//                        res = "success"
//                        self.myCustomer.tags.append("\(self.cartId)")
//                        print("7war el tags\(self.cartId)")
////                        Auth.auth().createUser(withEmail: customer.email, password: customer.password){ authResult , error in
////                            if let e = error{
////                                print(e)
////                                res = e.localizedDescription
////                            }else {
////
////                                NetworkService.getInstance().postingNewCustomer(customer: CustomerRequest(customer: self.myCustomer), completionHandler: {result in
////                                    print("7war eltags m3 elcustomer\(self.myCustomer.tags)")
////                                    switch result{
////                                    case .success(let data):
////                                        print("7war eltags m3 elcustomer elly rage3\(data.customer.tags)")
////                                        self.userId = data.customer.id
////                                        if let email = data.customer.email{
////                                            self.email = email}
////                                        self.ref.child(Auth.auth().currentUser!.uid).setValue(["userId": self.userId])
////                                        res = "success"
////                                        break
////                                    case .failure(let error):
////                                        res = error.localizedDescription
////                                        break
////                                    }
////                                })
////                            }
//                       // }
//                        break
//                    case .failure(let error):
//                        res = "error in cart creation : \(error.localizedDescription)"
//                        break
//                    }
//
//                })
//                break
//            case .failure(let error):
//                res = "error in fav creation : \(error.localizedDescription)"
//                break
//            }
//
//        })
//        return res
//    }
}
