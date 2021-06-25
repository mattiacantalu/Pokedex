# Pokédex
Sample iOS application to understand how http://pokeapi.co/ works.

The project is oriented toward the following patterns: 

✅ MVVM Architecture

✅ Protocol Oriented

✅ Functional Programming

✅ Clean Code

✅ Dependency Injection

✅ Unit Tests

It's based on a `GET` API request and built over a `UITableViewController` and `UIViewController`.


## HOW IT WORKS

Each controller is built by 4 files
1. Coordinator (routing layer)
2. Model (model)
3. ViewModel (business logic for a use case)
4. View (display data)


### CONFIGURATION

The coordinator layer performs the injection:

🔸 Model

🔸 ViewModel

    let viewModel = ListViewModel(service: service,
                                  imageDownloader: imageDownloader,
                                  coordinator: self)


... building the main services of the application:

🔸 Cache and Image services
    
    let imageDownloader = MImageDownloader(service: configuration.service,
                                           cache: MCacheService())
    

🔸 Network Service

        
    struct MURLConfiguration {
        let service: MURLService
        let baseUrl: String

        init(service: MURLService,
            baseUrl: String) {
            self.service = service
            self.baseUrl = baseUrl
       }
    }
    
    let service = MServicePerformer(configuration: configuration)
    

### MVVM FLOW

1. View calls ViewModel

    ```
    override func viewDidLoad() {
        [...]
        loadData()
    }

    func loadData() {
        viewModel.fetch(success: { [weak self] in self?.dataSource = $0 },
                        failure: { [weak self] in self?.error = $0 })
    }
    ```

2. ViewModewl performs the business logic

    ```
    var name: String {
        pokemon.map { $0.name }.notNil
    }
    var weight: String {
        pokemon.map { $0.weight.stringValue }.notNil
    }
    var height: String {
        pokemon.map { $0.height.stringValue }.notNil
    }

    func fetch(success: @escaping (DetailViewModel) -> Void,
               failure: @escaping (Error) -> Void) {
        performTry({ try service.pokemon(by: poke.url) { result in
            switch result {
            case .success(let response):
                self.pokemon = response
                success(self)
            case .failure(let error):
                failure(error)
            }
        }
        }, fallback: { failure($0) })
    }
    ```
    ... using Models:
    ```
    struct Pokemon: Codable {
        let name: String
        let experience: Int
        let weight: Int
        let height: Int
        let abilities: [PokeAbility]
        let moves: [PokeMove]
        let types: [PokeType]
        let stats: [PokeStat]
        let images: PokeImages

        private enum CodingKeys : String, CodingKey {
            case name = "name",
                 experience = "base_experience",
                 weight = "weight",
                height = "height",
                abilities = "abilities",
                moves = "moves",
                types = "types",
                stats = "stats",
                images = "sprites"
        }
    }
    ```


3. View updates the UI
    ```
    private var viewModel: DetailViewModel {
        didSet {
            show(name: viewModel.name,
                 weight: viewModel.weight,
                 height: viewModel.height)
            show(abilities: viewModel.abiltyViewModel)
            show(moves: viewModel.moveViewModel)
            show(types: viewModel.typeViewModel)
            show(stats: viewModel.statViewModel)
            show(sprites: viewModel.spritesViewModel)
        }
    }
    ```

### CORE SERVICES

1. `MServicePerformer` makes the requests
```
struct MServicePerformer {
    private let configuration: MURLConfiguration

    init(configuration: MURLConfiguration) {
        self.configuration = configuration
    }

    var baseUrl: URL? {
        URL(string: configuration.baseUrl)
    }

    func makeRequest<T: Decodable>(_ request: MURLRequest,
                                     map: T.Type,
                                     completion: @escaping ((Result<T, Error>) -> Void)) throws {
        
        let urlRequest = request
            .build()

        configuration
            .service
            .performTask(with: urlRequest) { responseData, urlResponse, responseError in
                completion(self.makeDecode(response: responseData,
                                           urlResponse: urlResponse,
                                           map: map,
                                           error: responseError))
            }
    }
    
    [...]
}
```

2. `MURLService` is a concrete implementation of `MURLServiceProtocol`: manages the `performTask` and dispatches the response
```
extension MURLService: MURLServiceProtocol {
    func performTask(with request: URLRequest,
                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: request) { responseData, urlResponse, responseError in
            self.dispatcher.dispatch {
                completion(responseData, urlResponse, responseError)
            }
        }
    }

    func performTask(with url: URL,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: url) { responseData, urlResponse, responseError in
            self.dispatcher.dispatch {
                completion(responseData, urlResponse, responseError)
            }
        }
    }
}
```

3. `MURLSession` implements the `MURLSessionProtocol`, creating network tasks
```
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: request) { responseData, urlResponse, responseError in
            completion(responseData, urlResponse, responseError)
        }
        task.resume()
    }

    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: url) { responseData, urlResponse, responseError in
            completion(responseData, urlResponse, responseError)
        }
        task.resume()
    }
```

4. `MServicePerformer` also makes the deconding and mapping, based on generic `Decodable` objects
```
    private func makeDecode<T: Decodable>(response: Data?,
                                          urlResponse: URLResponse?,
                                          map: T.Type,
                                          error: Error?) -> (Result<T, Error>) {
        
        if let error = error { return (.failure(error)) }
        guard let jsonData = response else { return (.failure(MServiceError.noData)) }
        
        let statusCode = urlResponse?.httpResponse?.statusCode ?? MConstants.URL.statusCodeOk

        guard statusCode.inRange(MConstants.URL.statusCodeOk ..< MConstants.URL.statusCodemultipleChoice) else {
            return decode(response: jsonData,
                          map: MError.self)
                .mapError(code: statusCode)
        }

        return decode(response: jsonData, map: map)
    }
    
    private func decode<T: Decodable>(response: Data,
                                          map: T.Type) -> (Result<T, Error>) {
        do {
            let decoded = try JSONDecoder().decode(map, from: response)
            return (.success(decoded))
        } catch { return (.failure(error)) }
    }
```

5. Images are downloaded by `MImageDownloader`, using `MCacheable` to cache them
```
    func makeRequest(with url: URL,
                     completion: @escaping (_ image: Data?) -> Void) {
        (cache.object(for: url.absoluteString) as? Data)
            .fold(some: { cached(data: $0, completion: completion) },
                  none: { perform(url: url, completion: completion) })
    }
```

```
    func cached(data: Data,
                completion: @escaping (_ image: Data?) -> Void) {
        completion(data)
    }

    func perform(url: URL,
                 completion: @escaping (_ image: Data?) -> Void) {
        service.performTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == MConstants.URL.statusCodeOk,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil else {
                completion(nil)
                return
            }
            cache.set(obj: data, for: url.absoluteString)
            completion(data)
        }
    }
```

## Comands (get pokemon)

The _get pokedex_ request (one of the commands) is implemented inside `PokeCommands` as an extension of `MServicePerformer`, conformed to `MServicePerformerProtocol`

```
    func pokedex(offset: Int,
                 limit: Int,
                 completion: @escaping ((Result<Pokedex, Error>) -> Void)) throws {

        guard let url = baseUrl else {
            completion(.failure(MServiceError.couldNotCreate(url: baseUrl?.absoluteString)))
            return
        }

        let request = { () -> MURLRequest in
            MURLRequest
                .get(url: url)
                .with(component: MConstants.URL.Component.pokemon)
                .appendQuery(name: MConstants.URL.Query.offset, value: offset.stringValue)
                .appendQuery(name: MConstants.URL.Query.limit, value: limit.stringValue)
        }

        try makeRequest(request(),
                        map: Pokedex.self,
                        completion: completion)
    }
```

### TESTS

Each module is unit tested (mocks oriented): decoding, mapping, services, model, viewModel:

1. viewModel sample test

```
    func testFetch_withSucceededService_shouldSucceed() throws {
        service?.pokedexHandler = { offset, limit, completion in
            XCTAssertEqual(offset, 0)
            XCTAssertEqual(limit, 20)
            completion(.success(Pokedex.mock))
        }

        XCTAssertEqual(sut?.viewModel.count, 0)
        
        sut?.fetch(success: {
            XCTAssertEqual($0.count, 1)
            XCTAssertEqual($0.first?.name, "poke_name")
        }, failure: { XCTFail("Expected success. Got \($0)") })
        
        XCTAssertEqual(service?.counterPokedex, 1)
        XCTAssertEqual(sut?.viewModel.count, 1)
    }
```

```
    func testShowPokemon() {
        let final = UIViewController()
        let sender = UIViewController()

        coordinator?.detailControllerHandler = {
            XCTAssertEqual($0.name, "name")
            XCTAssertEqual($0.url, "poke_url")
            return final
        }
        coordinator?.pushHandler = {
            XCTAssertEqual($0, final)
            XCTAssertEqual($1 as? UIViewController, sender)
        }

        sut?.show(pokemon: Poke(name: "name", url: "poke_url"),
                  sender: sender)

        XCTAssertEqual(coordinator?.counterPush, 1)
    }
```

2. Comand (decoding and mapping) test

```
func testGetPokemonResponseShouldSuccess() {
        guard let data = JSONMock.loadJson(fromResource: "valid_get_pokemon") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession(data: data, response: nil, error: nil) { _ in }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokemon(by: "https://pokeapi.co/api/v2/pokemon/1") { result in
                    switch result {
                    case .success(let response):
                        XCTAssertEqual(response.name, "bulbasaur")
                        XCTAssertEqual(response.height, 7)
                        XCTAssertEqual(response.weight, 69)
                        XCTAssertEqual(response.experience, 64)

                        XCTAssertEqual(response.abilities.count, 2)
                        XCTAssertEqual(response.abilities.first?.ability.name, "overgrow")
                        XCTAssertEqual(response.abilities.first?.ability.url, "https://pokeapi.co/api/v2/ability/65/")

                        XCTAssertEqual(response.moves.count, 78)
                        XCTAssertEqual(response.moves.first?.move.name, "razor-wind")
                        XCTAssertEqual(response.moves.first?.move.url, "https://pokeapi.co/api/v2/move/13/")

                        XCTAssertEqual(response.images.front, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
                        XCTAssertEqual(response.images.back, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")

                        XCTAssertEqual(response.stats.count, 6)
                        XCTAssertEqual(response.stats.first?.stat.name, "hp")
                        XCTAssertEqual(response.stats.first?.stat.url, "https://pokeapi.co/api/v2/stat/1/")
                        XCTAssertEqual(response.stats.first?.value, 45)

                        XCTAssertEqual(response.types.count, 2)
                        XCTAssertEqual(response.types.first?.type.name, "grass")
                        XCTAssertEqual(response.types.first?.type.url, "https://pokeapi.co/api/v2/type/12/")
                    case .failure(let error):
                        XCTFail("Should be success! Got: \(error)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
```

3. API Request tests

```
    func testCreateRequest() {
        guard let url = URL(string: "https://pokeapi.co/api/v2") else {
            XCTFail("URL error!")
            return
        }

        let request = MURLRequest
            .get(url: url)
            .with(component: "pokemon")
            .appendQuery(name: "offset", value: "20")
            .appendQuery(name: "limit", value: "10")
        XCTAssertEqual(request.url.absoluteString, "https://pokeapi.co/api/v2/pokemon?offset=20&limit=10")
        XCTAssertEqual(request.method.rawValue, "GET")
    }
```

4. API Error tests

```
    func testMapError() {
        guard let data = JSONMock.loadJson(fromResource: "valid_error") else {
            XCTFail("JSON data error!")
            return
        }

        let url = URL(string: "https://pokeapi.co/api/v2/poke")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 401,
                                       httpVersion: "1.0",
                                       headerFields: [:])
        
        let session = MockedSession.simulate(failure: response, data: data) { _ in }

        let service = MURLService(session: session,
                                   dispatcher: SyncDispatcher())
        let config =  MURLConfiguration(service: service,
                                        baseUrl: "https://pokeapi.co/api/v2")
        
        do {
            try MServicePerformer(configuration: config).pokedex() { result in
                    switch result {
                    case .success:
                        XCTFail("Should be fail! Got success.")
                    case .failure(let error):
                        XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. ( error 401.)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
```

## CONTRIBUTORS
Any suggestions are welcome 👨🏻‍💻

## REQUIREMENTS
• Swift 5

• Xcode 12.5
