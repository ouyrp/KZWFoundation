#FMWebViewJavascriptBridge

[![CI Status](http://img.shields.io/travis/carlSQ/FMWebViewJavascriptBridge.svg?style=flat)](https://travis-ci.org/carlSQ/FMWebViewJavascriptBridge)
[![Version](https://img.shields.io/cocoapods/v/FMWebViewJavascriptBridge.svg?style=flat)](http://cocoapods.org/pods/FMWebViewJavascriptBridge)
[![License](https://img.shields.io/cocoapods/l/FMWebViewJavascriptBridge.svg?style=flat)](http://cocoapods.org/pods/FMWebViewJavascriptBridge)
[![Platform](https://img.shields.io/cocoapods/p/FMWebViewJavascriptBridge.svg?style=flat)](http://cocoapods.org/pods/FMWebViewJavascriptBridge)

# 简介

FMWebViewJavascriptBridge inspired by [react native](https://github.com/facebook/react-native) 是一个轻量级的JavascriptBridge，只支持WKWebView iOS 8.0之后，与android原生调用保持一致。
![image](http://7xs4ye.com1.z0.glb.clouddn.com/jsbridge.png)


## how to Use

### 自定义 JavascriptInterface

* 自定义 JavascriptInterface 类
* 在暴露的接口前添加FM_EXPORT_METHOD宏
* 支持的参数可以是 nil NSNull NSString NSNumber NSDictionary NSArray NSDate char int double BOOL
* 同时支持返回值给Javascrip的回调， 回调的类型FMCallBack，支持参数同上

``` objective-c

@implementation JavascriptInterface

FM_EXPORT_METHOD(@selector(push:))
- (void)push:(NSUInteger)one {
  [self.viewController.navigationController
      pushViewController:[WKViewController new]
                animated:YES];
  NSLog(@"test push%ld", (unsigned long)one);
}

FM_EXPORT_METHOD(@selector(pop:))
- (void)pop:(NSString *)testArray {
  [self.viewController.navigationController popViewControllerAnimated:YES];
  NSLog(@"pop array %@", testArray);
}

FM_EXPORT_METHOD(@selector(setNavTitle:response:))
- (void)setNavTitle:(NSDictionary *)userInfo response:(FMCallBack)callBack {
  self.viewController.title = userInfo[@"name"];
  callBack(@{@"name":@"carlSQ",@"age":@"26"});
}

```

### 添加接口给javascript调用

用 FMWKWebViewBridge 类中的接口addJavascriptInterface 添加接口道javascrip层

``` objective-c
_webViewBridge = [FMWKWebViewBridge wkwebViewBridge:self.webView];
[_webViewBridge addJavascriptInterface:[JavascriptInterface new] withName:@"JavascripInterface"];

```

### js层调用

与android原生调用保持一致，addJavascriptInterface 会在js层注入一个对象，名字是addJavascriptInterface 中设置的名字

``` javascrip

<script>

JavascriptInterface.setNavTitle({"name" : "carl", age:"18"},function(responseData) {
                                     setNavTitle.innerHTML = "name:"+responseData.name +"  age:" + responseData.age;
                                     })

</script>

```

#Usage

```ruby
pod 'FMWebViewJavascriptBridge', '~> 3.0.0'
```

## Author

carl Shen

## License

FMWebViewJavascriptBridge is available under the MIT license. See the LICENSE file for more info.
