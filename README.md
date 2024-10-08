# Recipes App

A Flutter application that allows users to authenticate, view a list of recipes from other users, add new recipes, and discover a "Recipe of the Day." The app integrates with Firebase for authentication and real-time database functionalities.It also includes AES encryption for securely handling sensitive data through a dedicated API.

## Features

- **User Authentication:** Secure sign-in and sign-out using Firebase Authentication.
- **Recipe Management:** Explore other users' recipes stored in Firebase Realtime Database.
- **User's Recipes:** User can add their own recipes which are to be store locally in the Hive.
- **Recipe of the Day:** Get recipe from API based on user input.
- **AES Encryption:** Securely encrypts the lucky number of user through an AES encryption.
- **AES Decryption:** Decrypts the recieved encrypted recipe of the day.
- **Animated UI:** Animated floating action button to attract user interaction.
- **Responsive Design:** Adapts to different screen sizes and orientations.


## Screenshots
![Screenshot1](https://github.com/user-attachments/assets/b32989d8-7170-4bf8-ba76-3a45301535ef)
![Screenshot2](https://github.com/user-attachments/assets/e8c3672e-aa47-4e71-b3ed-e0153e3d7189)
![Screenshot3](https://github.com/user-attachments/assets/5cc5f827-864d-4fb9-8b4d-f93b29f8123b)
![Screenshot4](https://github.com/user-attachments/assets/1a36a8d5-c1ce-4e56-b7f7-8bdb338a973b)





## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your machine:

- **Flutter SDK:** [Installation Guide](https://flutter.dev/docs/get-started/install)
- **IDE:** Such as [Android Studio](https://developer.android.com/studio), [VS Code](https://code.visualstudio.com/), or others.

### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/elmahygurl/recipes_app.git
   cd recipes_app

2. **Install Dependencies:**
    Navigate to the project directory and run:
    ```bash
    flutter pub get

3. **Configure Assets:**
    Ensure that the asset images (back.jpg, back0.PNG, etc.) are placed in the assets/ directory. Verify that the pubspec.yaml includes these assets:
    ```bash
    flutter:
    uses-material-design: true

    assets:
        - Assets/back.jpg
        - Assets/back0.PNG

4. **Run the App**
    Connect a device or start an emulator, then execute:
    ```bash
    flutter run

5. **user credentials you can use**
    username: hi@hi.com
    password: hihi123
   
    
