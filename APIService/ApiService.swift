import Foundation

enum RequestType: String {
    case GET    = "GET"
    case POST   = "POST"
    case PATCH  = "PATCH"
    case PUT    = "PUT"
}


class APIService: CatalogAPIServiceProtocol, PromotionAPIServiceProtocol, ComboAPIServiceProtocol, AddressDeterminationAPIServiceProtocol, AccountsAPIServiceProtocol, CashbackAPIServiceProtocol, HistoryOrdersAPIServiceProtocol {
    
    func convertResult<T: Codable>(URLString: String, withToken: Bool, requestType: String, params: Data?, completion: @escaping (T?, String?) -> Void) {
        
        
        guard let reachbility = Reachability(),
            reachbility.currentReachabilityStatus != .notReachable else {
                completion(nil, "Подключение к сети отсутствует")
                return
        }
        
        
        guard let url = Foundation.URL(string: SushiVeslaApiService.host + URLString) else {return}
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        request.httpMethod = requestType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var headers: [String : String] = [:]
        if withToken {
            if SushiVeslaUserDefaults.getCurrentToken() != nil {
                headers["X-Auth-Token"] = SushiVeslaUserDefaults.getCurrentToken()!
                request.allHTTPHeaderFields = headers
            }
        }

        if let parameters = params {
            request.httpBody = parameters
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                self.printResult(request: request, response: response, error: error)
                
                if let data = data {
                    let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    debugPrint(responseData ?? "")
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let model = try decoder.decode(T.self, from: data)
                        completion(model, nil)
                        return
                    } catch let myDataError {
                        debugPrint(myDataError)
                        completion(nil, "Не удалось загрузить данные")
                        return
                    }
                    
                } else {
                    completion(nil, "Не удалось загрузить данные")
                }
            }
        }.resume()
    }
    
    fileprivate func printResult(request: URLRequest, response: URLResponse?, error: Error?) {
        print("\n🔽 🔽 🔽 🔽 🔽 🔽 🔽 🔽 🔽 🔽")
        
        if let URL = request.url {
            print("URL: \(URL)")
        }
        
        if let HTTPMethod = request.httpMethod {
            print("HTTP method: \(HTTPMethod)")
        }
        
        if let HTTPHeadersData = request.allHTTPHeaderFields {
            print("HTTP Headers: ")
            for header in HTTPHeadersData {
                print("\(header.key) - \(header.value)")
            }
        }
        
        if let HTTPBodyData = request.httpBody {
            if let HTTPBody = String(data: HTTPBodyData, encoding: String.Encoding.utf8) {
                print("HTTP Body: \(HTTPBody)")
            }
        }
        
        if let error = error {
            print("ERROR: \(error)")
        }
        
        if let response = response {
            if let statusCode = response as? HTTPURLResponse {
                print("Status code: \(statusCode.statusCode)")
                if statusCode.statusCode != 200 {
                    print("Response body: \(String(describing: response))")
                }
            }
        }
    }
     
}
