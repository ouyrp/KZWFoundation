//
//  ELMRouter.h
//  ELMRouter
//
//  Created by 0oneo on 4/20/15.
//  Copyright (c) 2015 0oneo. All rights reserved.
//

#import "UIViewController+ELMRouter.h"
#import <UIKit/UIKit.h>

typedef void (^ELMRouterOpenCallback)(NSDictionary *params);

typedef NS_ENUM(NSUInteger, ELMPageShowStyle) {
    ELMPageShowStyleCustom,
    ELMPageShowStylePush,
    ELMPageShowStyleModal
};

@interface ELMRouterOptions : NSObject

/**
 * The property determining if the mapped `UIViewController` should be opened modal or pushed in the navigation stack.
 * By default, the ViewController will be pushed by the NavigationController hold by ELMRouter.
 */
@property (nonatomic, getter=isModal) BOOL modal;

/**
 *  @return A new instance of `ELMRouterOptions`, setting a push.
 */
+ (instancetype)routerOptions;

/**
 *  @return A new instance of `ELMRouterOptions`, setting a modal;
 */
+ (instancetype)routerOptionsAsModal;

@end


@interface ELMRouter : NSObject

/**
 * The `UIViewController` instance which will be used to determine whether to push or present a
 * routed view controller, if the `hostViewController`'s navigationController is nil, the routed 
 * view controller will be presented, if the `hostViewController`'s navigationController is not nil, 
 * the push or modal behaviour will be dependent on `ELMRouterOptions` instance which you use when you 
 * map a view controller.
 * 
 * hostViewController 默认是window的root ViewController ，你可以设置为你认为合适的controller，当设置为nil时，重置为默认的控制器
 */
@property (nonatomic, strong) UIViewController *hostViewController;

/**
 *  The `navigationClass` is used to custom navigation controller which is used to wrap the content 
 *  View Controller you mapped to. And if you want to set this, it must be a sublclass of `UINavigationController`.
 */
@property (nonatomic, strong) Class navigationClass;

/**
 * Map a URL format to an anonymous callback
 * @param format A URL format (i.e. "user" or "logout")
 * @param callback The callback to run when the URL is triggered in `open:`
 */
- (void)map:(NSString *)url toCallback:(ELMRouterOpenCallback)callback;

/**
 * Map a URL format to a `UIViewController` class
 * @param url A URL format (i.e. "user" or "logout")
 * @param controllerClass The `UIViewController` class which will be instantiated when the URL is triggered in `open:`
 */
- (void)map:(NSString *)url toController:(Class)controllerClass;

/**
 * Map a URL format to a `UIViewController` class and `UPRouterOptions` options
 * @param url A URL format (i.e. "user" or "logout")
 * @param controllerClass The `UIViewController` class which will be instantiated when the URL is triggered in `open:`
 * @param options Configuration for the route, such as modal settings
 */
- (void)map:(NSString *)url toController:(Class)controllerClass withOptions:(ELMRouterOptions *)options;

/**
 *  clear all mappings
 */
- (void)clearAllMaps;

///-------------------------------
/// @name Get instances from URLs
///-------------------------------

/**
 *  return the mapped controller for the url
 *
 *  @param url A URL format (i.e. "user?id=xxxx" or "logout")
 *
 *  @return a `UIViewController` if the url to which the controller is mapped do exists, nil otherwise.
 */
- (UIViewController *)controllerForUrl:(NSString *)url;


///-------------------------------
/// @name Opening URLs
///-------------------------------

/**
 * Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 *
 * @param url The URL being opened (i.e. "user?id=xxx")
 */
- (void)open:(NSString *)url;

/**
 *  Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 *
 *  @param url      The URL being opened (i.e. "user")
 *  @param animated Whether or not `UIViewController` transitions are animated.
 
 */
- (void)open:(NSString *)url animated:(BOOL)animated;

/**
 *  Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 *
 *  @param url       The URL being opened (i.e. "user")
 *  @param animated  Whether or not `UIViewController` transitions are animated.
 *  @param showStyle The `ELMPageShowStyle` used to show the page
 */
- (void)open:(NSString *)url animated:(BOOL)animated showStyle:(ELMPageShowStyle)showStyle;

/**
 * A singleton instance of `ELMRouter` which can be accessed anywhere in the app.
 * @return A singleton instance of `ELMRouter`.
 */
+ (instancetype)sharedRouter;

@end
