# 🚀 Crypto Price App

An iOS application for monitoring cryptocurrency prices in real-time.

## ✨ Features

- 📊 Display list of cryptocurrencies with current prices
- 🔄 Pull-to-refresh to update data
- 🎨 Clean and readable interface
- 📱 Support for both iPhone and iPad

## 🛠 Technologies Used

- 🎯 SwiftUI for UI
- 🏗 MVVM Architecture
- 🧹 Clean Architecture
- 🌐 URLSession for networking
- ⚡️ Combine for reactive programming

## 📁 Project Structure

```
crypto-price-app/
├── App/
│   └── crypto_price_appApp.swift
├── Presentation/
│   └── Homepage/
│       ├── HomepageView.swift
│       └── HomepageViewModel.swift
├── Domain/
│   ├── Entities/
│   │   └── CoinEntity.swift
│   ├── UseCases/
│   │   └── CoinUseCase.swift
│   └── Adapters/
│       └── CoinUseCaseAdapter.swift
├── Data/
│   ├── Services/
│   │   └── ApiService.swift
│   ├── Repositories/
│   │   ├── CoinRepository.swift
│   │   └── CoinRepositoryImpl.swift
│   ├── Responses/
│   │   └── CoinResponse.swift
│   └── Mapper/
│       └── Mapper.swift
└── Preview Content/
    └── Preview Assets.xcassets
```

## 🚀 How to Run

1. 📥 Clone this repository
2. 💻 Open `crypto-price-app.xcodeproj` in Xcode
3. ⚙️ Add .xconfig file to your project
   ```
    // Cloudinary Credentials
    CLOUDINARY_CLOUD_NAME = your_cloud_name
    CLOUDINARY_API_KEY = your_api_key
    CLOUDINARY_API_SECRET = your_api_secret
    CLOUDINARY_UPLOAD_PRESET = your_upload_preset
   ```
5. 📱 Select simulator or device target
6. ▶️ Press Run (⌘R)

## 🤝 Contributing

Please feel free to submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

[MIT](https://choosealicense.com/licenses/mit/) 
