# Steps to Run the App
The app relies solely on SPM, so it should build and run without any issues. You may need to adjust the signing team settings.
Please use the project workspace for running and testing.

# Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
The app is quite simple but fully modularized, primarily building itself from the presentation module. Each layer is responsible for a distinct part of the app. 
I focused primarily on the modularization aspect of the app, which offers several benefits, such as improved build times, clear separation of concerns between domain layers, responsibilities, and greater scalability for larger projects involving multiple teams and features.

## App Architecture Overview
### Commons
It should serve as a place to share common objects, such as the log function and the Loggable protocol, which can be used across all other modules

### Network
A simple and straightforward network layer that focuses solely on the requirements of this app, which involves making GET calls. It does not handle headers, authentication challenges, or any HTTP methods other than GET. The layer only returns raw data or throws errors, without performing any type conversion or decoding

### RecipeClient
It is responsible for the specifics of the recipes API and relies on the Network layer to make the necessary calls. This module is aware of the API endpoints required.

The RecipeClient is aware of the backend responses from this API, represented by Data Transfer Objects (DTOs). In the future, if there are any changes to these responses, we can make updates locally and simply adjust the mapping to the business object. This approach would also enable us to support multiple APIs with varying responses while maintaining a single business object.

### AppCore
The AppCore defines a Repository object that encompasses the repositories necessary for all known business models. If the number of models increases in the future, we can easily separate them into multiple repository aggregators based on specific flows or contexts.

These repositories handle requests to return business objects by first checking if they are available in the cache. If a cached version exists, it returns that; if not, it fetches the data from the network. Once the data is successfully retrieved, it is stored in the cache for future use.
Note that the cache layer is optional. 

### Presentation
This is where the views are constructed, alongside the DataModel, which is responsible for managing the business logic and representing the state of the view.

### App
The app itself is very simple. The idea is to have it build itself mostly from the presentation module.



# Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Given the time constraints, I wasn’t able to polish the UI as much as I would have liked, as I only had a couple of days to work on it and focused most of my time on the core functionality and architecture.

# Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
Given the simplicity of the app, I chose an architecture that decouples the business logic from the view by utilizing a data model object. Additionally, I opted not to implement a coordinator layer for managing navigation, as the app consists of only one screen.
That said, the data model is fully testable and decoupled from the view. If needed, we could easily integrate a layer to manage navigation, such as a coordinator or navigation router as the app grows. 

# Weakest Part of the Project: What do you think is the weakest part of your project?
One area for improvement is the dependency layer. Currently, since it’s a small app, I created a factory to resolve the repositories. However, this could be enhanced with a more robust dependency injection system, such as using a data container or another solution for managing dependencies efficiently.
If I had more time, I would explore using a different persistence layer, such as Core Data or another solution. However, due to time constraints, I opted for a simpler approach but decoupled it in a way that allows for an easy transition to a different solution in the future if needed.

# External Code and Dependencies: Did you use any external code, libraries, or dependencies?
It relies on an external module called Cache. Although I could have implemented it manually, for this test and real-world applications, it’s better to use a dependency like this as it already handles scenarios such as when the system issues a memory usage warning. This dependency is also optional for the repositories, allowing flexibility in composition if we choose not to use it.

# Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
