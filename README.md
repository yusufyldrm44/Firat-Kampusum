# Fırat Üniversitesi Kampüsüm (Flutter)

Flutter ile geliştirilmiş, kampüs yaşamını kolaylaştıran çok platformlu (Android/iOS/Web/Windows/macOS) uygulama. Kulüpler ve derslikler, etkinlikler, haberler ve bildirimler gibi modüller içerir; Firebase altyapısı ile gerçek zamanlı çalışır.

## Özellikler
- Kulüpler: Kategori sekmeleri, detay sayfası
- Derslikler: Fakülte → Bölüm → Gün filtresi ile listeleme, detay sayfası
- Etkinlikler: Kategori bazlı liste, detay sayfası, admin paneli ile yönetim
- Haberler: Liste ve detay, admin paneli ile yönetim
- Bildirimler: Genel bildirim arşivi ve kullanıcı bildirimleri, okunmamış filtresi, rozet
- Admin Paneli: Etkinlik/duyuru oluşturma, düzenleme, silme

## Teknolojiler
- Flutter (Dart)
- Firebase: Authentication, Cloud Firestore, Storage, Firebase Core
- Paketler: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `url_launcher`, `video_player`, `flutter_map`, `latlong2`, `share_plus`, `image_picker`

## Proje Yapısı (kısaltılmış)
```
lib/
  main.dart
  clubs_page.dart
  club_detail_page.dart
  classrooms_page.dart
  faculty_departments_page.dart
  department_classrooms_page.dart
  notifications_page.dart
  admin_notifications_page.dart
  events_page.dart
  admin_events_page.dart
  news_detail_page.dart
  all_news_page.dart
  models/
  services/
  utils/
```

## Kurulum
1) Bağımlılıklar
```
flutter clean
flutter pub get
```

2) Firebase yapılandırması
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Web (opsiyonel): `web/index.html` içinde Firebase config eklenmeli

3) Çalıştırma
```
flutter run
```
Belirli cihaz için: `flutter run -d windows | chrome | edge | emulator-id`

## Build
- Android (APK):
```
flutter build apk
```
Çıktı: `build/app/outputs/flutter-apk/app-release.apk`

- Web:
```
flutter build web
```
Çıktı: `build/web/`

## Firestore Kuralları (Teslim sonrası önerilen)
> Geliştirme sırasında açık kurallar kullanılabilir; yayına geçmeden önce güvenli kurallara dönülmelidir.
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notifications/{docId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    match /userNotifications/{docId} {
      allow create: if request.auth != null && (
        request.resource.data.userId == request.auth.uid ||
        (request.auth.token.admin == true && request.resource.data.userId is string)
      );
      allow read, update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    match /events/{docId} { allow read: if true; allow write: if request.auth != null && request.auth.token.admin == true; }
    match /news/{docId} { allow read: if true; allow write: if request.auth != null && request.auth.token.admin == true; }
    match /departments/{docId} { allow read: if true; allow write: if request.auth != null && request.auth.token.admin == true; }
    match /classrooms/{docId} { allow read: if true; allow write: if request.auth != null && request.auth.token.admin == true; }
    match /{path=**} { allow read: if true; allow write: if false; }
  }
}
```

## Ekran Görüntüleri (opsiyonel)
`/assets` altına görseller ekleyip burada referans verebilirsiniz.

## Lisans (opsiyonel)
MIT / Apache-2.0 / GPL-3.0 (tercihinize göre)

---
Sorular ve katkılar için GitHub Issues veya Pull Request açabilirsiniz.
