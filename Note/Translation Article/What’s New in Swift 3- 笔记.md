# What’s New in Swift 3? 笔记

标签（空格分隔）： 译文

---
## 关于 API 的
- 很多 APIs 改名了，具体请看[API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- 调用函数或者方法第一个参数有参数名了。
```swift
// old way, Swift 2, followed by new way, Swift 3

"RW".writeToFile("filename", atomically: true, encoding: NSUTF8StringEncoding)
"RW".write(toFile: "filename", atomically: true, encoding: NSUTF8StringEncoding)

SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
SKAction.rotate(byAngle: CGFloat(M_PI_2), duration: 10)

UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)

override func numberOfSectionsInTableView(tableView: UITableView) -> Int
override func numberOfSections(in tableView: UITableView) -> Int

func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
func viewForZooming(in scrollView: UIScrollView) -> UIView?

NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(reset), userInfo: nil, repeats: true)
NSTimer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(reset), userInfo: nil, repeats: true)
```
你可以看到以上代码有很多介词，这是为了优化可读性。

你现在可以看到很多重载的方法名，因为 APIs 变得更加直白，下面有2个 `index():`的例子：
```swift
let names = ["Anna", "Barbara"]
if let annaIndex = names.index(of: "Anna") {
  print("Barbara's position: \(names.index(after: annaIndex))")
}
```

总而言之，参数名的改变让方法名变得更加统一和容易学习。

- 删减了不必要的单词，让 API 变得更加 Swifty[[SE-0005]:](https://github.com/apple/swift-evolution/blob/master/proposals/0005-objective-c-name-translation.md)

```swift
// old way, Swift 2, followed by new way, Swift 3
let blue = UIColor.blueColor()
let blue = UIColor.blue()

let min = numbers.minElement()
let min = numbers.min()

attributedString.appendAttributedString(anotherString)
attributedString.append(anotherString)

names.insert("Jane", atIndex: 0)
names.insert("Jane", at: 0)

UIDevice.currentDevice()
UIDevice.current()
```

## GCD and Core Graphics
GCD 被用于很多线程任务类似于与服务器通讯和大量计算。**libdispatch**库使用 C 语言写的并且经常使用 C style API。现在 API 变得更加 Swifty[[SE-0088]:](https://github.com/apple/swift-evolution/blob/master/proposals/0088-libdispatch-for-swift3.md)
```swift

// old way, Swift 2
let queue = dispatch_queue_create("com.test.myqueue", nil)
dispatch_async(queue) {
    print("Hello World")
}

// new way, Swift 3
let queue = DispatchQueue(label: "com.test.myqueue")
queue.asynchronously {
  print("Hello World")
}
```
Core Graphics 和 GCD 一样，请看[[SE-0044]:](https://github.com/apple/swift-evolution/blob/master/proposals/0044-import-as-member.md)
```swift
// old way, Swift 2
let ctx = UIGraphicsGetCurrentContext()
let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor)
CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
CGContextSetLineWidth(ctx, 10)
CGContextAddRect(ctx, rectangle)
CGContextDrawPath(ctx, .FillStroke)
UIGraphicsEndImageContext()

// new way, Swift 3
if let ctx = UIGraphicsGetCurrentContext() {
    let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
    ctx.setFillColor(UIColor.blue().cgColor)
    ctx.setStrokeColor(UIColor.white().cgColor)
    ctx.setLineWidth(10)
    ctx.addRect(rectangle)
    ctx.drawPath(using: .fillStroke)

    UIGraphicsEndImageContext()
}
```
## Capitalization on Enumeration Cases
Swift3 枚举的成员首字母变成了小写
```swift
// old way, Swift 2, followed by new way, Swift 3
UIInterfaceOrientationMask.Landscape
UIInterfaceOrientationMask.landscape

NSTextAlignment.Right
NSTextAlignment.right

SKBlendMode.Multiply
SKBlendMode.multiply
```
具体请看[[SE-0006]:](https://github.com/apple/swift-evolution/blob/master/proposals/0006-apply-api-guidelines-to-the-standard-library.md)
## Methods that Return or Modify
方法后缀如果是“-ed” 或者 “-ing” ，那么这个方法是个动词，且有返回值。如果一个方法没有后缀，那么这个方法是个名词，不返回值，只进行一些操作。
```swift

customArray.enumerate()
customArray.enumerated()

customArray.reverse()
customArray.reversed()

customArray.sort() // changed from .sortInPlace()
customArray.sorted()

var ages = [21, 10, 2] // variable, not constant, so you can modify it
ages.sort() // modified in place, value now [2, 10, 21]

for (index, age) in ages.enumerated() { // "-ed" noun returns a copy
  print("\(index). \(age)") // 1. 2 \n 2. 10 \n 3. 21
}
```
## Function Types
在之前的语法中，省略了圆括号让参数在哪里结束和返回值在哪里开始变得很难懂
```swift
func g(a: Int -> Int) -> Int -> Int  { ... } // old way, Swift 2
```
现在变成了这样：
```swift
func g(a: (Int) -> Int) -> (Int) -> Int  { ... } // new way, Swift 3

// old way, Swift 2
Int -> Float
String -> Int
T -> U
Int -> Float -> String

// new way, Swift 3
(Int) -> Float
(String) -> Int
(T) -> U
(Int) -> (Float) -> String

```
## API Additions
增加了几个有用的 API
### Accessing the Containing Type
当你使用类方法或者类属性时，之前都必须像这样做：
```swift
CustomStruct.staticMethod()
```
现在可以使用首字母大写的 `Self`来代替以前的写法，并且用类的实例也能调用类方法或者类属性了：
```swift
struct CustomStruct {
  static func staticMethod() { ... }

  func instanceMethod()
    Self.staticMethod() // in the body of the type
  }
}

let customStruct = CustomStruct()
customStruct.Self.staticMethod() // on an instance of the type
```
### Inline Sequences
有2个新方法`sequence(first:next:)`和`sequence(first:next:)`返回无穷大的顺序序列，除非 next 返回 nil。
```swift
for view in sequence(first: someView, next: { $0.superview }) {
    // someView, someView.superview, someView.superview.superview, ...
}
```
还可以使用`prefix`来约束条件
```swift
for x in sequence(first: 0.1, next: { $0 * 2 }).prefix(while: { $0 < 4 }) {
  // 0.1, 0.2, 0.4, 0.8, 1.6, 3.2
}
```
具体查看[ [SE-0045]:](https://github.com/apple/swift-evolution/blob/master/proposals/0045-scan-takewhile-dropwhile.md)

## Miscellaneous Odds and Ends
- `#keyPath()`和`#selector() `类似，可以帮助你防止错误字在使用字符串类型 API 时
- 使用`pi`可以获得圆周率，具体请看[ [SE-0067]](https://github.com/apple/swift-evolution/blob/master/proposals/0067-floating-point-protocols.md)
- NS 前缀被取消，`Date`替代`NSDate`
## Improvements to Tooling
Swift3 提高了提示错误和警告信息的精准度，并且他的运行和编译速度也更快了：
- 通过改进字符串 hashing 提高了3倍速度在字符串字典中
- 通过将对象从堆移到栈中提高了24倍速度（在某些情况下）
- 编译器可以一次缓存很多文件
- 减小了编译后的大小

## The Swift Package Manager
你也许会使用 Cocoapods 或者 Cocoapods，Swift 包管理将会下载依赖，编译他们然后链接在一起来创建库和可执行文件。
## Planned Future Features
Swift3 不会马上包含 ABI。ABI 其实是一个二进制接口，比 API 更底层，ABI 的作用就是不管 Swift 怎么迭代，你还是可以一直使用老版本 Swift 编译的第三方库。

> 这篇文章同时发布在我的 [Git](https://github.com/KieSun/StudyNote) 上,这个项目我会更新一些平时学习的资源和笔记，有兴趣的朋友可以 Watch 一下，本篇文章如有哪里翻译的不对，请各位指出！
