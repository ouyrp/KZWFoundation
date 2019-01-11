//
//  HttpManager.m
//  LPDCrowdsource
//
//  Created by eMr.Wang on 15/10/30.
//  Copyright © 2015年 elm. All rights reserved.
//

#import "LPDBHttpManager.h"
#import "ELMEnvironmentManager.h"
#import "ELMKeychainUtil.h"
#import "KZWConstants.h"
#import "UIApplication+ELMFoundation.h"
#import "UIApplication+ELMFoundation.h"

@implementation LPDBHttpManager

+ (AFHTTPSessionManager *)sharedRequestOperationManager {
    static AFHTTPSessionManager *_sharedRequestOperationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.URLCache = nil;
        _sharedRequestOperationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _sharedRequestOperationManager.requestSerializer = [AFJSONRequestSerializer new];
        _sharedRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedRequestOperationManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _sharedRequestOperationManager.requestSerializer.timeoutInterval = 15.0; // 超时限制
        _sharedRequestOperationManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData; // 忽略本地缓存
        _sharedRequestOperationManager.responseSerializer.acceptableContentTypes =
            [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
        [_sharedRequestOperationManager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [_sharedRequestOperationManager.requestSerializer setValue:[UIApplication elm_version] forHTTPHeaderField:@"version"]; // 版本
        [_sharedRequestOperationManager.requestSerializer setValue:@"AppStore" forHTTPHeaderField:@"channel"];
        [_sharedRequestOperationManager.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"os_version"];
        [_sharedRequestOperationManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"platform_type"];
        [_sharedRequestOperationManager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"device_id"];
        [_sharedRequestOperationManager.requestSerializer setValue:[UIApplication elm_userAgent] forHTTPHeaderField:@"User-Agent"];
    });
    [_sharedRequestOperationManager.requestSerializer setValue:[ELMKeychainUtil valueInKeyChainForKey:YQYFINANCIALLOGINTOKEN] ?: YQYFINANCIALLOGINTOKEN forHTTPHeaderField:YQYFINANCIALLOGINTOKEN];
    return _sharedRequestOperationManager;
}

+ (AFSecurityPolicy *)customSecurityPolicy {
    //  NSLog(@"security policy");

    /* 配置1：验证锁定的证书，需要在项目中导入eleme.cer根证书*/
    // /先导入证书

    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
        stringByAppendingPathComponent:@"/KZWFundation.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *cerPath = [resource_bundle pathForResource:@"kongzhongjr" ofType:@"cer"]; //证书的路径

    // NSLog(@"certPath  % @",cerPath);
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // NSLog(@"certData %@",certData);

    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;

    // validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，xn--www-u28dlq76gczcs1hq9jv9d939b73q0r2axe6d.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;

    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    /*配置1结束*/

    /* 配置2：一般的验证证书，允许信任（包括系统自带的和个人安装的）的证书库中证书签名的任何证书
     * 下面的配置可以验证HTTPS的证书。不过如果在iOS设备上安装了自建证书，那也会验证通过。
     * 如把抓包工具的证书安装在iOS设备上，仍然可以抓到HTTPS的数据包
     AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
     securityPolicy.allowInvalidCertificates = NO;
     securityPolicy.validatesDomainName = YES;
     mgr.securityPolicy = securityPolicy;
     配置2结束*/

    return securityPolicy;
}

+ (NSURLSessionDataTask *)GET:(NSString *_Nonnull)path
                   parameters:(nullable id)parameters
            completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete {
    return [[self sharedRequestOperationManager] GET:[[self baseUrl] stringByAppendingString:path] parameters:parameters progress:NULL success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)path
                    parameters:(id)parameters
                        images:(NSArray *)images
             completionHandler:(void (^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error))complete
                      progress:(void (^)(NSProgress *_Nonnull uploadProgress))progress {
    return [[self sharedRequestOperationManager] POST:[[self baseUrl] stringByAppendingString:path] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        if (!images) {
            return;
        }
        for (int i = 0; i < images.count; i++) {
            [formData appendPartWithFileData:images[i] name:@"files" fileName:[NSString stringWithFormat:@"pic_%d.png", i] mimeType:@"image/png"];
        }
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)path
                    parameters:(id)parameters
                         image:(UIImage *)image
                     imageName:(NSString *)imageName
             completionHandler:(void (^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error))complete
                      progress:(void (^)(NSProgress *_Nonnull uploadProgress))progress {
    return [[self sharedRequestOperationManager] POST:[[self baseUrl] stringByAppendingString:path] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        if (!image) {
            return;
        }
        NSData *fileData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:fileData name:@"files" fileName:imageName mimeType:@"image/png"];
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}


+ (NSURLSessionDataTask *)POST:(NSString *_Nonnull)path
                    parameters:(nullable id)parameters
             completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete {
    return [[self sharedRequestOperationManager] POST:[[self baseUrl] stringByAppendingString:path] parameters:parameters progress:NULL success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}


+ (NSURLSessionDataTask *)PUT:(NSString *_Nonnull)path
                   parameters:(nullable id)parameters
            completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete {
    return [[self sharedRequestOperationManager] PUT:[[self baseUrl] stringByAppendingString:path] parameters:parameters success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *_Nonnull)path
                      parameters:(nullable id)parameters
               completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete {
    return [[self sharedRequestOperationManager] DELETE:[[self baseUrl] stringByAppendingString:path] parameters:parameters success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}

+ (NSString *)baseUrl {
    switch ([ELMEnvironmentManager environment]) {
        case ELMEnvBeta:
            return @"xxxxxx";
            break;
        case ELMEnvAlpha:
            return @"xxxxxx";
            break;
        case ELMEnvProduction:
            return @"xxxxxx";
            break;
        default:
            return @"xxxxx";
            break;
    }
}

@end
