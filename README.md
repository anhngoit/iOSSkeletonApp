![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/banner.imageset/banner.png)

#  iOS Skeleton Application
- An template iOS Application that follows community best practice
- A ready-to-use base architecture you need to ship your app faster than the competition

## Tech stacks:
- [x] Clean Architecture + MVVM + Coordinator
- [x] Separated the Presentation, Business Logic, and Data Access layers
- [x] 2 implemented combo: UIKit+RxSwift vs SwiftUI+Combine
- [x] Dependency Injection
- [x] Networking & Offline Storage: Moya, Realm
- [x] Dependency Management: Swift Package Manager
- [x] Concurrency: Swift Concurrency, GCD
- [x] 4 Environments: Dev, QC, UAT and Prodution (4 schemas, 4 .xcconfig files)
- [x] localization using String Catalogs
- [x] Engineered for scalability,developing robust, large-scale production applications.
- [ ] Full test coverage

## Architecture Overview
![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/architecture_overview.imageset/architecture_overview.png)

### Architecture Pattern:
- **Clean Architecture:** Separates the application into multiple layers (Presentation, Domain, Data) to isolate business logic from UI and data management.
- **MVVM (Model-View-ViewModel):** A design pattern used for separating the business logic and presentation logic, making the code modular, testable, and maintainable.
- **Coordinator:** Manages navigation flow and dependencies between view controllers, decoupling the view controller from navigation logic.
- **Dependency Injection (DI):** Improves modularity and testability by managing object creation and providing dependencies.
### Flow Implementations:
I showcased two ways of inplementation: one implemented using UIKit + RxSwift, and the other using SwiftUI + Combine.
- **UIKit + RxSwift Combo:** Utilizes UIKit components with RxSwift for reactive programming, handling data binding between View and ViewModel.
- **SwiftUI + Combine Combo:** Implements UI using SwiftUI and reactive data flow using Combine, handling state management in a declarative way.
### Main Components:
#### 1. Presentation Layer:
- **View**: Handles the user interface, displaying data and responding to user inputs. In UIKit, this includes view controllers and UI elements, while in SwiftUI, it comprises views built declaratively.
- **ViewModel**: Acts as the intermediary between the View and the Domain layer. It manages the state and logic for the View, handling user inputs and processing data to be displayed.
#### 2. Domain Layer:
- **UseCase**: Encapsulates the application's business logic and coordinates tasks. It handles the flow of data between the ViewModel and the Data layer, ensuring that business rules are applied correctly.
#### 3. Data Layer:
- **Repository:** Serves as the gateway to data sources, managing data operations. It abstracts the data retrieval process, deciding when to fetch data from local storage or remote sources and ensuring the ViewModel receives the correct data format.
- **Data Sources:**
  - **Local Data Source:** Manages data stored locally, such as cached information, using databases or file systems.
  - **Remote Data Source:** Handles data retrieval from external sources like APIs, performing network operations and parsing responses.
#### 4. Coordinator Pattern:
- **Coordinator:** Manages the flow of navigation within the application. It handles transitions between screens, sets up view controllers or views, and injects the necessary dependencies. The Coordinator ensures that navigation logic is separated from the presentation layer, simplifying view components.
#### 5. Dependency Injection:
- **DI Container:** A centralized mechanism that manages the creation and provision of dependencies. By injecting required objects into components, it decouples class dependencies and enhances testability, allowing easy swapping of implementations (e.g., mock objects for testing).

## Detailed Implementation
### Combo #1: UIKit+RxSwift 
#### 1. MovieListViewController:
- **Responsibilities:** Displays a list of movies using a UICollectionView.
- **Binding:** Binds the ViewModel's observable properties (items, loading, error) to update the UI reactively.
- **View Events:** Triggers ViewModel actions on events like view loading (viewDidLoad), item selection, etc.
#### 2. MovieListViewModel:
- **Input:** Handles user actions (viewDidLoad, didSelectItem, etc.).
- **Output:** Manages state (items, loading, error) and provides data to the View.
- **Navigation:** Handles navigation actions (e.g., moving to the movie detail screen) through closures.
#### 3. MovieListUseCase:
- **Responsibilities:** Fetches data from repositories based on business rules.
- **Data Fetching:** Retrieves data from local or remote sources and manages caching strategy.
#### 4. MovieListRepository:
- **Responsibilities:** Abstracts data sources and provides data to UseCase.
#### 5. Data Sources:
- **Remote Data Source (Moya):** Fetches data from APIs.
- **Local Data Source (Realm):** Handles local caching and persistence.
#### 6. Coordinator (FirstTabCoordinator):
- **Responsibilities:** Manages navigation between screens in the UIKit + RxSwift flow.
- **Navigation Logic:** Handles the presentation of movie detail screens.
### Combo #2: SwiftUI + Combine:
#### 1. MovieListView:
- **Responsibilities:** Displays movies in a grid layout using SwiftUI.
- **State Management:** Uses @StateObject to observe ViewModel changes and update the UI.
- **View Events:** Triggers ViewModel actions when a movie item is tapped or when the view appears.
#### 2. MovieListViewModel2:
- **Input**: Handles user actions (onAppear, didSelectItem).
- **Output**: Manages state (movies, isLoading, error) and updates the View.
- **Navigation**: Manages navigation logic via closures, calling the coordinator to present detail views.
#### 3. MovieListUseCase2:
- **Responsibilities:** Similar to MovieListUseCase but adapted for Combine, it handles fetching movies and manages business logic asynchronously.
#### 4. MovieListRepository2:
- **Responsibilities:** Provides data by managing interactions between local (Realm) and remote (Moya) sources.
- **Data Fetching:** Performs asynchronous requests using Combine, adapting to SwiftUI's reactive paradigm.
#### 5. Data Sources:
- **Remote Data Source (Moya):** Fetches data from APIs.
- **Local Data Source (Realm):** Handles local caching and persistence.
#### 6. Coordinator (SecondTabCoordinator):
- **Responsibilities:** Handles navigation for SwiftUI + Combine flow.
- **Navigation Logic:** Shows movie detail screens based on user interactions.

## How to run
- Go to "https://developer.themoviedb.org/reference/intro/authentication" , register and get your own access token authentication.
  
![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/access_token_authen.imageset/access_token_authen.png)

- The application has been set up with 4 schemas for 4 environments with 4 config file.
  
![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/schema.imageset/Screenshot%202024-09-20%20at%2016.59.14.png)

- Select a schema and go to the corresponding config file.
- Add your access token authentication to field "ACCESS_TOKEN_AUTHEN"
- Run app and see the result
  
![](https://github.com/anhngoit/iOSSkeletonApp/blob/main/iOSSkeletonApp/Resources/Assets.xcassets/app_screen.imageset/app_screen.png)
