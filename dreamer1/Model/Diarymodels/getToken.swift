import UIKit

protocol TokenDelegate {
    func didGetToken(token: String)
}

struct TokenManager {
    //set it as delegate,so this struct can process the func "didGetToken"
    var delegate: TokenDelegate?

    var body: String = ""
    func performRequest() {
    
        let url = URL(string: "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=5cy1ij4fRGBexUgO0TmxuDLa&client_secret=ETp27MwMpuWqB3Y66VCdfpo6Hs99v57P")!

        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { (data, response, error) in
            let token = self.parseJSON(DataToDecode: data!)
            self.delegate?.didGetToken(token:token!)

            if error != nil{
                print(error!)
            }
        }

        task.resume()
    }
    
    //处理获取的数据，该数据现为JSON类型
    func parseJSON(DataToDecode: Data) -> String? {
        let decoder = JSONDecoder()  //实例化一个JSON类型数据的解码器
        do{
            let decodedData = try decoder.decode(JSONData.self, from: DataToDecode)
            let token1 = decodedData.access_token
            return token1
        }catch{
            print(error)
            return nil
        }
    }
}
    
struct JSONData: Codable {
    let access_token : String
}

