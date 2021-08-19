//
//  WHRequestModel.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHRequestModel.h"

@implementation WHRequestModel

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session {
    if (self = [super init]) {
        self.uuid = [[NSUUID UUID] UUIDString];
        self.url = request.URL.absoluteString;
        self.host = request.URL.host;
        self.port = request.URL.port;
        self.scheme = request.URL.scheme;
        self.date = [NSDate date];
        self.method = request.HTTPMethod ?: @"GET";
        self.credentials = [NSDictionary dictionary];
        self.httpBody = request.HTTPBody;
        self.code = 0;
        
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        if (request.allHTTPHeaderFields) {
            headers = [NSMutableDictionary dictionaryWithDictionary:request.allHTTPHeaderFields];
        }
        
        for (NSString *key in session.configuration.HTTPAdditionalHeaders.allKeys) {
            id value = [session.configuration.HTTPAdditionalHeaders valueForKey:key];
            [headers setValue:value forKey:key];
        }
        
        self.headers = headers;
        
        NSURLCredentialStorage *credentialStorage = session.configuration.URLCredentialStorage;
        NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:self.host
                                                                                      port:self.port.integerValue
                                                                                  protocol:self.scheme
                                                                                     realm:self.host authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
        
        NSArray<NSURLCredential *> *credentials = [credentialStorage credentialsForProtectionSpace:protectionSpace].allValues;
        for (NSURLCredential *credential in credentials) {
            if (credential.user.length != 0 && credential.password.length != 0) {
                [self.credentials setValue:credential.password forKey:credential.user];
            }
        }
        
        if (self.url.length > 0 && session.configuration.HTTPShouldSetCookies) {
            NSHTTPCookieStorage *cookieStorage = session.configuration.HTTPCookieStorage;
            NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:self.url]];
            NSString *cookiesString = @"";
            for (NSHTTPCookie *cookie in cookies) {
                [cookiesString stringByAppendingFormat:@"%@=%@;", cookie.name, cookie.value];
            }
            
            self.cookies = cookiesString;
        }
    }
    
    return self;
}

- (instancetype)initWithResponse:(NSURLResponse *)response {
    if (self = [super init]) {
        NSHTTPURLResponse *responseHttp = (NSHTTPURLResponse *)response;
        if (responseHttp) {
            self.code = responseHttp.statusCode;
            self.responseHeaders = responseHttp.allHeaderFields;
        }
    }
    
    return self;
}

- (void)setupResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *responseHttp = (NSHTTPURLResponse *)response;
    if (responseHttp) {
        self.code = responseHttp.statusCode;
        self.responseHeaders = responseHttp.allHeaderFields;
    }
}

- (NSString *)curlRequest {
    NSMutableArray *components = [NSMutableArray array];
    [components addObject:@"$ curl -v"];
    
    if (self.host.length == 0) {
        return @"$ curl command could not be created";
    }
    
    if (![self.method isEqualToString:@"GET"]) {
        NSString *string = [NSString stringWithFormat:@"-X %@", self.method];
        [components addObject:string];
    }
    
    for (NSString *key in self.headers.allKeys) {
        NSString *value = [self.headers valueForKey:key];
        NSString *escapedValue = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *string = [NSString stringWithFormat:@"-H \"%@: %@\"", key, escapedValue];
        [components addObject:string];
    }
    
    if (self.httpBody) {
        NSString *httpBody = [[NSString alloc] initWithData:self.httpBody encoding:NSUTF8StringEncoding];
        NSString *escapedBody = [httpBody stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        escapedBody = [escapedBody stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *string = [NSString stringWithFormat:@"-d \"%@\"", escapedBody];
        [components addObject:string];
    }
    
    for (NSString *key in self.credentials.allKeys) {
        NSString *value = [self.credentials valueForKey:key];
        NSString *string = [NSString stringWithFormat:@"-u %@: %@", key, value];
        [components addObject:string];
    }
    
    if (self.cookies.length > 0) {
        NSString *string = [NSString stringWithFormat:@"-b %@", self.cookies];
        [components addObject:string];
    }
    
    [components addObject:[NSString stringWithFormat:@"\"%@\"", self.url]];
    return [components componentsJoinedByString:@" \\\n\t"];
}

@end
