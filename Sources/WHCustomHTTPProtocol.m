//
//  WHCustomHTTPProtocol.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHCustomHTTPProtocol.h"
#import "WHRequestModel.h"
#import "WHStorage.h"
#import "NSInputStream+Wormholy.h"

static NSArray<NSString *> *_ignoredHosts;

@interface WHCustomHTTPProtocol () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@property (nonatomic, strong) WHRequestModel *currentRequest;

@end

@implementation WHCustomHTTPProtocol

+ (void)setIgnoredHosts:(NSArray<NSString *> *)ignoredHosts {
    _ignoredHosts = ignoredHosts;
}

+ (NSArray<NSString *> *)ignoredHosts {
    return _ignoredHosts;
}

- (void)dealloc {
    self.session = nil;
    self.sessionTask = nil;
    self.currentRequest = nil;
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    if (self = [super initWithRequest:request cachedResponse:cachedResponse client:client]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    
    return self;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![self shouldHandleRequest:request]) {
        return NO;
    }
    
    if ([self propertyForKey:@"URLProtocolRequestHandled" inRequest:request] != nil) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)shouldHandleRequest:(NSURLRequest *)request {
    if (request.URL.host.length == 0) {
        return NO;
    }
    
    BOOL ignoredHost = NO;
    for (NSString *url in self.ignoredHosts) {
        if ([request.URL.host isEqual:url]) {
            ignoredHost = YES;
            break;
        }
    }
    
    return !ignoredHost;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSMutableURLRequest *newRequest = (NSMutableURLRequest *)((NSURLRequest *)self.request).mutableCopy;
    [WHCustomHTTPProtocol setProperty:@(YES) forKey:@"URLProtocolRequestHandled" inRequest:newRequest];
    self.sessionTask = [self.session dataTaskWithRequest:newRequest];
    [self.sessionTask resume];
    
    self.currentRequest = [[WHRequestModel alloc] initWithRequest:newRequest session:self.session];
    [[WHStorage sharedInstance] saveRequest:self.currentRequest];
}

- (void)stopLoading {
    [self.sessionTask cancel];
    self.currentRequest.httpBody = [self bodyFromRequest:self.request];
    NSDate *startDate = self.currentRequest.date;
    if (startDate != nil) {
        self.currentRequest.duration = fabs(startDate.timeIntervalSinceNow) * 1000;
    }
    
    [[WHStorage sharedInstance] saveRequest:self.currentRequest];
    [self.session invalidateAndCancel];
}

- (NSData *)bodyFromRequest:(NSURLRequest *)request {
    if (request.HTTPBody) {
        return request.HTTPBody;
    }
    
    return [request.HTTPBodyStream readfully];
}

#pragma mark - URLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    if (self.currentRequest.dataResponse == nil) {
        self.currentRequest.dataResponse = [NSMutableData dataWithData:data];
    } else {
        [self.currentRequest.dataResponse appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSURLCacheStoragePolicy policy = (NSURLCacheStoragePolicy)self.request.cachePolicy;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:policy];
    [self.currentRequest setupResponse:response];
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        self.currentRequest.errorClientDescription = error.localizedDescription;
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    if (completionHandler) {
        completionHandler(request);
    }
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    if (error == nil) {
        return;
    }
    
    self.currentRequest.errorClientDescription = error.localizedDescription;
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    id sender = challenge.sender;
    
    if (protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        if (protectionSpace.serverTrust) {
            NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:protectionSpace.serverTrust];
            [sender useCredential:credential forAuthenticationChallenge:challenge];
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            }
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    [self.client URLProtocolDidFinishLoading:self];
}
 
@end
