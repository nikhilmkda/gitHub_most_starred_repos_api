#GitHub Repos Starred App

GitHub Repos Starred is a mobile application developed using Flutter that allows users to view a list of the most starred GitHub repositories created within the last 30 days. The app fetches the data from the GitHub API and stores it in a local SQLite database to provide offline access to the repositories.

Features
View a list of the most starred GitHub repositories.
Each repository card displays the repository name, description, number of stars, owner's username, and owner's avatar.
Data is fetched from the GitHub API and stored in a local SQLite database for offline access.
User-friendly and visually appealing UI with a gradient background and custom repository cards.
Screenshots
GitHub Repos Starred App

Getting Started
To run the app on your local machine, follow the steps below:

Make sure you have Flutter installed on your computer. If not, follow the instructions on the Flutter website to install it.
Clone this repository using Git or download the ZIP file.
Open the project in your preferred IDE (e.g., Android Studio, Visual Studio Code).
Connect a physical device or start an emulator.
Run the app using the flutter run command in the terminal.
Dependencies
The app uses the following external packages:

flutter/material.dart: Provides the basic widgets and material design elements for building the user interface.
http: For making API calls to fetch GitHub repositories data.
provider: For state management and providing data to the UI using the Provider pattern.
sqflite: For working with the SQLite database to store and retrieve data locally.
Architecture
The app follows the Model-View-Provider (MVP) architecture, where the main components are:

Model: The GithubRepo and GithubOwner classes represent the data models for GitHub repositories and their owners, respectively. The DatabaseHelper class handles database operations.
View: The UI components are built using Flutter widgets, including the UserTile widget that displays each repository card.
Provider: The GithubProvider class manages the app's state and data fetching from the GitHub API. It uses the DatabaseHelper class to store fetched data in the local SQLite database.
Contribution
Contributions to this project are welcome! If you encounter any issues or have ideas for improvements, please open an issue or submit a pull request.



Acknowledgments
Special thanks to the Flutter community and the contributors of the external packages used in this project.


