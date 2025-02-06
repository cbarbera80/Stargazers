import Foundation

enum JSONMapperError: Error {
    case missingJSON
    case invalidData
}

final class JSONMapper<Model: Decodable> {
    func decode(from path: String) throws -> Model {
        let data = try decodeData(from: path)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let model = try decoder.decode(Model.self, from: data)
        return model
    }
    
    func decodeData(from path: String) throws -> Data {
        
        guard let jsonFile = Bundle.main.path(forResource: path, ofType: "json") else {
            throw JSONMapperError.missingJSON
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFile), options: []) else {
            throw JSONMapperError.invalidData
        }

        return data
    }
}
