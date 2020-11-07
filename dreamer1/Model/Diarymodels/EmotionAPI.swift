import UIKit

protocol EmotionDelegate {
    func didGetEmotionPoint(emotion: Emotion)
}

struct EmotionManager {
    var delegate: EmotionDelegate?
    var body: String = ""
    
    //let jsonClass1 = JasonFileManager<Manager>()

    func performRequest1(token: String, diary: String) {
        //var manager: Manager?
        print("start")
        let str = "https://aip.baidubce.com/rpc/2.0/nlp/v1/sentiment_classify?charset=UTF-8&access_token=" + token
        let url = URL(string: str)!

        print(url)
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        let temp = Data1(text: diary)
       
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(temp)
        request.httpBody = encoded
        let task = session.dataTask(with: request) { (data, response, error) in
            let emotion1 = self.parseJSON(DataToDecode: data!)
            self.delegate?.didGetEmotionPoint(emotion: emotion1!)

            if error != nil{
                print(error!)
            }
        }

        task.resume()
    }
    
    //处理获取的数据，该数据现为JSON类型
    func parseJSON(DataToDecode: Data) -> Emotion?{
        let decoder = JSONDecoder()  //实例化一个JSON类型数据的解码器
        do{
            print("start your performance")
            let str =  NSString(data:DataToDecode ,encoding: String.Encoding.utf8.rawValue)
            print(str!)
            let decodedData = try decoder.decode(JSONData1.self, from: DataToDecode)
            let confidence = decodedData.items[0].confidence
            let positive = decodedData.items[0].positive_prob
            let negative = decodedData.items[0].negative_prob

            let point = 10 * confidence * positive + 10 * (1 - confidence) * (1 - positive)/2
            
            let emotion = Emotion(positive: positive, negative: negative, point: point)
            return emotion
        }
        catch{
            print(error)
            return nil
        }
    }
}

struct Emotion{
    let positive: Float
    let negative: Float
    let point: Float
}

struct JSONData1: Codable {
    let items: [Items]
    let text: String
}

struct Data1: Codable {
    let text: String
}

struct Items: Codable {
    let confidence: Float
    let positive_prob: Float
    let negative_prob: Float
}

/*
class Manager: NSObject,Codable
{
    var text: String = ""
    
    private enum CodingKeys: String, CodingKey
    {
        case text
    }
        
    init(text: String) {
        self.text = text
    }
    
    override var description: String{
        return "text:\(text)"
    }
}
*/
