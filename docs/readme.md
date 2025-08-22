

**Cách tạo SHA-1 trên Windows**

Phương pháp 1: Sử dụng keytool trực tiếp

Mở Command Prompt (CMD) với quyền administrator
Chạy lệnh sau:

>keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

![alt text](image.png)



Alias name: androiddebugkey

Creation date: Aug 7, 2024

Entry type: PrivateKeyEntry

Certificate chain length: 1

Certificate[1]:
Owner: C=US, O=Android, CN=Android Debug

Issuer: C=US, O=Android, CN=Android Debug

Serial number: 1

Valid from: Wed Aug 07 13:50:10 ICT 2024 until: Fri Jul 31 13:50:10 
ICT 2054

Certificate fingerprints:
         SHA1: 5A:B0:46:6A:7F:BE:2A:1C:1A:52:A9:9C:49:27:45:BA:7E:11:D0:F0
         SHA256: 10:AA:E0:F8:C1:98:CB:86:BE:02:90:7F:16:C4:33:81:D5:51:4D:8B:99:57:E5:9D:C6:09:E3:88:C2:DA:29:00
Signature algorithm name: SHA256withRSA

Subject Public Key Algorithm: 2048-bit RSA key

Version: 1


![alt text](image-1.png)



I see you're working on setting up Google Sign-In for your Flutter app and need help with the OAuth client ID setup. Here's how to complete the form shown in your screenshot:

## Creating an OAuth client ID for Android

1. **Application type**: You've already selected "Android" from the dropdown.

2. **Name**: Enter a name for your OAuth client. This is what you'll see in the Google Cloud Console (e.g., "My Flutter App").

3. **Package name**: Enter your application's package name exactly as it appears in your Flutter project's AndroidManifest.xml file. This is typically something like "com.example.myapp".

4. **SHA-1 certificate fingerprint**: You need to generate this fingerprint by running the keytool command:

   For a debug certificate (during development):
   ```
   keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
   ```

   Look for the SHA-1 fingerprint in the output and copy it exactly (it will look something like "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD").

5. **Verify app ownership** (optional): You can skip this during initial setup.

6. **Advanced settings**: You can leave these collapsed for now unless you need specific configurations.

After filling out these details, click the "Create" button (which is likely just below the visible part of the screenshot).

Remember that it may take a few minutes to a few hours for the settings to take effect, as noted at the bottom of the form.

Once your OAuth client ID is created, you'll need to add it to your Flutter project. Do you need help with that next step?



# **Add to project:**

Tích hợp Google Sign-In vào ứng dụng của bạn.


1. **Cập nhật pubspec.yaml** 

> **flutter pub add google_sign_in**

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     google_sign_in: ^6.3.0
   ```

2. **Cập nhật Android Manifest** (nếu cần):
   Đảm bảo AndroidManifest.xml có quyền internet:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

3. **Triển khai Google Sign-In trong mã của bạn**:
   - Tạo instance GoogleSignIn
   - Thiết lập các phương thức đăng nhập/đăng xuất
   - Xử lý thông tin người dùng đã đăng nhập

4. **Kiểm tra và chạy ứng dụng**:
   - Kết nối thiết bị Android hoặc khởi động máy ảo
   - Chạy ứng dụng và thử tính năng đăng nhập

Nếu bạn gặp vấn đề trong quá trình triển khai hoặc cần giúp đỡ với bất kỳ bước nào tiếp theo, hãy cho tôi biết. Tôi sẵn sàng cung cấp hướng dẫn chi tiết hoặc giải quyết các vấn đề cụ thể mà bạn có thể gặp phải.


![alt text](image-2.png)