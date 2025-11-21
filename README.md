# 🌟 Baraka Bliss Staycations

### *A Modern Flutter App for Discovering and Booking Staycation Apartments*

Baraka Bliss Staycations is a mobile application designed to simplify the process of listing and booking apartments for short stays. The app allows property owners to upload apartments with images and features, while users can browse, explore, and book staycation spaces easily.

This project was built as part of the **Power Learn Project – July 2025 Cohort**.

---

## 🚀 Features

### 🏠 **Apartment Listings**

* Browse all available apartments
* View detailed information about each apartment
* Base64-encoded images for efficient storage
* Status indicator (Available / Unavailable)

### 📝 **Add Apartment (Lister Dashboard)**

* Upload apartment images (Base64 format)
* Enter apartment details: name, location, price, description
* Select from a list of features such as:

  * WiFi
  * Parking
  * Swimming Pool
  * CCTV
  * Laundry
  * Hot Shower
  * Balcony
  * Furnished
  * Backup Generator
  * 24/7 Security
* Features saved as a **list of strings** for safe retrieval
* Media saved as a **list of image strings** only (no videos)

### 🔍 **Feature Display**

* Each apartment displays its selected features as chips
* Clean UI with icons for better user experience

### 🔐 **Firebase Integration**

* Firestore database to store apartments
* Future support for authentication and bookings

---

## 🛠️ Tech Stack

| Technology                                | Usage                                           |
| ----------------------------------------- | ----------------------------------------------- |
| **Flutter**                               | Mobile UI                                       |
| **Dart**                                  | App logic                                       |
| **Firebase Firestore**                    | Database                                        |
| **Firebase Auth** *(optional for future)* | User accounts                                   |
| **Base64 Images**                         | Media storage solution without Firebase Storage |

---

## 📁 Project Structure

```
lib/
 ├── models/
 │    └── apartment.dart
 ├── screens/
 │    ├── home_screen.dart
 │    ├── add_apartment_screen.dart
 │    ├── apartment_detail_screen.dart
 ├── widgets/
 │    ├── apartment_card.dart
 │    └── add_apartment_form.dart
 ├── services/
 │    └── firestore_service.dart
 └── main.dart
```

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/GraceHinga/baraka-bliss-staycations.git
cd baraka-bliss-staycations
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Run the App

```bash
flutter run
```

> Make sure your Flutter environment is set up correctly.

---

## 🔥 Firebase Configuration

Create a Firebase project and add:

* `google-services.json` (Android)
* Enable **Cloud Firestore**

No Firebase Storage is required because images are Base64-encoded.
---

## 📌 Future Improvements

* User authentication (lister + guest accounts)
* Booking system
* Payment integration (M-Pesa)
* Admin dashboard
* Push notifications

---

## 🙏 Acknowledgements

This project was built as part of the **Power Learn Project (PLP)** July 2025 cohort.
Special thanks to the PLP mentors and the Baraka Bliss code assistant.

---

## 🧑‍💻 Author

**Natasha Wambui Hinga**
Mobile app and Backend Developer
Email: *[natashahinga58@gmail.com](mailto:natashahinga58@gmail.com)*
