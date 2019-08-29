//
//  ViewController.swift
//  callingData
//
//  Created by 진형진 on 23/08/2019.
//  Copyright © 2019 진형진. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController {
    //     url : "http://yourPortNumber/EMRService/EMRService_Template.svc"
    
    func getLines() {
        let webMethodName = "ServiceReturnCustomType"
        
        var bodyData : String = "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        bodyData = bodyData + "<SOAP-ENV:Body>"
        bodyData = bodyData + String(format: "<%@ xmlns=\"http://tempuri.org/\">", webMethodName)
//        bodyData = bodyData + String(format: "<value>%d</value>", 10)
        bodyData = bodyData + String(format: "<%@><![CDATA[%@]]></%@>", "sType", "GETQUERY", "sType")
        bodyData = bodyData + String(format: "<%@><![CDATA[%@]]></%@>", "sInputType", "JSON", "sInputType")
        bodyData = bodyData + String(format: "<%@><![CDATA[%@]]></%@>", "sOutputType", "JSON", "sOutputType")
        bodyData = bodyData + String(format: "<%@><![CDATA[%@]]></%@>", "sEncYn", "N", "sEncYn")
        
        
        var params: [String: String] = [String: String]()
        params["QID"] = "ORACLE_ADO_QUERY_SEL_03"
        params["QTYPE"] = "Package"
        params["USERID"] = "EMR"
        params["EXECTYPE"] = "FILL"
        params["TABLENAME"] = ""
        params["P01"] = "98015255"
        params["P02"] = ""
        
        var jsonString:String = ""
        do {
            let data =  try JSONSerialization.data(withJSONObject: params, options: [])
            jsonString = String(data: data, encoding: String.Encoding.utf8)!
            print(jsonString)
        } catch let myJSONError {
            #if DEBUG
            print(myJSONError)
            #endif
        }
        
        bodyData = bodyData + String(format: "<%@><![CDATA[%@]]></%@>", "sParam", jsonString, "sParam")
        bodyData = bodyData + String(format: "</%@>", webMethodName)
        bodyData = bodyData + "</SOAP-ENV:Body>"
        bodyData = bodyData + "</SOAP-ENV:Envelope>"
        let theUrl = URL(string: "http://yourPortNumber/EMRService/EMRService_Template.svc")
        var url = URLRequest(url: theUrl!)
        url.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.addValue(String(format: "http://tempuri.org/IEMRService/%@", webMethodName), forHTTPHeaderField: "SOAPAction")
        url.addValue(String(bodyData.lengthOfBytes(using: .utf8)), forHTTPHeaderField: "Content-Length")
        url.httpMethod = "POST"
        url.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        Alamofire.request(url).responseString { response in
            switch(response.result) {
            case .success:
                print(response.result.value)
                print("success")
            case .failure:
                print("fail")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLines()
        
        // Do any additional setup after loading the view.
    }


}

