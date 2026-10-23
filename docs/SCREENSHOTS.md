# 界面截图索引

以下截图由 Android 15 / API 35 专用模拟器实际运行 Flutter App 后生成，包含所有独立页面及重要交互状态。截图不含模拟器外框；长页面同时提供滚动后的画面。Pixso 参考图另存于 [design/](design/)，不与 App 截图混用。

## 截图清单

| 序号 | 界面 / 状态 | 路由 | PNG |
| --- | --- | --- | --- |
| 1 | 引导一 | `/onboarding` | [查看截图](screenshots/01-onboarding.png) |
| 2 | 引导二 | `/onboarding` | [查看截图](screenshots/02-onboarding.png) |
| 3 | 引导三 | `/onboarding` | [查看截图](screenshots/03-onboarding.png) |
| 4 | 欢迎与账户入口 | `/welcome` | [查看截图](screenshots/04-welcome.png) |
| 5 | 邮箱注册 | `/signup` | [查看截图](screenshots/05-signup.png) |
| 6 | 验证码 | `/verify` | [查看截图](screenshots/06-verification.png) |
| 7 | 登录 | `/signin` | [查看截图](screenshots/07-signin.png) |
| 8 | 首页上半部分 | `/home` | [查看截图](screenshots/08-home.png) |
| 9 | 首页附近项目与组织 | `/home` | [查看截图](screenshots/09-home-more.png) |
| 10 | 公益项目列表 | `/category` | [查看截图](screenshots/10-causes.png) |
| 11 | 附近项目 | `/nearby` | [查看截图](screenshots/11-nearby.png) |
| 12 | 公益组织简介 | `/organization` | [查看截图](screenshots/12-organization.png) |
| 13 | 项目详情 | `/details` | [查看截图](screenshots/13-details.png) |
| 14 | 选择捐赠金额 | `/gift` | [查看截图](screenshots/14-select-gift.png) |
| 15 | 捐赠摘要 | `/summary` | [查看截图](screenshots/15-gift-summary.png) |
| 16 | 周期捐赠弹窗 | `/summary` | [查看截图](screenshots/16-recurring-sheet.png) |
| 17 | 支付方式 | `/payment` | [查看截图](screenshots/17-payment.png) |
| 18 | 捐赠成功收据 | `/receipt` | [查看截图](screenshots/18-receipt.png) |
| 19 | 自定义金额 | `/custom-gift` | [查看截图](screenshots/19-custom-gift.png) |
| 20 | 搜索与最近组织 | `/search` | [查看截图](screenshots/20-search.png) |
| 21 | 搜索结果 | `/search` | [查看截图](screenshots/21-search-results.png) |
| 22 | 搜索无结果 | `/search` | [查看截图](screenshots/22-search-empty.png) |
| 23 | 个人中心 | `/profile` | [查看截图](screenshots/23-profile.png) |
| 24 | 个人中心菜单 | `/profile` | [查看截图](screenshots/24-profile-menu.png) |
| 25 | 提醒设置弹窗 | `/profile` | [查看截图](screenshots/25-reminders.png) |
| 26 | 资料编辑 | `/profile-details` | [查看截图](screenshots/26-profile-details.png) |
| 27 | 钱包 | `/wallet` | [查看截图](screenshots/27-wallet.png) |
| 28 | 添加演示卡片弹窗 | `/wallet` | [查看截图](screenshots/28-add-card.png) |
| 29 | 捐赠历史 | `/history` | [查看截图](screenshots/29-history.png) |
| 30 | 周期捐赠记录 | `/recurring` | [查看截图](screenshots/30-recurring-gifts.png) |
| 31 | 选择众筹受助人 | `/fundraise-for` | [查看截图](screenshots/31-fundraise-for.png) |
| 32 | 众筹信息 | `/fundraise-details` | [查看截图](screenshots/32-fundraise-details.png) |
| 33 | 众筹分类弹窗 | `/fundraise-details` | [查看截图](screenshots/33-category-sheet.png) |
| 34 | 支持与帮助 | `/support` | [查看截图](screenshots/34-support.png) |
| 35 | 重置密码说明 | `/forgot` | [查看截图](screenshots/35-reset-password.png) |
| 36 | 历史空状态 | `/history` | [查看截图](screenshots/36-history-empty.png) |
| 37 | 流程结束返回首页 | `/home` | [查看截图](screenshots/37-home-final.png) |

## 原稿与实现的差异

- 原稿中若干层名与实际内容不一致，例如 Sign in Screen 实际为 Fundraise details；实现以画面业务内容为准。
- 搜索键盘与未输入 / 有结果状态合并到同一可操作页面，键盘由系统控制。
- 捐赠历史同时准备了有记录和空状态；个人资料中的统计由实际本地记录计算。
- 帮助、重置密码说明、搜索空状态与演示卡片弹窗是为完整交互补充的界面。
- 截图中的成功捐赠为自动测试生成的 35 美元模拟记录，不能用作真实付款证明。

## 重新采集

```sh
flutter drive --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d emulator-5556
```

将设备编号替换为本机目标模拟器。运行会覆盖同名截图，不修改 Pixso 设计文件，也不会产生真实付款。

