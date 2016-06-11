# Avoiding the overuse of @objc in Swift

> [文章链接](http://www.jessesquires.com/avoiding-objc-in-swift/?utm_campaign=Swift%2BSandbox&utm_medium=web&utm_source=Swift_Sandbox_45)

### Don't let Objective-C cramp your style
在 Swift 2.2中,在协议扩展中使用`#selector`需要加上`@objc`,在之前的`Selector("method:")`中是不需要的.

### Configuring view controllers with protocol extensions
如果每个控制器都有模型和一个 Cancel 按钮,并且点击按钮方法都是定制的,我们可以使用结构体和扩展来复用.
```swift
struct ViewModel {
    let title: String
}
protocol ViewControllerType: class {
    var viewModel: ViewModel { get set }

    func didTapCancelButton(sender: UIBarButtonItem)
}
extension ViewControllerType where Self: UIViewController {
    func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: Selector("didTapCancelButton:"))
    }
}
```
现在我们可以让控制器遵循这个协议,然后在`viewDidLoad`中调用方法.
```swift
class MyViewController: UIViewController, ViewControllerType {
    var viewModel = ViewModel(title: "Title")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }

    func didTapCancelButton(sender: UIBarButtonItem) {
        // handle tap
    }
}
```
### When @objc tries to ruin everything
只要在协议扩展中使用`#selector`,那么会遇到3个问题:

- 继承这个协议的协议都会自动`@objc`
- 这个协议继承的协议都必须标记`@objc`
- 协议里用到了结构体,但是结构体是不能标记`@objc`

### Stop @objc from making everything horrible
我们现在可以通过拆分`ViewControllerType`来解决这个问题
```swift
extension NavigationItemConfigurable where Self: UIViewController {
    func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: #selector(didTapCancelButton(_:)))
    }
}

protocol ViewModelConfigurable {
    var viewModel: ViewModel { get set }
}

@objc protocol NavigationItemConfigurable: class {

    func didTapCancelButton(sender: UIBarButtonItem)
}
typealias ViewControllerType = protocol<ViewModelConfigurable, NavigationItemConfigurable>
```

> 总结:如果在协议扩展中使用了`#selector`,那么可以将需要加`@objc`关键字的方法单独拿出来写一个协议,然后通过`typealias`来组成协议(如果需要的话),这样就可以解决.

