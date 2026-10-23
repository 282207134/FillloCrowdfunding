# 验证记录

验证日期：2026-10-23（Asia/Tokyo）。

## 环境

- Flutter 3.47.7 / Dart 3.13.5。
- Windows 开发环境，Android 15 / API 35 x86_64 专用模拟器 `filllo_review`。
- 模拟器使用独立的 8 GB 数据分区；没有清除原有模拟器的应用或数据。
- 页面截图主要使用运行中 Flutter 渲染树生成 2 倍 PNG，避免原生截图接口在页面切换时捕获旧帧。所有插画预先加载；提醒弹窗另用 Release 包的 Android 系统原始截图复核并保存，包含真实状态栏。截图不包含系统键盘与模拟器边框。

## 自动化检查

| 检查 | 结果 |
| --- | --- |
| `flutter analyze` | 无问题 |
| `flutter test` | 6 项测试通过 |
| 全路由布局 | 25 条路由，375×812 / 320×640 两种逻辑屏幕尺寸，无布局异常 |
| 本地持久化 | 捐赠金额、卡片描述、周期、留言、资料重新加载后一致 |
| 非法金额 | 0、负数、NaN、Infinity、超出上限均被拒绝，不生成捐赠 |
| 表单阻断 | 自定义非法金额不能继续 |
| 草稿连续性 | 编辑金额后留言保留；保存的众筹标题与分类重新打开后恢复 |
| Android 端到端 | 模拟登录 → 首页 → 项目详情 → 35 美元 → 每周 → 留言 → 支付 → 收据；记录字段核对一致 |
| 页面与弹窗 | 共生成 37 张实际画面 PNG，逐页索引见 SCREENSHOTS.md |
| Android Release | 生成 `dist/Filllo-1.0.0-demo.apk`，使用开发签名 |
| Release 安装与启动 | 安装成功，冷启动显示引导；点击 Skip 后终止进程并重启，仍正确进入欢迎页，验证 Android 本机偏好存储可用；未发现 AndroidRuntime / Flutter 错误日志 |

安装包大小为 57,034,733 字节（约 54.4 MiB）。SHA-256：

```text
99680edc09056a451b43e63eaab809e81a14970454948aabe3f3c8894d594f96
```

[Release 安装后的系统原始截图](release-smoke.png)。

## 执行命令

```sh
flutter analyze
flutter test --reporter expanded
flutter drive --no-pub --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d emulator-5556
flutter build apk --release
```

## 验证限制

这次验证针对本地演示功能。没有验证真实登录、邮件、网络支付、后台项目管理、地理定位或自动扣款；这些服务没有接入。iOS 工程已保留，但 Windows 环境未执行 iOS 构建。Web 工程可作为后续调试目标，本次截图和端到端验收以 Android 为准。
