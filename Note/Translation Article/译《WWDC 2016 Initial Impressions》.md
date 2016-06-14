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




