//
//  NetworkManager.swift
//  AutismLove
//
//  Created by BobbyPhtr on 09/05/21.
//

import Foundation
import Alamofire
import SwiftyJSON

final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    let session : Session
    
    private init() {
        session = Session.init()
    }
    
//    private static func getCertificates(_ filename : String, ofType: String)->SecCertificate {
//        let filePath = Bundle.main.path(forResource: filename, ofType: "der") ?? nil
//        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
//        guard let certificates = SecCertificateCreateWithData(nil, data as CFData) else {
//            fatalError("Certificate is not valid")
//        }
//        return certificates
//    }
    
    // MARK: POST
    
    /// Do API POST Request without Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func post(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API POST Request without Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Request Object with Encodable protocol
    ///   - onCompletion: Return Response and/or Network Error.
    func post<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .post, parameters: (params).dictionary, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API POST Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Request Object with Encodable protocol
    ///   - onCompletion: Return Response and/or Network Error.
    func postWithHeader<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .post, parameters: (params).dictionary, encoding: JSONEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API POST Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func postWithHeader(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    // MARK: GET
    
    /// Do API GET Request without Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func get(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .get, parameters: params, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API GET Request without Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Request Object with Encodable protocol
    ///   - onCompletion: Return Response and/or Network Error.
    func get<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .get, parameters: (params).dictionary, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API GET Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func getWithHeader(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API GET Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Request Object with Encodable protocol
    ///   - onCompletion: Return Response and/or Network Error.
    func getWithHeader<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .get, parameters: (params).dictionary, encoding: URLEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    // MARK: UPDATE
    
    /// Do API PATCH Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func update(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API PATCH Request without Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Request Object with Encodable protocol
    ///   - onCompletion: Return Response and/or Network Error.
    func update<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .patch, parameters: (params).dictionary, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API PATCH Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func updateWithHeader(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API PATCH Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Request Object with Encodable protocol
    ///   - onCompletion: Return Response and/or Network Error.
    func updateWithHeader<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .patch, parameters: (params).dictionary, encoding: JSONEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    // MARK: DELETE
    
    /// Do API DELETE Request without Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func delete(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API DELETE Request without Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Request Object with Encodable protocol
    ///   - onCompletion: Return Response and/or Network Error.
    func delete<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .delete, parameters: (params).dictionary, encoding: JSONEncoding.default).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    /// Do API DELETE Request with Header
    /// - Parameters:
    ///   - url: URL for API Request
    ///   - params: Parameters as dicitionary
    ///   - onCompletion: Return Response and/or Network Error.
    func deleteWithHeader(url : String, params : [String : Any]?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params ?? nil))")
        session.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                // Check if the content is error response
                onCompletion(response.data, nil)
            }
        }
    }

    func deleteWithHeader<T>(url : String, params : T?, onCompletion : @escaping (Data?, NetworkError?)->Void) where T : Encodable {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params?.dictionary ?? nil))")
        session.request(url, method: .delete, parameters: (params).dictionary, encoding: JSONEncoding.default, headers: getHeader()).responseData { response in
            print("<---------- URL : \(url)")
            NetworkManager.printData(response: response)
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    func uploadImage(withName: String, url : String, image : UIImage?, onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            if let image = image {
                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: withName, fileName: "\(Date().toMillis()!).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: getHeader()).responseData { response in
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    func sendImage(url : String, image : UIImage?, params: [String: Any], onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params))")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                print("Key : \(key)")
                print("Value: \(value)")
                if let value = value as? String {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key as String)
                }
            }
            
            if let image = image {
                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "\(Date().toMillis()!).jpg", mimeType: "image/jpg")
            }
            print("Multipart : \(multipartFormData)")
        }, to: url,
        method: .post,
        headers: getHeader()).responseData { response in
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    func sendFile(url : String, file : Data?, params: [String: Any], onCompletion : @escaping (Data?, NetworkError?)->Void) {
        print("----------> URL : \(url)")
        print("            Params  : \(String(describing: params))")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                print("Key : \(key)")
                print("Value: \(value)")
                if let value = value as? String {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key as String)
                }
            }
            
            if let file = file {
                multipartFormData.append(file, withName: "file", fileName: "\(Date().toMillis()!).pdf", mimeType: "application/pdf")
            }
            print("Multipart : \(multipartFormData)")
        }, to: url,
        method: .post,
        headers: getHeader()).responseData { response in
            if let err = response.error {
                if err.isSessionTaskError {
                    onCompletion(nil, .noInternetConnection)
                } else {
                    onCompletion(nil, .networkErrorWith(message: err.localizedDescription))
                }
            } else {
                onCompletion(response.data, nil)
            }
        }
    }
    
    func getHeader()->HTTPHeaders{
        let authHeader = HTTPHeader.authorization(bearerToken: Globals.token ?? "")
        let json = HTTPHeader.contentType("application/json")
        print([authHeader, json])
        return HTTPHeaders.init([authHeader, json])
    }
}

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    // Convert an Encodable Object into dictionary
    var dictionary: [String: Any] {
        get {
            return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
        }
    }
    
}

/// Extension ini untuk membantu NetworkManager melakukan parsing JSON dalam bentuk apapun.
extension NetworkManager {
    
    static func decode<T>(_ data:Data?, dataType: T.Type) throws -> AnyObject? where T : Codable {
        if data == nil { return nil }
        return try JSONDecoder().decode(dataType, from: data!) as AnyObject?
    }
    
    static func printData(response : AFDataResponse<Data>) {
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("            Data: \(utf8Text)")
        }
    }
}

extension String : ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

