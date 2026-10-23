# Filllo Crowdfunding

根据 Pixso「Filllo Crowdfunding App UI Kit / Light Version」开发的 Flutter 公益众筹 App。本地可交互演示版，覆盖引导、账户、发现、搜索、捐赠、收据和个人中心。

- [项目结构、架构与使用说明](docs/PROJECT_GUIDE.md)
- [全部界面截图](docs/SCREENSHOTS.md)
- [验证记录](docs/VALIDATION.md)
- Android 安装包：`dist/Filllo-1.0.0-demo.apk`

## 快速运行

环境：Flutter 3.47.7 / Dart 3.13.5，Android SDK 35 或以上。

```sh
flutter pub get
flutter run
```

首次运行会显示三页引导。可以选择 **Explore as a guest** 直接浏览；模拟登录可使用任意有效邮箱与至少 8 位密码。注册验证码为 `1234`。

## 主要界面

| 首页 | 捐赠详情 | 捐赠成功 |
| :---: | :---: | :---: |
| ![首页](docs/screenshots/08-home.png) | ![详情](docs/screenshots/13-details.png) | ![收据](docs/screenshots/18-receipt.png) |

## 检查与构建

```sh
flutter analyze
flutter test
flutter drive --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d emulator-5556
flutter build apk --release
```

截图脚本会将 Android 实际运行画面写入 `docs/screenshots/`。设备编号请替换为 `flutter devices` 中的编号。

所有支付、社交登录和周期捐赠均为本地演示，不连接真实支付、账户或公益组织服务。地图为原设计稿静态素材。
