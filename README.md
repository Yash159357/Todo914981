# 📝 TodoApp - Assignment Submission

A minimalist Flutter-based Todo List application implementing core task management features with local persistence.

![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue)
![Tech](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter)
![Storage](https://img.shields.io/badge/Storage-SharedPreferences-FF6B6B)

## 🚀 Features

### Core Functionality
✅ **Task Management**  
- Add new tasks with title/description  
- Delete tasks with swipe gesture  
- Mark tasks as complete/incomplete  
- Persistent local storage using SharedPreferences  

### UI/UX  
🖥️ **Clean Interface**  
- Home screen with task segments (Today/Completed/Pending)  
- Intuitive bottom navigation  
- Visual task cards with progress indicators  
- Responsive design for all screen sizes  

### Bonus Implementation  
🔒 **Extended Features**  
- Firebase Authentication (Email/Password)  
- Profile screen with user details  
- Search functionality across tasks  
- Advertisement carousel (Demo mode)  

## 🛠️ Technologies Used

**Core Stack**  
- Flutter 3.x  
- Dart 3.x  
- SharedPreferences 2.2.2  

**Additional Packages**  
- Firebase Auth 4.x  
- GoRouter 13.x  
- Intl 0.19.x  

## ⚙️ Installation

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/todoapp.git
   cd todoapp
2. **flutter pub get**
3. **flutter run**

## Project Structure
lib/
├── controller/      # State management  
├── model/           # Data models  
├── services/        # Local storage & auth  
├── view/            # UI screens  
└── widgets/         # Reusable components  
