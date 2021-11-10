//
//  CandyImageTests.swift
//  CandyImageTests
//
//  Created by Matt Thomas on 06/11/2021.
//

import XCTest
@testable import CandyImage

class CandyImageTests: XCTestCase {
    private var api: API?
    private var apiURL: URL? = URL(string: "https://pixabay.com/api/")!
    private var validImageData: String? = "{\"total\":30781,\"totalHits\":500,\"hits\":[{\"id\":887443,\"pageURL\":\"https://pixabay.com/photos/flower-life-yellow-flower-crack-887443/\",\"type\":\"photo\",\"tags\":\"flower,life,yellowflower\",\"previewURL\":\"https://cdn.pixabay.com/photo/2015/08/13/20/06/flower-887443_150.jpg\",\"previewWidth\":150,\"previewHeight\":116,\"webformatURL\":\"https://pixabay.com/get/g641cf720e25afbc22b87942700ac4cd33a4062806b946959239bf8f2a3be7302c4c75d2a3a695e9ff14337b2dcb6f5a3_640.jpg\",\"webformatWidth\":640,\"webformatHeight\":497,\"largeImageURL\":\"https://pixabay.com/get/g4db4d7e8d53c696ce4acc87264abcab2d696f5d00cc5b70fc8da99cc9aa40a008e9c0fd6264859c5806ea9191f3759e610f3bdef719597844b8e7e423df1ad91_1280.jpg\",\"imageWidth\":3867,\"imageHeight\":3005,\"imageSize\":2611531,\"views\":242296,\"downloads\":142308,\"collections\":2314,\"likes\":974,\"comments\":156,\"user_id\":1298145,\"user\":\"klimkin\",\"userImageURL\":\"https://cdn.pixabay.com/user/2017/07/18/13-46-18-393_250x250.jpg\"}]}"

    private var invalidImageData: String? = "{\"total\":30781,\"totalPits\":500,\"hits\":[{\"iD\":887443,\"pageURL\":\"https://pixabay.com/photos/flower-life-yellow-flower-crack-887443/\",\"type\":\"photo\",\"tags\":\"flower,life,yellowflower\",\"previewURL\":\"https://cdn.pixabay.com/photo/2015/08/13/20/06/flower-887443_150.jpg\",\"previewWidth\":150,\"previewHeight\":116,\"webformatURL\":\"https://pixabay.com/get/g641cf720e25afbc22b87942700ac4cd33a4062806b946959239bf8f2a3be7302c4c75d2a3a695e9ff14337b2dcb6f5a3_640.jpg\",\"webformatWidth\":640,\"webHeight\":497,\"largeImageURL\":\"https://pixabay.com/get/g4db4d7e8d53c696ce4acc87264abcab2d696f5d00cc5b70fc8da99cc9aa40a008e9c0fd6264859c5806ea9191f3759e610f3bdef719597844b8e7e423df1ad91_1280.jpg\",\"imageWidth\":3867,\"imageHeight\":3005,\"imageSize\":2611531,\"views\":242296,\"downloads\":142308,\"collections\":2314,\"likes\":974,\"comments\":156,\"user_id\":1298145,\"user\":\"klimkin\",\"userImageURL\":\"https://cdn.pixabay.com/user/2017/07/18/13-46-18-393_250x250.jpg\"}]}"

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        api = API(urlSession: urlSession)
        super.setUp()
    }

    func testJSONDecodeSuccess() throws {
        let expectation = XCTestExpectation(description: "Test Successful JSON decode")
        let data = Data(validImageData!.utf8)
        MockURLProtocol.requestHandler = { request in
            guard request.httpMethod == "GET" else {
                XCTFail("Wrong Http method")
                throw APIError.networkError
            }
            let response = HTTPURLResponse(url: URL(string: "https://someurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        api?.fetchImageDataFromAPI(searchTerm: "", page: 1, completion: { result in
            switch result {
            case .success(let images):
                XCTAssertTrue(images.count == 1)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Test Should not have failed! Image JSON should have decoded without error.")
            }
        })
        wait(for: [expectation], timeout: 4.0)
    }

    func testJSONDecodeError() throws {
        let expectation = XCTestExpectation(description: "Test Unsuccessful JSON decode")
        let data = Data(invalidImageData!.utf8)
        MockURLProtocol.requestHandler = { request in
            guard request.httpMethod == "GET" else {
                XCTFail("Wrong Http method")
                throw APIError.networkError
            }
            let response = HTTPURLResponse(url: URL(string: "https://someurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        api?.fetchImageDataFromAPI(searchTerm: "", page: 1, completion: { result in
            switch result {
            case .success(_):
                XCTFail("Test Should not have succeeded! Image JSON should have failed to decode.")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 4.0)
    }

    func testImagesAreCached() {
        let expectation = XCTestExpectation(description: "Test Successful JSON decode")
        let data = Data(validImageData!.utf8)
        MockURLProtocol.requestHandler = { request in
            guard request.httpMethod == "GET" else {
                XCTFail("Wrong Http method")
                throw APIError.networkError
            }
            let response = HTTPURLResponse(url: URL(string: "https://someurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        api?.fetchImageDataFromAPI(searchTerm: "testTerm", page: 1, completion: { result in
            switch result {
            case .success(let images):
                XCTAssertTrue(images.count == 1)
                XCTAssertNotNil(ImageCache.shared.images(for: "testTerm1"))
                expectation.fulfill()
            case .failure(_):
                XCTFail("Test Should not have failed! Image JSON should have decoded without error.")
            }
        })
        wait(for: [expectation], timeout: 4.0)
    }

    override func tearDown() {
        api = nil
        apiURL = nil
        validImageData = nil
        invalidImageData = nil
        super.tearDown()
    }
}
