![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/banner.imageset/banner.png)

# iOSSkeletonApp

A **starting point for new iOS apps**: modern Clean Architecture + MVVM with dependency injection via [Factory](https://github.com/hmlongco/Factory). Built as a real-world reference for scalable, testable, and maintainable app development. Includes a local storage abstraction (Core Data, with SwiftData models scaffolded), networking (Moya + Alamofire), and a demo “Movie List” module wired end to end.
<br>

## 🚀 Features

* **Clean Architecture + MVVM**
  Each feature module strictly follows Clean Architecture, layered for maintainability, and leverages MVVM for presentation:

  * **Presentation (MVVM):** Pure SwiftUI views with dedicated ViewModels for UI state and logic.
  * **Domain:** UseCases, Entities, and Repository protocols—business logic isolated from frameworks.
  * **Data:** All implementation details for networking and persistence. Easily mockable.
  * **Dependency Injection:** Powered by Factory for flexible, testable dependency management.
  <br>
  >  Build features with high separation of concerns, excellent testability, and scalable code structure.

* **Local Storage**
  A `LocalStorage` protocol with a Core Data implementation. SwiftData models and a `SDDataSource` are scaffolded but not yet wired into the DI container. Keychain and `UserDefaults` helpers included.

* **Networking**
  Moya + Alamofire with plugin-based request/response logging.

* **Theming & Design**
  Modular color/font themes, asset catalogs. Light/Dark mode ready.

* **Testing-Ready**
  Unit and UI tests, easy mock/stub injection, preview support for SwiftUI views.

* **Configurable Environments**
  Multi-target: Dev, QC, UAT, Production.

* **Demo: Movie List**
  Loads and caches movies from API, presents as a responsive SwiftUI grid, includes offline/error states.

---

## 🗂 Project Structure

```
iOSSkeletonApp/
│
├── Application/                  // App entry point
├── Core/                        // Foundation for DI, Networking, Storage, etc.
│   ├── Configuration/
│   │   ├── Secrets/             // Git-ignored per-env tokens + tracked template
│   ├── DI/
│   ├── Networking/
│   ├── LocalStorage/
│   ├── Extensions/
│   ├── Logger/
│   ├── Common/
│   ├── Utilities/
│
├── Features/                     // Feature modules (e.g., MovieList)
│   ├── MainTabView/
│   ├── MovieList/
│       ├── Presentation/
│           ├── View/
│           ├── ViewModel/
│       ├── Domain/
│           ├── UseCases/
│           ├── Entities/
│           ├── Repositories/
│       ├── Data/
│           ├── Repositories/
│           ├── Datasources/
│           ├── Models/
│
├── Resources/                   // Fonts, Colors, Assets, Localizable
│
├── Tools/Sourcery/              // Mock generation: config + stencil
├── iOSSkeletonAppTests/         // Unit tests
│   ├── Features/                // Specs, mirroring the app's feature tree
│   ├── Mocks/
│   │   ├── DataSource/          // Hand-written doubles for concrete classes
│   │   ├── Generated/           // Sourcery output — do not edit
│   ├── Utils/
├── iOSSkeletonAppUITests/       // UI Tests
```

<br>

## 🛠️ Tech Stack

* **SwiftUI** 
* **Combine** – modern reactive programming
* **Moya & Alamofire** – HTTP Networking, plugin logging
* **Factory** – dependency injection and test mocking
* **Core Data** – persistence behind a `LocalStorage` protocol (SwiftData models scaffolded)
* **Kingfisher** – async image loading
* **Quick & Nimble** – expressive BDD tests
* **SwiftLint** – code style enforcement

---

## 🧑‍💻 Architecture Details (Clean Architecture + MVVM)
![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/architecture_overview.imageset/architecture_overview.png)
The codebase is organized with a strict Clean Architecture approach, seamlessly blended with the MVVM pattern for the Presentation layer:

* **Feature-oriented structure:** Every business feature gets its own module inside `Features/`, containing everything needed for scalable, independent growth.
* **Presentation Layer:** SwiftUI views are paired with their ViewModels. ViewModels handle state, UI logic, and delegate domain actions via protocols.
* **Domain Layer:** UseCases encapsulate business rules, Entities model your business objects, and Repositories define contracts. No dependency on frameworks, so it's pure and testable.
* **Data Layer:** Implements repositories, networking (Moya/Alamofire), and persistence (CoreData/SwiftData) via protocols. Data mapping is explicit and safe.
* **Dependency Injection:** Managed by Factory, which enables environment-specific injection, mock/stub swapping, and test preview setups without boilerplate.
* **Local Storage behind a protocol:** `LocalStorage` defines the contract and `CDDataSource` implements it over Core Data, so a different engine can be dropped in without touching the layers above. SwiftData models are scaffolded for that path but not yet registered in the container.

This structure delivers:

* Total separation of concerns (UI, business logic, persistence, DI are all isolated)
* Easily swappable implementations for every dependency (great for tests, previews, and environment configs)
* Rapid onboarding: new team members see the same structure everywhere
* Feature modules scale independently, so growth is never chaos

---

## 🧪 Testing

Testing is a first-class citizen in iOSSkeletonApp, with a focus on speed, reliability, and true test-driven development (TDD):

### Unit Tests

* **Comprehensive Coverage**: All layers—Data, Domain, and Presentation (ViewModels)—have their own test suites, under `iOSSkeletonAppTests/Features/...`.
* **Mock & Stub Friendly**: Thanks to Factory DI, dependencies can be injected as mocks or stubs, enabling true isolated unit tests with no network or database.
* **Example tests include:**

  * Testing ViewModel output, state transitions, error handling.
  * Verifying UseCase logic and boundary conditions.
  * Repository tests that ensure data flows correctly from mocked APIs or local stores.
  * DataSource tests for CRUD, edge cases, and data mapping.
* **Behavior-driven development (BDD)**: With Quick & Nimble, you write expressive, readable tests that act as living documentation.
* **Continuous Integration**: `.github/workflows/main.yml` runs SwiftLint and the unit-test suite on every push and PR to `main`. No API token is needed — every test injects a mock through Factory.

### UI Tests

* XCUITest target scaffolded under `iOSSkeletonAppUITests` (launch test only so far — the CI workflow runs unit tests only).

---

## 🧬 Generated mocks

Protocol test doubles are generated by [Sourcery](https://github.com/krzysztofzablocki/Sourcery) instead of hand-written, so they never drift from the protocol.

**Setup** (once):

```bash
brew install sourcery
```

**Usage**: annotate any protocol, then regenerate by hand:

```swift
// sourcery: AutoMockable
protocol MovieListRepository {
    func getRemotePopularMovies() -> AnyPublisher<MoviePage, any Error>
}
```

```bash
sourcery --config Tools/Sourcery/Sourcery.yml
```

> Deliberately **not** wired to a build phase. Generation has to read the whole source tree and write outside the build directory, which requires `ENABLE_USER_SCRIPT_SANDBOXING = NO`; this project keeps script sandboxing on. Re-run the command above after changing an annotated protocol, and commit the result.

You get `MovieListRepositoryMock` (a trailing `Protocol` in the name is stripped) with per-method call counts, recorded arguments, stubbable return values, and a closure hook:

```swift
let repository = MovieListRepositoryMock()
repository.getRemotePopularMoviesReturnValue = Just(page)
    .setFailureType(to: Error.self)
    .eraseToAnyPublisher()

Container.shared.movieListRepository.register { repository }

// …exercise the code under test, then:
expect(repository.getRemotePopularMoviesCallsCount).to(equal(1))
expect(repository.savePopularMoviesMovieResponseReceivedMovieResponse).to(equal(page))
```

Config lives in [Tools/Sourcery](Tools/Sourcery); output is committed at `iOSSkeletonAppTests/Mocks/Generated/GeneratedMocks.swift`, so a fresh clone builds without Sourcery installed. Mocks are generated into the **test** target, so no mock code is compiled into a shipping build — see the comments in `Sourcery.yml` for how to move them into the app target if you want SwiftUI previews to use them.

> Generic protocols (`LocalStorage`, `DomainConvertible`) can't be auto-mocked — Sourcery's AutoMockable doesn't handle `associatedtype`. Those still need hand-written doubles like `MockMovieLocalDataSource`.


---

## 🏁 Getting Started & How to Run

### Setup

1. **Clone the repo**

   ```bash
   git clone https://github.com/anhngoit/iOSSkeletonApp.git
   ```

2. **Install dependencies (via SPM)**
   Xcode will auto-resolve.
   If needed:
   `File > Packages > Resolve Package Versions`

3. **Configure MovieDB API Token**

   * Go to [The MovieDB Authentication](https://developer.themoviedb.org/reference/intro/authentication) and register to get your own access token authentication.

   <img src="https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/access_token_authen.imageset/access_token_authen.png" width="50%">

   * The application has been set up with 4 schemes for 4 environments with 4 config files:

   <img src="https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/schema.imageset/schema.png" width="65%">

   * Tokens go in **git-ignored** files under `iOSSkeletonApp/Core/Configuration/Secrets/`, never in the tracked `Dev/QC/UAT/Production.xcconfig`. Create one per environment you build:

     ```bash
     cd iOSSkeletonApp/Core/Configuration/Secrets
     for env in Dev QC UAT Production; do
       cp Secrets.xcconfig.template "Secrets.$env.xcconfig"
     done
     ```

   * Fill in `ACCESS_TOKEN_AUTHEN` in each copy. Each environment gets its own token, so revoking one doesn't take down the others.
   * The matching `*.xcconfig` pulls the file in with `#include?`. A missing file is not a build error — the app just logs a clear message at launch and API calls return 401.

   > `.gitignore` covers `Secrets.*.xcconfig`, and the xcconfig files are deliberately *not* in Copy Bundle Resources, so tokens don't end up readable inside the shipped `.ipa`.

4. **Run the App**

   * Open `iOSSkeletonApp.xcodeproj` in Xcode.
   * Select the desired scheme (`iOSSkeletonApp`, `iOSSkeletonApp-Dev`, etc.).
   * Build & Run.

   <img src="https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/app_screen.imageset/app_screen.png" width="35%">

### Environments

* **Dev, QC, UAT, Production**
  Switch targets/schemes as needed.

---

## 🎬 Demo Feature: Movie List

* Loads movies from API using `MovieAPI` (The Movie DB style endpoint, easily swappable).
* Caches page 1 to Core Data.
* Emits the cached page first, then the fresh one, so the list renders before the network answers.
* Displays in a SwiftUI grid, with loading, empty, and error states plus an offline alert.

---

## 🔗 Dependencies

| Package    | Why it's used                                  | Link                                                                           |
| ---------- | ---------------------------------------------- | ------------------------------------------------------------------------------ |
| Factory    | Dependency injection and testable architecture | [https://github.com/hmlongco/Factory](https://github.com/hmlongco/Factory)     |
| Kingfisher | Asynchronous remote image loading/caching      | [https://github.com/onevcat/Kingfisher](https://github.com/onevcat/Kingfisher) |
| Moya       | Clean API networking, request abstractions     | [https://github.com/Moya/Moya](https://github.com/Moya/Moya)                   |
| Quick      | Behavior-driven unit testing (BDD)             | [https://github.com/Quick/Quick](https://github.com/Quick/Quick)               |
| Nimble     | Expressive assertions for BDD tests            | [https://github.com/Quick/Nimble](https://github.com/Quick/Nimble)             |
| SwiftLint  | Code style and static analysis                 | [https://github.com/realm/SwiftLint](https://github.com/realm/SwiftLint)       |

---

## 🏆 Why use iOSSkeletonApp?

**iOSSkeletonApp isn’t just a starting template—it's a launchpad for serious iOS app development.**

* **A structure that scales:** Every layer, module, and file is organized for how real apps are built and maintained.
* **Fast onboarding:** New developers can jump right in. Structure is familiar, modular, and self-documenting.
* **Protocol-oriented and DI-powered:** makes refactoring, scaling, and testing straightforward.
* **Testing isn’t an afterthought:** Every component is built for testability, and CI runs lint + tests on every PR.
* **Pluggable:** Switch APIs, local storage, themes, or entire features with minimal code changes.
* **The fiddly bits are already right:** per-environment secrets that can't be committed, cancellable network publishers, redacted auth headers in logs, generated mocks that can't drift from their protocols.

**Make your next iOS project robust, future-proof, and fun—start with iOSSkeletonApp.**

---

## 📦 How to Extend

* Add features by duplicating the `Features/YourFeatureName` structure.
* Register new dependencies in `DIContainer`.
* Get a test double for free: annotate the protocol with `// sourcery: AutoMockable` and re-run Sourcery. See [Generated mocks](#-generated-mocks) below.
* Add local storage/data models as needed (use provided protocols/extensions).
* Add new API endpoints as new cases in `MovieAPI` (or your feature’s API).

* **Or Using My ready-to-use Clean Architecture Xcode File Template to create new feature:**
[CleanArchXcodeFileTemplate](https://github.com/anhngoit/CleanArchXcodeFileTemplate)


---

## 📄 License

MIT

---

**Star this repo if you find it helpful!**
Feel free to open issues or PRs for improvements.

---

*Author: NGO QUANG TUAN ANH (Steven) — [LinkedIn](https://www.linkedin.com/in/anhngoit/)*
