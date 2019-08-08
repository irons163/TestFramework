//
//  IRCommonTools.m
//  IRCommonTools
//
//  Created by Phil on 2019/7/16.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCommonToolsImp.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#include <arpa/inet.h>
#include <ifaddrs.h>

@implementation WifiInfoClass

@synthesize bssid;
@synthesize ssid;
@synthesize ssidData;

@end

@implementation LocalIPInfoClass

@synthesize currentInterfaceIP;
@synthesize wifiIP;
@synthesize cellularIP;

@end

@implementation IRCommonTools

#pragma mark - Library Info

+ (NSString*)getLibraryVersion{
    return @"1.0.1511180";
}

#pragma mark - About System

+ (NSInteger)getIosVersionNumber{
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    return [[vComp objectAtIndex:0] intValue];
}

+ (NSString*)getIosVersionString{
    UIDevice * device = [UIDevice currentDevice];
    return [device systemVersion];
}

+ (CGRect)getScreenSize{
    CGRect rtnRect;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat setHeight = screenHeight;
    CGFloat setWidth = screenWidth;
    
    if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft
       || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
    {//if landscape mode , switch width and height
        setHeight = screenWidth;
        setWidth = screenHeight;
    }
    
    rtnRect = CGRectMake(0, 0, setWidth, setHeight);
    return rtnRect;
}

#pragma mark - About Network
+ (NetworkStatus)detectNetworkInterface{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    return [reachability currentReachabilityStatus];
}

+ (WifiInfoClass*)fetchWifiInfo{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *SSIDInfo = nil;
    
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    
    if (SSIDInfo) {
        WifiInfoClass* wifiInfo = [WifiInfoClass new];
        wifiInfo.bssid = [SSIDInfo objectForKey:@"BSSID"];
        wifiInfo.ssid = [SSIDInfo objectForKey:@"SSID"];
        wifiInfo.ssidData = [SSIDInfo objectForKey:@"SSIDDATA"];
        return wifiInfo;
    }
    
    return nil;
}

+ (LocalIPInfoClass*)getLocalIPInfo{
    NSString* wifiAddress = nil;
    NSString* cellAddress = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    wifiAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    cellAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    LocalIPInfoClass* localIPInfo = [LocalIPInfoClass new];
    localIPInfo.wifiIP = wifiAddress;
    localIPInfo.cellularIP = cellAddress;
    if (wifiAddress) {
        localIPInfo.currentInterfaceIP = wifiAddress;
        return localIPInfo;
    }
    
    localIPInfo.currentInterfaceIP = cellAddress;
    return localIPInfo;
}

+(NSString*)getIPNetworkSegment:(NSString *)ip WithSubnetMask:(NSString *)subnetMask{
    if ([ip rangeOfString:@"."].location == NSNotFound || [subnetMask rangeOfString:@"."].location == NSNotFound) {
        return nil;
    }
    
    NSArray* ipArray = [[IRCommonTools fixIPFormate:ip] componentsSeparatedByString:@"."];
    NSArray* maskArray = [[IRCommonTools fixIPFormate:subnetMask] componentsSeparatedByString:@"."];
    
    if ([ipArray count] !=4 || [maskArray count] != 4) {
        return  nil;
    }
    
    NSMutableArray* segmentArray = [NSMutableArray array];
    
    for (int i = 0; i < [ipArray count]; i++) {
        int ipOctet = [ipArray[i] intValue];
        int maskOctet = [maskArray[i] intValue];
        int segmentOctet = (ipOctet & maskOctet);
        [segmentArray addObject:[NSString stringWithFormat:@"%d",segmentOctet]];
    }
    
    return [NSString stringWithFormat:@"%@.%@.%@.%@",segmentArray[0],segmentArray[1],segmentArray[2],segmentArray[3]];
}

+(NSString*)getIPBroadcast:(NSString *)ip WithSubnetMask:(NSString *)subnetMask{
    if ([ip rangeOfString:@"."].location == NSNotFound || [subnetMask rangeOfString:@"."].location == NSNotFound) {
        return nil;
    }
    
    NSArray* ipArray = [[IRCommonTools fixIPFormate:ip] componentsSeparatedByString:@"."];
    NSArray* maskArray = [[IRCommonTools fixIPFormate:subnetMask] componentsSeparatedByString:@"."];
    
    if ([ipArray count] !=4 || [maskArray count] != 4) {
        return  nil;
    }
    
    NSMutableArray* broadcastArray = [NSMutableArray array];
    
    for (int i = 0; i < [ipArray count]; i++) {
        int ipOctet = [ipArray[i] intValue];
        int maskOctet = [maskArray[i] intValue];
        int broadcastOctet = (ipOctet | (255 - maskOctet));
        [broadcastArray addObject:[NSString stringWithFormat:@"%d",broadcastOctet]];
    }
    
    return [NSString stringWithFormat:@"%@.%@.%@.%@",broadcastArray[0],broadcastArray[1],broadcastArray[2],broadcastArray[3]];
}

#pragma mark - About Image
+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)circleImage:(UIImage *)image withParm:(CGFloat)inset{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect=CGRectMake(inset, inset, image.size.width-inset*2.0f, image.size.height-inset*2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef tmp = CGImageCreateWithImageInRect(imageToCrop.CGImage, rect);
    UIImage *timage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    return timage;
}

+ (UIImage*)imageWithColor:(UIColor *)color Size:(CGSize)size{
    CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - About Convert
+(NSString *)decToBinary:(NSInteger)decInt
{
    NSString *string = @"" ;
    NSInteger x = decInt ;
    do {
        string = [[NSString stringWithFormat: @"%zd", x&1] stringByAppendingString:string];
    } while (x >>= 1);
    return string;
}

#pragma mark - About Format Check
+(BOOL)checkIsAllDigits:(NSString*)str{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [str rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

+ (BOOL)checkUIDFormateValid:(NSString *)uid{
    if (!uid)
        return NO;
    
    if (uid.length != 7)
        return NO;
    
    if ([[uid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 7)
        return NO;
    
    if ([uid rangeOfString:@" "].location != NSNotFound)
        return NO;
    
    if (![NSURL URLWithString:[NSString stringWithFormat:@"%@.domain.com",uid]])
        return NO;
    
    return YES;
}

+ (BOOL)checkEmailFormateValid:(NSString *)mail{
    BOOL stricterFilter=YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

+(WPAInvalidType)checkWPAKeyValid:(NSString *)key{
    if (key) {
        if (key.length < 8) {
            return InvalidWPALengthType;
        }
        
        if (key.length > 64) {
            return InvalidWPALengthType;
        }
        
        if (key.length == 64) {
            if (![IRCommonTools regularCheck:@"^([a-f]|[A-F]|[0-9]){64}$" checkStr:key]) {
                return  InvalidWPAHEXType;
            }
        }else{
            if (![IRCommonTools regularCheck:@"^(\\d|\\D){8,63}$" checkStr:key]) {
                return InvalidWPAASCIIType;
            }
        }
        
        return ValidWPAType;
    }
    return InvalidWPALengthType;
}

+(WEPInvalidType)checkWEPKeyValid:(NSString *)key{
    WEPInvalidType type = ValidWEPType;
    
    if (key.length == 5 || key.length == 13) {
        if (![IRCommonTools regularCheck:[NSString stringWithFormat:@"^(\\d|\\D){%zd}$",key.length] checkStr:key]) {
            type = InvalidWEPASCIIType;
        }
    }else if (key.length == 10 || key.length == 26){
        if (![IRCommonTools regularCheck:[NSString stringWithFormat:@"[a-fA-F0-9]{%zd}",key.length] checkStr:key]) {
            type = InvalidWEPHEXType;
        }
    }else{
        type = InvalidWEPLengthType;
    }
    
    return type;
}

+(BOOL)checkSubnetMaskBinary:(NSArray*)subnetMaskArray
{
    if ([subnetMaskArray count] != 4) {
        return NO;
    }
    
    NSMutableString* binString = [[NSMutableString alloc] initWithString:@""];
    
    for (int i=0; i<4; i++) {
        if (![IRCommonTools checkIsAllDigits:subnetMaskArray[i]]) {
            return NO;
        }
        
        int num = [subnetMaskArray[i] intValue];
        
        if (num < 0 || num > 255) {
            return NO;
        }
        
        NSMutableString* zeroString = [[NSMutableString alloc] initWithString:@""];
        NSString* numBinString = [IRCommonTools decToBinary:num];
        if (numBinString.length < 8) {
            for (int j=0; j < (8-numBinString.length); j++) {
                [zeroString appendFormat:@"0"];
            }
        }
        [binString appendFormat:@"%@",zeroString];
        [binString appendFormat:@"%@",numBinString];
    }
    
    if (binString.length == 0) {
        return NO;
    }
    
    return [IRCommonTools regularCheck:@"^1*0*$" checkStr:binString];
}

+(BOOL)checkSubnetMaskValid:(NSString *)subnetMask{
    if ([IRCommonTools checkHasFullWidthWord:subnetMask]) {
        return NO;
    }
    
    NSArray* strArray = [[IRCommonTools fixIPFormate:subnetMask] componentsSeparatedByString:@"."];
    if (![IRCommonTools checkSubnetMaskBinary:strArray]) {
        return NO;
    }
    return [IRCommonTools regularCheck:@"((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}0" checkStr:[IRCommonTools fixIPFormate:subnetMask]];
}

+(BOOL)checkPortValid:(NSInteger)port MinValue:(NSInteger)minValue MaxValue:(NSInteger)maxValue{
    if (port > maxValue || port < minValue) {
        return NO;
    }
    return YES;
}

+(BOOL)checkIPV4AddressValid:(NSString *)ipaddr{
    if ([IRCommonTools checkHasFullWidthWord:ipaddr]) {
        return NO;
    }
    return [IRCommonTools regularCheck:@"^(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])$" checkStr:[IRCommonTools fixIPFormate:ipaddr]];
}

+(BOOL)checkStaticIPInfo:(NSString *)ip Type:(StaticIPInfoType)type{
    
    if (!ip) {
        return NO;
    }
    
    if ([IRCommonTools checkHasFullWidthWord:ip]) {
        return NO;
    }
    
    if ([[IRCommonTools fixIPFormate:ip] isEqualToString:@"0.0.0.0"]) {
        switch (type) {
            case StaticIPInfoIPType:
            {
                return NO;
            }
                break;
            case StaticIPInfoGatewayType:
            {
                return YES;
            }
                break;
        }
    }
    
    NSArray* numArray = [[IRCommonTools fixIPFormate:ip] componentsSeparatedByString:@"."];
    if (numArray.count != 4) {
        return NO;
    }
    
    for (int i=0; i<4; i++) {
        if (![IRCommonTools checkIsAllDigits:numArray[i]]) {
            return NO;
        }
        
        int digit = [numArray[i] intValue];
        if (digit < 0) {
            return NO;
        }
        if (digit > 255) {
            return NO;
        }
        
        if (i == 0) {
            if (digit < 1 || digit > 223) {
                return NO;
            }
        }
        
        if (i == 3) {
            if (digit < 1 || digit > 254) {
                return NO;
            }
        }
    }
    
    if (![IRCommonTools checkIPV4AddressValid:ip]) {
        return NO;
    }
    
    if ([[IRCommonTools getIPNetworkSegment:@"127.0.0.1" WithSubnetMask:@"255.0.0.0"] isEqualToString:[IRCommonTools getIPNetworkSegment:ip WithSubnetMask:@"255.0.0.0"]]) {
        return NO;
    }
    
    if ([[IRCommonTools getIPNetworkSegment:@"169.254.0.1" WithSubnetMask:@"255.255.0.0"] isEqualToString:[IRCommonTools getIPNetworkSegment:ip WithSubnetMask:@"255.255.0.0"]]) {
        return NO;
    }
    
    if ([IRCommonTools regularCheck:@"^(22[4-9]|2[3-4][0-9]|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])$" checkStr:ip]) {
        return NO;
    }
    
    return YES;
}

+(BOOL)checkHostnameValid:(NSString *)hostname{
    return [IRCommonTools regularCheck:@"^[a-zA-Z0-9]\\w{0,30}$" checkStr:hostname];
}

+(BOOL)checkHasFullWidthWord:(NSString*)string{
    return [IRCommonTools regularCheck:@"[^\\x00-\\xff]" checkStr:string];
}

+(BOOL)regularCheck:(NSString*)pattern checkStr:(NSString*)checkStr{
    if (!checkStr || checkStr.length == 0) {
        return NO;
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if ([pred evaluateWithObject: checkStr]){
        return YES;
    }else{
        return NO;
    }
}

+(NSString*)fixIPFormate:(NSString*)ip{
    //    example: 10.0.053.122 -- replace to -- > 10.0.53.122
    NSArray* tokArray = [ip componentsSeparatedByString:@"."];
    NSMutableString* retString = [[NSMutableString alloc] initWithString:@""];
    
    for (int i = 0; i<tokArray.count; i++) {
        NSString* lastOneString=(i==tokArray.count-1)?@"":@".";
        NSString* tok = tokArray[i];
        if (tok.length >= 2) {
            if ([[tok substringToIndex:1] isEqualToString:@"0"])
                tok = [NSString stringWithFormat:@"%d",tok.intValue];
        }
        [retString appendString:tok];
        [retString appendString:lastOneString];
    }
    
    return retString;
}

#pragma mark - About Web View
+ (void)loadDocument:(NSString*)documentName inView:(UIWebView*)documentWebView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [documentWebView loadRequest:request];
}

+ (void)loadDocument:(NSString *)documentName withType:(NSString *)type inView:(UIWebView *)documentWebView{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [documentWebView loadRequest:request];
}

+ (void)loadDocumentPath:(NSString *)path inView:(UIWebView *)documentWebView{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [documentWebView loadRequest:request];
}

#pragma mark - About Version Number
+ (BOOL)checkVersionNumber:(NSString *)version isNewerThan:(NSString *)standardVersion{
    if ([standardVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkVersionNumber:(NSString *)version isLowerThan:(NSString *)standardVersion{
    if ([standardVersion compare:version options:NSNumericSearch] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkVersionNumber:(NSString *)version isSameWith:(NSString *)standardVersion{
    if ([standardVersion compare:version options:NSNumericSearch] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

#pragma mark - About Geocode
//Reverse Geocode with google API
+(void)reverseGeocodeLocation:(CLLocationCoordinate2D)location Language:(GoogleSuppotLanguages)language CompleteHandler:(void (^)(NSString *, NSError *))completionHandler
{
    NSString* googleLanguageKey = nil;
    switch (language) {
        case Englisg:
        {
            googleLanguageKey = @"en";
        }
            break;
        case Chinese_Traditional:
        {
            googleLanguageKey = @"zh-TW";
        }
            break;
        case Chinese_Simplified:
        {
            googleLanguageKey = @"zh-CN";
        }
            break;
        case System_Auto:
        {
            googleLanguageKey = nil;
        }
            break;
    }
    
    if (googleLanguageKey) {
        NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&language=%@",location.latitude,location.longitude,googleLanguageKey];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                completionHandler(nil,error);
            }else{
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"%s ==> %@",__PRETTY_FUNCTION__,json);
                NSArray* resultsArray = json[@"results"];
                if ([resultsArray count] > 0) {
                    NSDictionary* addressDictionary = resultsArray[0];
                    completionHandler(addressDictionary[@"formatted_address"],nil);
                }else{
                    completionHandler(nil,[error initWithDomain:json[@"status"]
                                                           code:200
                                                       userInfo:@{NSLocalizedDescriptionKey:json[@"error_message"]}]);
                }
            }
        }];
        [dataTask resume];
    }else{
        CLGeocoder *clGecoder = [[CLGeocoder alloc] init];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [clGecoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            NSLog(@"--array--%d---error--%@",(int)placemarks.count,error);
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                completionHandler([[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "],nil);
            }else{
                completionHandler(nil,error);
            }
        }];
    }
}

@end

