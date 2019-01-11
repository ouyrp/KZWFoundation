//
//  ELMRouter.m
//  ELMRouter
//
//  Created by 0oneo on 4/20/15.
//  Copyright (c) 2015 0oneo. All rights reserved.
//

#import "ELMRouter.h"

static BOOL isBlank(NSString *);
static NSDictionary *paramsFromQueryString(NSString *);
static NSString *removeQueryString(NSString *);
static UINavigationController *wrapperControllerInNav(Class naviClass, UIViewController *viewController);

///////////////////////////////////////////////////////////////////////////

@interface ELMRouterOptions ()

@property (nonatomic, strong) Class openClass;
@property (nonatomic, copy) ELMRouterOpenCallback callback;

@end

@implementation ELMRouterOptions

+ (instancetype)routerOptionsWithModal:(BOOL)isModal {
    ELMRouterOptions *inConstructInstance = [[self alloc] init];
    inConstructInstance.modal = isModal;
    return inConstructInstance;
}

+ (instancetype)routerOptions {
    return [self routerOptionsWithModal:NO];
}

+ (instancetype)routerOptionsAsModal {
    return [self routerOptionsWithModal:YES];
}

@end


///////////////////////////////////////////////////////////////////////////

@interface ELMRouterParams : NSObject

@property (nonatomic, strong) ELMRouterOptions *routerOptions;
@property (nonatomic, strong) NSDictionary *routerParams;

@end

@implementation ELMRouterParams

@end


///////////////////////////////////////////////////////////////////////////

@interface ELMRouter ()

// Map of URL format NSString -> RouterOptions
// i.e. { "user" -> RouterOptions }
@property (nonatomic, strong) NSMutableDictionary *routes;

@end

#define ROUTE_NOT_FOUND_FORMAT @"No route found for URL %@"

#define ROUTE_ALREADY_EXIST_FORMAT @"Route %@ already exists"

#define KEY_NOT_FOUND_FORMAT @"Your controller class %@'s params must contains key %@"

@implementation ELMRouter

+ (instancetype)sharedRouter {
    static ELMRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (UIViewController *)hostViewController {
    if (!_hostViewController) {
        return [self window].rootViewController;
    }
    return _hostViewController;
}

- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *)vc)visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *)vc)selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

#define HINT_TEXT @"class you give is %@, but the class must be subclass of `UINavigationController`"
- (void)setNavigationClass:(Class)navigationClass {
    if (_navigationClass == navigationClass) {
        return;
    }
    if (![navigationClass isSubclassOfClass:[UINavigationController class]]) {
        [NSException raise:@"navigation class is not right" format:HINT_TEXT, navigationClass];
    }
    _navigationClass = navigationClass;
}
#undef HINT_TEXT

- (void)map:(NSString *)url toCallback:(ELMRouterOpenCallback)callback {
    NSString *key = [self keyForUrl:url];
    if (isBlank(key) || !callback) {
        [NSException raise:@"RouteNotProvided" format:@"Route #url is not initialized"];
    }

    ELMRouterOptions *options = [ELMRouterOptions routerOptions];
    options.callback = callback;
    [self addRouteOptions:options forKey:key];
}

- (void)map:(NSString *)url toController:(Class)controllerClass {
    [self map:url toController:controllerClass withOptions:nil];
}

- (void)map:(NSString *)url toController:(Class)controllerClass withOptions:(ELMRouterOptions *)options {
    NSString *key = [self keyForUrl:url];
    if (isBlank(key) || !controllerClass) {
        [NSException raise:@"RouteNotProvided" format:@"Route #url is not initialized"];
    }

    if (!options) {
        options = [ELMRouterOptions routerOptions];
    }
    options.openClass = controllerClass;
    [self addRouteOptions:options forKey:key];
}

- (void)clearAllMaps {
    [self.routes removeAllObjects];
}

- (UIViewController *)controllerForUrl:(NSString *)url {
    ELMRouterParams *routerParams = [self routerParamsForUrl:url];
    if (routerParams.routerOptions.openClass == nil) {
        return nil;
    }
    return [self controllerForRouterParams:routerParams];
}

- (void)open:(NSString *)url {
    [self open:url animated:YES];
}

- (void)open:(NSString *)url animated:(BOOL)animated {
    [self open:url animated:animated showStyle:ELMPageShowStyleCustom];
}

- (void)open:(NSString *)url animated:(BOOL)animated showStyle:(ELMPageShowStyle)showStyle {
    ELMRouterParams *routerParams = [self routerParamsForUrl:url];
    ELMRouterOptions *routerOptions = routerParams.routerOptions;
    if (routerOptions.callback) {
        routerOptions.callback(routerParams.routerParams);
        return;
    }
    UIViewController *controller = [self controllerForRouterParams:routerParams];

    if (!self.hostViewController) {
        [NSException raise:@"HostViewControllerNotProvided"
                    format:@"Router#hostViewController has not been set to a UINavigationController instance"];
    }

    // find the NavigationController through the hostViewController
    UINavigationController *hostNav = nil;
    UIViewController *visibleController = [self getVisibleViewControllerFrom:self.hostViewController];
    hostNav = visibleController.navigationController;

    UINavigationController *wrappedNav = wrapperControllerInNav(self.navigationClass, controller);

    // if the navigationController is nil, then just present;
    if (!hostNav) {
        [visibleController presentViewController:wrappedNav animated:animated completion:nil];
        return;
    }

    switch (showStyle) {
        case ELMPageShowStyleCustom:
            if (routerOptions.isModal) {
                [hostNav.visibleViewController presentViewController:wrappedNav animated:animated completion:nil];
            } else {
                [hostNav pushViewController:controller animated:animated];
            }
            return;
        case ELMPageShowStyleModal: {
            [hostNav.visibleViewController presentViewController:wrappedNav animated:animated completion:nil];
            return;
        }
        case ELMPageShowStylePush:
            [hostNav pushViewController:controller animated:animated];
            return;
        default:
            [NSException raise:@"not supporte here" format:@"Not Support here, pls check"];
            return;
    }
}

#pragma mark - private methods

- (UIWindow *)window {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    return window;
}

- (void)addRouteOptions:(ELMRouterOptions *)routeOptions forKey:(NSString *)key {
    ELMRouterOptions *old = self.routes[key];
    if (old) {
        [NSException raise:@"RouteAlreadyFoundException" format:ROUTE_ALREADY_EXIST_FORMAT, key];
    }
    [self.routes setObject:routeOptions forKey:key];
}

- (ELMRouterParams *)routerParamsForUrl:(NSString *)url {
    NSString *key = [self keyForUrl:removeQueryString(url)];

    if (isBlank(key) || !self.routes[key]) {
        [NSException raise:@"RouteNotFoundException" format:ROUTE_NOT_FOUND_FORMAT, url];
    }

    ELMRouterParams *routerParams = [ELMRouterParams new];
    routerParams.routerOptions = self.routes[key];

    if ([url rangeOfString:@"?"].location == NSNotFound) {
        return routerParams;
    }

    NSString *queryString = [url substringFromIndex:[url rangeOfString:@"?"].location + 1];
    NSDictionary *params = paramsFromQueryString(queryString);
    routerParams.routerParams = params;

    return routerParams;
}

- (NSString *)keyForUrl:(NSString *)url {
    //[\\w+|/]([\\w]+/?)* used to match /xxx/xxx/ or xxx/xxx/
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[\\w+|/]([\\w]+/?)*"];
    if (![myTest evaluateWithObject:url]) {
        return nil;
    }

    if ([url hasPrefix:@"/"]) { // just for convenience
        url = [url substringFromIndex:1];
    }
    return url;
}

/**
 * will support custom initiator, and if you don't want to custom the initiation process, we will 
 * assure you that the view controller's params will be properly set by the time the view controller's
 * view is loaded.
 *
 * @param params the params is used to construct a view controller
 *
 * @return an properly set view controller either through initiator or KVC.
 * @exception RouteKeyNotFoundException Thrown if ViewController required Key not found.
 */
- (UIViewController *)controllerForRouterParams:(ELMRouterParams *)params {
    Class controllerClass = params.routerOptions.openClass;
    id instanceInConstruct = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    if ([controllerClass respondsToSelector:@selector(elm_requiredKeys)]) {
        NSSet *requiredKeys = [controllerClass performSelector:@selector(elm_requiredKeys)];
        for (NSString *key in requiredKeys) {
            if (!params.routerParams[key]) {
                [NSException raise:@"RouteKeyNotFoundException" format:KEY_NOT_FOUND_FORMAT, controllerClass, key];
            }
        }
    }

    if ([controllerClass instancesRespondToSelector:@selector(initWithParams:)]) {
        instanceInConstruct = [controllerClass alloc];
        [instanceInConstruct performSelector:@selector(initWithParams:) withObject:params.routerParams];
    } else {
        instanceInConstruct = [[controllerClass alloc] init];
        [instanceInConstruct performSelector:@selector(setElm_params:) withObject:params.routerParams];
    }
#pragma clang diagnostic pop
    return instanceInConstruct;
}

@end


///////////////////////////////////////////////////////////////////////////

BOOL isBlank(NSString *string) {
    if (!string) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

NSDictionary *paramsFromQueryString(NSString *queryString) {
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        if ([pairComponents count] > 1) {
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            @try {
                [queryStringDictionary setObject:value forKey:key];
            }
            @catch (NSException *exception) {
#ifdef DEBUG
                NSLog(@"Got exception: %@    Reason: %@", exception.name, exception.reason);
                NSLog(@"key is %@,value is %@", key, value);
#endif
            }
        }
    }
    return queryStringDictionary.count > 0 ? queryStringDictionary : nil;
}

NSString *removeQueryString(NSString *url) {
    NSUInteger location = [url rangeOfString:@"?"].location;
    if (location != NSNotFound) {
        url = [url substringToIndex:location];
    }
    return url;
}

UINavigationController *wrapperControllerInNav(Class naviClass, UIViewController *viewController) {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)viewController;
    } else {
        if (naviClass) {
            return [[naviClass alloc] initWithRootViewController:viewController];
        }
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    }
}
