![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/banner.imageset/banner.png)

# iOSSkeletonApp

A **production-ready iOS skeleton application** featuring modern Clean Architecture + MVVM and powerful dependency injection using [Factory](https://github.com/hmlongco/Factory). Built as a real-world reference for scalable, testable, and maintainable app development. Includes local storage abstraction (CoreData, SwiftData), comprehensive networking (Moya + Alamofire), and a fully-featured demo “Movie List” module.

<br>

## 🚀 Features

* **Clean Architecture + MVVM**
  Each feature module strictly follows Clean Architecture, layered for maintainability, and leverages MVVM for presentation:

  * **Presentation (MVVM):** Pure SwiftUI views with dedicated ViewModels for UI state and logic.
  * **Domain:** UseCases, Entities, and Repository protocols—business logic isolated from frameworks.
  * **Data:** All implementation details for networking and persistence. Easily mockable.
  * **Dependency Injection:** Powered by Factory for flexible, testable dependency management.

  > Build features with high separation of concerns, excellent testability, and scalable code structure.

* **Local Storage**
  CoreData and SwiftData under a unified protocol. Secure storage via Keychain and UserDefaults helpers.

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
├── Application/                  // App entry, AppDelegate, SceneDelegate
├── Core/                        // Foundation for DI, Networking, Storage, etc.
│   ├── Configuration/
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
├── iOSSkeletonAppTests/         // Unit tests (organized by feature)
├── iOSSkeletonAppUITests/       // UI Tests
```

<br>

## 🛠️ Tech Stack

* **SwiftUI** 
* **Combine** – modern reactive programming
* **Moya & Alamofire** – HTTP Networking, plugin logging
* **Factory** – dependency injection and test mocking
* **CoreData & SwiftData** – unified storage abstraction
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
* **Unified Local Storage:** Both CoreData and SwiftData are supported, so you can swap storage engines as needed, with one protocol.

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
* **Coverage**: Achieving 80%+ is realistic by following the included examples.
* **Continuous Integration Friendly**: Tests are fast, isolated, and deterministic. You can integrate into any CI pipeline for real regression safety.

### UI Tests

* Automated XCUITest flows under `iOSSkeletonAppUITests`.
* Tests include launching the app, verifying movie list UI loads, offline alert display, and more.
* Can easily expand for new features and regressions.


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

   * The application has been set up with 4 schemas for 4 environments with 4 config files:

   <img src="https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/schema.imageset/Screenshot%202024-09-20%20at%2016.59.14.png" width="65%">

   * Select a schema and go to the corresponding config file.
   * Add your access token authentication to the field `ACCESS_TOKEN_AUTHEN`.

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
* Caches to local (CoreData or SwiftData, configurable).
* Displays in a SwiftUI grid.
* Includes offline detection, loading, and error states.

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

* **Real-world, production-proven architecture:** Every layer, module, and file is organized for how real apps are built and maintained.
* **Lightning-fast onboarding:** New developers can jump right in. Structure is familiar, modular, and self-documenting.
* **No more glue code or spaghetti:** Protocol-oriented, DI-powered, and modular—makes refactoring, scaling, and testing effortless.
* **Rapid prototyping and smooth scaling:** Build MVPs in days, then scale to production with confidence (just swap mocks for real APIs and persistence).
* **Testing isn’t an afterthought:** Every component is built for testability—CI, regression safety, and fearless refactoring come standard.
* **Pluggable everything:** Switch APIs, local storage, themes, or even entire features with minimal code changes.
* **Developer happiness:** Enjoy expressive SwiftUI, readable tests, code linting, and no technical debt from day one.

**Make your next iOS project robust, future-proof, and fun—start with iOSSkeletonApp.**

---

## 📦 How to Extend

* Add features by duplicating the `Features/YourFeatureName` structure.
* Register new dependencies in `DIContainer`.
* Add local storage/data models as needed (use provided protocols/extensions).
* Add new API endpoints as new cases in `MovieAPI` (or your feature’s API).

* **Or Using My ready-to-use Clean Architecture Xcode File Template to create new feature:
[CleanArchXcodeFileTemplate](https://github.com/anhngoit/CleanArchXcodeFileTemplate)


---

## 📄 License

MIT

---

**Star this repo if you find it helpful!**
Feel free to open issues or PRs for improvements.

---

*Author: NGO QUANG TUAN ANH (Steven) — [LinkedIn](https://www.linkedin.com/in/anhngoit/)*

---

Let me know if you want this further customized, or want advanced example code snippets in the README!
