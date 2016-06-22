# [译] Swift Talk -- NetWorking

> 原文来自于 [objc.io](https://talk.objc.io/episodes/S01E01-networking#580)

## Transcript

0:01 我们来讨论下 Swift talk app 的网络层。我们认为这是个有趣的例子因为设计与之前的 Objective-C 项目不同。通常，我们将创建一个有初始化方法的`Webservice`类来呼叫一个特定的 endpoints 。这些方法返回从 endpoints 通过一个回调函数获得的数据。举个例子，我们可以有个网络请求的`loadEpisodes `方法，分析结果，初始化一些 `Episode `对象，并返回一个包含`Episode `的数组。我们同样可以有一个`loadMedia `方法，通过同样的步骤来夹在一个特定 episode 的 media：
```swift
final class Webservice {
    func loadEpisodes(completion: ([Episode]?) -> ()) {
        // TODO
    }

    func loadMedia(episode: Episode, completion: (Media?) -> ()) {
        // TODO
    }
}
```

> `final`可以用来修饰 class，func 或者 var ，修饰过后的内容不允许被重写或者继承。

0：50 在  Objective-C 中，这个方式的优点是回调结果有个正确的类型。举个例子，我们将获得一个 episodes 的数组而不仅仅是个`id`类型，因为这是一个从网络加载任何数据的方法。这个方式的优点是每个方法在幕后执行一个复杂任务：网络请求，分析数据，初始化一些 model 对象，最后通过回调返回他们。这里有很多地方会出错，正因为如何，调试是很难的。因为这些方法还是异步的，所以让他们更难调试。此外，我们需要一个网络栈设置或者模拟，这也使调试更复杂。在 Swift 中，有其他的方式来让这事简单化。

### The Resource Struct
1：51 我们创建一个`Resource `结构体，这是一个泛型类型。这个结构体有2个属性：endpoint 的 URL和`parse `函数。`parse `函数试图将一些数据转化为结果：
```swift
struct Resource<A> {
    let url: NSURL
    let parse: NSData -> A?
}
```

2:12 `parse`函数的返回类型是可选的因为分析可能失败。代替可选值，我们也可以使用`Result `类型或者使他抛出详细的错误信息。此外，如果我们只想处理 JSON，`parse`函数可以使用`AnyObject `来代替` NSData`。然而，使用`AnyObject `会阻止我们使用我们的`Resource `除了 JSON - 例如图片。

2：59 现在创建`episodesResource `。这只是一个返回` NSData`的简单 resource:
```swift
let episodesResource = Resource<NSData>(url: url, parse: { data in
    return data
})
```

3:33 最后，这个 resource 应该有一个`[Episode]`的 result 类型。我们将重构`parse `函数通过几个步骤将`NSData `的 result 改成`[Episode]`的 result 类型。

### The Webservice Class
3:58 从网上加载资源，我们创建一个`Webservice `类，他只有一个方法：`load`。这个方法是通用的，并将 resource 作为第一个参数。这二个参数是个闭包，使用 `A?`是因为请求有可能失败或者某些东西会出错。在` load`方法里，我们使用`NSURLSession.sharedSession()`来做请求。我们创建一个 data task 用从 resource 中获得的 URL。resource 捆绑了我们需要的所有做请求的信息。目前，只包含了 URL，但在将来会有更多的属性。在 data task 的回调里，我们使用 data 作为第一个参数。我们忽略其他2个参数。最后，开始 data task，我们调用` resume`：
```swift
final class Webservice {
    func load<A>(resource: Resource<A>, completion: (A?) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            if let data = data {
                completion(resource.parse(data))
            } else {
                completion(nil)
            }
        }.resume()
    }
}
```

5：38 调用闭包，我们不得不通过` parse`函数来将 data 转为资源的结果类型。因为 data 是可选的，我们使用可选绑定。如果 data 是` nil`,我们调用闭包使用` nil`。如果 data 不是` nil`,我们调用闭包使用` parse`函数。

6：22 因为我们运行在 playground,我们必须让他一直执行下去，否则，主线程完成就会停止：
```swift
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
```

7:00 我们创建一个`Webservice `实例然后调用` load`方法和`episodesResource `一起。在闭包里，我们输出 result:
```swift
Webservice().load(episodesResource) { result in
    print(result)
}
```

7: 18 在控制台中，我们可以看到一些原始的二进制数据。在我们继续之前，我们将重构` load`方法--我们不喜欢调用2次` completion`。我们尝试使用` guard let`。然而，我们还是调用了2次` completion`，还添加了返回语句：
```swift
final class Webservice {
    func load<A>(resource: Resource<A>, completion: (A?) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
        }.resume()
    }
}
```

8:07 使用` flatMap`是其他的办法。首先，我们尝试` map`。然而，`map`给我们了一个` A??`代替` A?`。使用` flatMap`将移除2个可选：
```swift
final class Webservice {
    func load<A>(resource: Resource<A>, completion: (A?) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            let result = data.flatMap(resource.parse)
            completion(result)
        }.resume()
    }
}
```

> `flatMap`可以去掉空值

### Parsing JSON
8：58 下一步我们改变`episodesResource `为了将` NSData`解析为 JSON 对象。我们使用内置的 JSON 解析。因为 JSON 解析会 throwing operation，我们使用` try?`来调用 parsing 方法：
```swift
let episodesResource = Resource<AnyObject>(url: url, parse: { data in
    let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
    return json
})
```

9:40 在侧边栏，我们可以看到二进制数据被解析。这是个字典数组，所以我们可以让结果类型更加明确。JSON 字典包含一个 `String`的 key 和`AnyObject`的 values：
```swift
typealias JSONDictionary = [String: AnyObject]

let episodesResource = Resource<[JSONDictionary]>(url: url, parse: { data in
    let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
    return json as? [JSONDictionary]
})
```

10:23 下一步是返回一个`Episode`数组，所以我们需要将 JSON 字典转化到`Episode`里。在初始化之前，我们添加一些属性到`Episode`里：`id`和` title`，都是` String`。在真实的项目里，这里有更多的属性：
```swift
struct Episode {
    let id: String
    let title: String
    // ...
}
```

11:13 我们现在在 extension 里写个可失败构造器。在这个 extension 里，我们保留了默认的成员逐一初始化。在这个构造器里，我们首先需要检查字典是否包含我们需要的数据。我们使用` guard`来做这件事，然后我们检查字典里的 `id`是否是` Srting`类型，取出` title`做相同的操作。如果 guard 失败，我们马上返回` nil`。如果成功，我们给 `id`和` title`赋值：
```swift
extension Episode {
    init?(dictionary: JSONDictionary) {
        guard let id = dictionary["id"] as? String,
            title = dictionary["title"] as? String else { return nil }
        self.id = id
        self.title = title
    }
}
```

12:48 我们现在重构`episodesResource `来返回一个`Episode`数组。首先，我们检查我们是否有个 JSON 字典。否则，我们马上返回` nil`。字典转化为 episodes,我们可以使用` map`并使用可失败` Episode.init`作为我们的转换函数。然而，构造器返回可选值，所以使用` map`结果是`[Episode?]`。但是我们不想在这里返回` nil`,应该是`[Episode]`。我们使用` flatMap`来修复这个问题。

![12:48 code](http://o8z6d6snk.bkt.clouddn.com/image/8/88/e6b12c03a452b34efd70d98363eb3.png)

14：18 在我们的项目里，`flatMap`的不同版本。`flatMap`会默认忽略不能解析的字典，我们想一旦字典无效就完全失败：
```swift
extension SequenceType {
    public func failingFlatMap<T>(@noescape transform: (Self.Generator.Element) throws -> T?) rethrows -> [T]? {
        var result: [T] = []
        for element in self {
            guard let transformed = try transform(element) else { return nil }
            result.append(transformed)
        }
        return result
    }
}
```

14:52 我们可以重构我们的` parse`函数来移除2个` return`。首先，我们尝试使用` guard`，但是这个不能移除2个`return`。然而，`guard`可以让我们摆脱嵌套：
```swift
let episodesResource = Resource<[Episode]>(url: url, parse: { data in
    let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
    guard let dictionaries = json as? [JSONDictionary] else { return nil }
    return dictionaries.flatMap(Episode.init)
})
```

15：28 我们尝试在`dictionaries `里使用 optional chaining来去除2次` return`：
```swift
let episodesResource = Resource<[Episode]>(url: url, parse: { data in
    let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
    let dictionaries = json as? [JSONDictionary]
    return dictionaries?.flatMap(Episode.init)
})
```

15:44 这开始变得难以理解。我们有一个可选的`dictionaries `然后我们使用 optional chaining 来调用` flatMap`,将可失败构造器作为参数。在这里，我们也许会用` guard`的版本，那个更加清晰。

### JSON Resources
16:07 一旦我们创建更多的 resources，必须复制 JSON 解析到每个 resources。移除这个复制，我们可以创建一个不同的 resources。然而，我们可以扩展现存的 resources 通过其他的构造器。这个构造器页使用 URL，但是 parse 函数类型是`AnyObject -> A?`。我们在包裹了这个 parse 函数在其他的`NSData -> A?`函数类型里并在这个闭包里从`episodesResource `里移除了 JSON 解析。因为解析 JSON 是可选的，我们可以使用`flatMap`来调用` parseJSON`:
```swift
extension Resource {
    init(url: NSURL, parseJSON: AnyObject -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}
```

18:00 现在我们可以使用新的构造器来改变我们的`episodesResource `：
```swift
let episodesResource = Resource<[Episode]>(url: url, parseJSON: { json in
    guard let dictionaries = json as? [JSONDictionary] else { return nil }
    return dictionaries.flatMap(Episode.init)
})
```

### Naming the Resources
18:17 另外一件我们不喜欢的事情是`episodesResource `在公共的命名空间。我们也不喜欢他的命名。我们可以将`episodesResource `移到`Episode `的扩展里作为一个类属性。我们将他重命名为`allEpisodesResource `。然而，我们还是不怎么喜欢这个名字。看看这个类型，很清楚的表明它属于`Episode `。从类型里也可以明白是一个 resource，所以我们为什么不仅仅命名为` call`？：

![18:17 code](http://o8z6d6snk.bkt.clouddn.com/image/b/bd/ffe27b7301d90fc5df55a6a553823.png)

```swift
Webservice().load(Episode.all) { result in
    print(result)
}
```

19:40 其实这是个危险的命名，也许你会和集合混淆。虽然我们不认为这是个问题，因为你试图使用集合会立即失败。

20：09 在`Episode `扩展中，我们也可以添加其他依赖于 episode 的属性的resources——例如，一个`media`resource，从指定的 episode 中获得 media。在` media` resource 中，我们可以使用字符串插入来组成 URL：
```swift
extension Episode {
    var media: Resource<Media> {
        let url = NSURL(string: "http://localhost:8000/episodes/\(id).json")!
        // TODO Return the resource ...
    }
}
```

21:18 如果我们在`Episode `结构体中需要更多的参数是无效的，我们可以改变 resource 属性作为一个方法然后直接传递参数。

21：27 我们喜欢这个网络请求的方式因为几乎所有的代码都是同步的。这很简单，很容易调试，而且我们也不需要设置网络栈或者调试一些东西。唯一异步的代码是`Webservice.load`方法。这个架构是个不错的例子对于 Swift 来说；Swift 的泛型和结构体让这样设计变得很简单。同样的事情在 OC 里是做不了的。

22：21 让我们添加` POST`支持在下一节。

> 这篇文章同时发布在我的 [Git](https://github.com/KieSun/StudyNote/blob/master/Note/Translation%20Article/[译]%20Swift%20Talk%20--%20NetWorking.md) 上,这个项目我会更新一些平时学习的资源和笔记，有兴趣的朋友可以 Watch 一下。


