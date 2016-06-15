# 译《WWDC 2016 Initial Impressions》

标签（空格分隔）： 译文

---
> [原文链接](https://www.raywenderlich.com/136657/wwdc-2016-initial-impressions)，没有逐字逐句翻译，英文不是很好，翻译的不好各位见谅。

## Swift 3
Swift3将在2016年底发布，这对开发者来说是影响最大的，因为他将要求我们对代码做一些重大改变。

然而，如果你一直看[Swift evolution project](https://github.com/apple/swift-evolution),这真的不应该是个惊喜。因为 Swift 是开源的，苹果和社区一直努力工作在过去的6个月里，这一切都被公开讨论。今天没有什么新的宣布，除了一件事情：Swift3 已经和 Swift2.3 在 Xcode8里打包了。

这个解决了我去年的最大抱怨之一，我不能使用 Xcode7 除非我将代码全部迁移到 Swift2 了。但是因为 Xcode8 已经将 Swift3 和 Swift2.3（兼容2.2） 打包在一起了，所以现在可以在 Xcode8 里面使用 Swift2.2 的项目，直到准备好升级到 Swift3。

如果你没有跟随 Swift3 的讨论，我们会在明天发布一个完整的文章关于 Swift3 的新内容。此刻，我尤其想提及一件将影响我们所有人的事情。

## Swiftier Objective-C APIs
Swift3 的最大改变之一是将很多 API 变得更加 Swifty。

这很容易理解通过几个例子：
```swift
// Swift 2.2
let content = listItemView.text.stringByTrimmingCharactersInSet(
    NSCharacterSet.whitespaceAndNewlineCharacterSet())
 
// Swift 3
let content = listItemView.text.trimming(.whitespaceAndNewlines)
```
现在 Swift3 版本使用枚举更加简洁。

这里还有个关于  Core Graphics 的例子：
```swift
// Swift 2.2
let context = UIGraphicsGetCurrentContext()
CGContextMoveToPoint(context, 5, 0)
CGContextAddLineToPoint(context, 10, 10)
CGContextAddLineToPoint(context, 0, 10)
CGContextClosePath(context)
 
// Swift 3
let context = UIGraphicsGetCurrentContext()!
context.moveTo(x: 5, y: 0)
context.addLineTo(x: 10, y: 10)
context.addLineTo(x: 0, y: 10)
context.closePath()
```
最后，这里还有一个使用 GCD 通过很简单API 的例子
```swift
// Swift 2.2
let queue = dispatch_queue_create("myqueue", nil)
dispatch_async(queue) { 
  // do stuff
}
 
// Swift 3
let queue = DispatchQueue(label: "myqueue")
queue.async { 
  // do stuff
}
```
正如你所看到的，目的是减少冗长的命名;长远来看，这会使语言更加简洁并且更容易让新的开发者入门。而且，Xcode8 也提供了迁移到 Swift3 的工具，这也让事情变得更简单。

我看到这些改变很激动因为新的 APIs 看起来更加直观。

> Note: 如果想学习更多，请看苹果的[API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)和[ Better Translation of Objective-C APIs into Swift](https://github.com/apple/swift-evolution/blob/master/proposals/0005-objective-c-name-translation.md)
    
## Swift Playgrounds on the iPad
这里作者也没说什么，大体意思就是很适合教学用。
## Xcode 8
目前为止这里有几个亮点对于我来说。
### Memory Debugger
Xcode8 有个很酷的特性是新的 Memory Debugger。

这是个内置的工具可以让你查看你的运行应用的整个内存对象图表，所以你可以马上隔离泄露和循环引用。一旦你发现他们出现在图标中你可以选择他们，查看该帧的栈和直接跳转到有问题的代码。

新的 Memory Debugger 可以自动发现内存泄露并且帮助你马上诊断问题。Demo 是让人印象深刻的，再见，循环引用！

### Interface Builder Improvements
你有没有尝试在 Interface Builder 里进行缩小，然后试着拖动按钮,你意识到不能这样做除非 Interface Builder 在100%的比例下。

这种日子不多了！ Xcode8 的 Interface Builder 现在允许你修改任意尺寸。

还提供了一个新的配置允许你在不同的设备和 size classes（iPhone, iPad等等）下预览控制器大小，还会在编译和运行之前识别出 ambiguous 的布局约束。

### Source Code Editing
Xcode8 提高了编辑器的自动预览图片和颜色的功能[^footnote]。![此处输入图片的描述][1]![此处输入图片的描述][2]

你也可以创建你自己的源码编辑器扩展来自定义编程体验。这是一个新的 Xcode 模板，你完成以后可以将你的扩展放到 Mac App Store 或者其他的渠道。

### Performance Improvements
Xcode8 在几个方面变得很快，举个例子，Indexing Tests 比之前提高了50倍。

速度的提升从根本上提高了开发者的效率，所以这是个大新闻。

## iOS 10 SDK
iOS 10 SKD 添加了一些新的 kits，扩展点并增强了现有的框架。

### SiriKit
现在你可以在 iOS 10里使用 SiriKit。

SiriKit 提供了6个在应用中可用的 Siri 服务：

- 音频或者视频呼叫
- Messaging
- 转账或者收款
- 搜索图片
- 预订行程
- 管理锻炼

如果你的应用有上面几点的功能，你应该在你应用中提供一个  Intents Extension。Siri 处理所有语言间的细微差别和语义分析，并将用户的请求转换成可操作的事情通过 Intents Extension。你可以选择提供一个自定义 UI 来使用 Siri 或者 Maps。

有一些细节在你的 Extension 中必须提供为了让系统确保你的应用可以处理用户的请求。

> Note: 想学习更多，请看[ SiriKit Programming Guide.](https://developer.apple.com/library/prerelease/content/documentation/Intents/Conceptual/SiriIntegrationGuide/)

## iMessage Apps
动图和 fireworks，我来了！

对于新的 Messages framework 你可以创建 extensions 来让用户发送文字，表情，媒体，文件和交互式信息。

### Sticker Packs
最简单的扩展类型是 Sticker Packs。你可以很简单的创建和允许用户可以发送给他们朋友的一套表情。如果你熟悉 Facebook Messenger 那么看起来会差不多，除了表情 可以被“peeled”并被放置在其他信息顶部。

### Interactive Experiences
APIs 允许你创建完整的体验在 Messages 应用里，甚至提供了一个自定义用户界面。这比第三方键盘有更好的体验。

> Note: 想学习更多，请看[  Messages Framework Reference.](https://developer.apple.com/reference/messages)

## User Notifications
新的 UserNotificationsUI framework 允许我们创建丰富的通知，这在之前是不可能的。

例如，现在通知可以内嵌媒体就像股票消息应用。这似乎涉及到了一个你的应用和 APNs 之间的一个 intermediate  服务。你甚至可以提供你自己的端对端的加密功能通过 intermediate  服务。

我还没有时间去研究这部分，你可以去查看[ UserNotifications framework reference.](https://developer.apple.com/reference/usernotifications)

## Widget Overhaul
Widget 在你主屏幕的左边，他也可以显示在应用图标上通过3D Touch。

## watchOS 3
在手表上启动应用是很慢的。

### Speed Enhancements
在 Speed Enhancements 之前介绍了3件事情，Snapshots，Dock,Background Tasks。这三者结合起来允许你的应用保持更新并且用户能够得到一点提示。

Snapshots 和 Background Tasks 和 iOS 里的很像：

- 系统会将 UI 截图当你启动应用和切换应用。
- 当你应用是启动时，在一定时间内会在后台更新信息。

### SceneKit and SpriteKit Availability
你现在可以在手表应用中使用 SceneKit 和 SpriteKit。一开始我认为这只用于游戏，但是苹果告诉我们还有个用途：在应用中创建自定义动画。

目前在手表上的 UIKit 限制开发者创建自定义动画。但是在 WatchOS 3中，你可以添加实时3D渲染内容在应用中通过使用**.scn**文件打包你的资源，或者你也可以选择创建2D 交互式动画通过打包**.sks**文件。

### Complication Improvements
当用户在 watchOS 3中将你的应用添加到 watch face 上，你的应用可以保存随便被启动的状态并且每天可以进行50次推送更新。

## tvOS 10
tvOS SDK 的更新看起来很轻量。

VideoSubscriberAccount 框架可以提供身份验证和授权。

现在有很多现在框架提供给开发者：

- ExternalAccessory
- HomeKit
- MultipeerConnectivity
- Photos
- ReplayKit
- UserNotifications

## macOS
15年后，OS X 改名为 macOS。我不是一名 macOS 开发者，但有个新特性我很感兴趣。

### Apple Pay for the Web
macOS Sierra 可以让用户在 web 上用 APPle Pay!

这个特性可以让顾客不需要担心信用卡信息在网站上被记录。具体可以看[ Apple Pay JavaScript framework.](https://developer.apple.com/reference/applepayjs)

## Apple File System (APFS)
苹果宣布了全新的文件系统！

APFS 被设计在 Flash/SSD 上并且建立本地加密。

> 下面这段受限于自己水平，翻译的不好，大家可以读原文

包括崩溃保护，空间共享，克隆和快照。崩溃保存使用了一个 copy-on-write metadata 方案来确保更新文件系统是安全的并且减少日志的需要通过 HFS+。控件共享允许在同一个磁盘下的多个文件系统共享空闲的空间而不需要重新分区。

克隆提供了一个在磁盘空间上无成本创建复制文件和目录。快照允许系统创建一个只读的数据实例并让我们恢复到特定时刻。

[^footnote]: 这个好像只能在 Playground 里面使用，具体是在Editor -> 底部有3个 insert 选项

  [1]: http://i2.buimg.com/7f852ed9adbb4a4a.png
  [2]: http://i2.buimg.com/a4d12c5522b7ceb8.png