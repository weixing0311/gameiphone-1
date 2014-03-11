//
//  GameCommon.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "GameCommon.h"
#import <AdSupport/AdSupport.h>
#import "Reachability.h"
#import "AppDelegate.h"

@implementation GameCommon

static GameCommon *my_gameCommon = NULL;

@synthesize wow_realms;

- (id)init
{
    self = [super init];
    if (self) {

        self.deviceToken = @"";
        self.connectTimes = 3;
        
        self.wow_realms = [NSMutableDictionary dictionaryWithCapacity:1];
        self.wow_clazzs = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

+ (GameCommon*)shareGameCommon
{
    @synchronized(self)
    {
		if (my_gameCommon == nil)
		{
			my_gameCommon = [[self alloc] init];
		}
	}
	return my_gameCommon;
}

+(float)diffHeight:(UIViewController *)controller
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        return 0.0f;
    } else {
        // Load resources for iOS 7 or later
        if (controller) {
            [controller setNeedsStatusBarAppearanceUpdate];
        }
        
        return 20.0f;
    }
}

+ (NSString*)getNewStringWithId:(id)oldString//剔除json里的空格字段
{
    if (oldString) {
        oldString = [NSString stringWithFormat:@"%@", oldString];
        if(![oldString isEqualToString:@" "])
            return oldString;
        else
            return @"";
    }
    else{
        return @"";
    }
}

#pragma mark - 汉字转为拼音
-(NSString *)convertChineseToPinYin:(NSString *)chineseName
{
    NSMutableString * theName = [NSMutableString stringWithString:chineseName];
    CFRange range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformToLatin, NO);
    range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformStripCombiningMarks, NO);
    NSString * dd = [theName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return dd;
}

#pragma mark - 联网默认字段
-(NSString*) uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);

    NSString *uuid =  [[NSString  alloc]initWithCString:CFStringGetCStringPtr(uuid_string_ref, 0) encoding:NSUTF8StringEncoding];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-"withString:@""];
    CFRelease(uuid_string_ref);
    
    return uuid;
}

- (NSMutableDictionary*)getNetCommomDic
{
    NSMutableDictionary* commomDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [commomDic setObject:version forKey:@"version"];
    
    if ([appType isEqualToString:@"91"]) {
        [commomDic setObject:@"2" forKey:@"channel"];
    }
    else
        [commomDic setObject:@"1" forKey:@"channel"];
    [commomDic setObject:[self uuid] forKey:@"sn"];//流水号
    
    if ([[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]) {
        [commomDic setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"mac"];
    }
    else
        [commomDic setObject:@"" forKey:@"mac"];
    [commomDic setObject:@"iphone" forKey:@"imei"];

    [commomDic setObject:@"0" forKey:@"isEncrypt"];//是否加密
    [commomDic setObject:@"0" forKey:@"isCompression"];//是否压缩

    return commomDic;
}

#pragma mark -计算字符串长度
-(NSUInteger) unicodeLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2)
    {
        unicodeLength++;
    }
    return unicodeLength;
}

-(NSUInteger) asciiLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

#pragma mark -验证邮箱
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    
    return [predicate evaluateWithObject:email];
}

#pragma mark -首页显示时间格式
+(NSString *)getCurrentTime{
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",nowTime];
    
}
#pragma mark -周
+(NSString *)getWeakDay:(NSDate *)datetime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:datetime];
    switch ([comps weekday]) {
        case 1:
            return @"周日";break;
        case 2:
            return @"周一";break;
        case 3:
            return @"周二";break;
        case 4:
            return @"周三";break;
        case 5:
            return @"周四";break;
        case 6:
            return @"周五";break;
        case 7:
            return @"周六";break;
        default:
            return @"未知";break;
    }
}
#pragma mark -时间
+(NSString *)CurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSString * finalTime;
    int theCurrentT = [currentTime intValue];
    int theMessageT = [messageTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
//    int msgHour = [[msgT substringToIndex:2] intValue];
    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
    // NSLog(@"hours:%d,minutes:%d",hours,minutes);
    int currentDayBegin = theCurrentT-hours*3600-minutes*60;
    int yesterdayBegin = currentDayBegin-3600*24;
//    int qiantianBegin = yesterdayBegin-3600*24;
    int oneWeekBegin = yesterdayBegin - 6 * 24 *3600;
    //今天
    if ([currentStr isEqualToString:messageDateStr]) {
//        if (msgHour>0&&msgHour<11) {
//            finalTime = [NSString stringWithFormat:@"早上 %@",msgT];
//        }
//        else if (msgHour>=11&&msgHour<13){
//            finalTime = [NSString stringWithFormat:@"中午 %@",msgT];
//        }
//        else if(msgHour>=13&&msgHour<18) {
//            finalTime = [NSString stringWithFormat:@"下午 %@",msgT];
//        }
//        else{
//            finalTime = [NSString stringWithFormat:@"晚上 %@",msgT];
//        }
        finalTime = [NSString stringWithFormat:@"%@",msgT];
    }
    //昨天
    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
//        if (msgHour>0&&msgHour<11) {
//            finalTime = @"昨天早上";
//        }
//        else if (msgHour>=11&&msgHour<13){
//            finalTime = @"昨天中午";
//        }
//        else if(msgHour>=13&&msgHour<18) {
//            finalTime = @"昨天下午";
//        }
//        else{
//            finalTime = @"昨天晚上";
//        }
        finalTime = @"昨天";
    }
    //一周以内
    else if (theMessageT-oneWeekBegin < 7 * 24 * 3600)
    {
        NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:theMessageT];
        NSString * weekday = [GameCommon getWeakDay:msgDate];
      
        finalTime = [NSString stringWithFormat:@"%@",weekday];
    }
//    //今年
//    else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
//        finalTime = [NSString stringWithFormat:@"%@月%@日",[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8]];
//    }
//    else
//    {
//        finalTime = messageDateStr;
//    }
    else
        finalTime = [NSString stringWithFormat:@"%@-%@-%@",[[messageDateStr substringFromIndex:2] substringToIndex:2] ,[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8]];

    // NSLog(@"finalTime:%@",finalTime);
    return finalTime;
}

+ (NSString*)getTimeWithMessageTime:(NSString*)messageTime
{
    NSString* currentString = [GameCommon getCurrentTime];
    if ([NSString stringWithFormat:@"%.f", [messageTime doubleValue]].length < 10 || [NSString stringWithFormat:@"%.f", [currentString doubleValue]].length < 10) {
        return @"未知";
    }
    NSString * finalTime;
    NSString* curStr = [currentString substringToIndex:messageTime.length-3];
    NSString* mesStr = [messageTime substringToIndex:messageTime.length-3];
    
    double theCurrentT = [curStr doubleValue];
    double theMessageT = [mesStr doubleValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    int msgHour = [[msgT substringToIndex:2] intValue];
    int msgmin = [[msgT substringFromIndex:3] intValue];
//    int msgDay = [[messageDateStr substringFromIndex:8] intValue];

    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
//    int day = [[currentStr substringFromIndex:8] intValue];

//    int currentDayBegin = theCurrentT-hours*3600-minutes*60;
//    int yesterdayBegin = currentDayBegin-3600*24;

    //今天
    if ([currentStr isEqualToString:messageDateStr] && msgHour == hours) {
        if (minutes-msgmin<=0) {
            finalTime = @"1分钟前";
        }
        else{
            finalTime = [NSString stringWithFormat:@"%d分钟前",(minutes-msgmin)];
        }
    }
    else if ([currentStr isEqualToString:messageDateStr]) {
           finalTime = [NSString stringWithFormat:@"%d小时前",(hours-msgHour)];
    }
    //昨天
//    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
//        finalTime = @"昨天";
//    }
    else
    {
        if ((theCurrentT-theMessageT)/86400 <= 0) {
            finalTime = @"1天前";
        }
        else
            finalTime = [NSString stringWithFormat:@"%.f天前",(theCurrentT-theMessageT)/86400];
    }
    return finalTime;

}

- (NSString*)getDataWithTimeInterval:(NSString*)timeInterval
{
    if ([NSString stringWithFormat:@"%.f", [timeInterval doubleValue]].length < 10) {
        return timeInterval;
    }
    NSString* timeStr = [timeInterval substringToIndex:timeInterval.length-3];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    double time = [timeStr doubleValue];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]);
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}


+ (NSString*)getTimeAndDistWithTime:(NSString*)time Dis:(NSString*)distrance
{
    double dis = [distrance doubleValue];
    double gongLi = dis/1000;

    NSString* allStr = @"";
    if (gongLi < 0 || gongLi == 9999) {//距离-1时 存的9999000
        allStr = [allStr stringByAppendingFormat:@"未知 | %@" , [GameCommon getTimeWithMessageTime:time]];
    }
    else
       allStr = [allStr stringByAppendingFormat:@"%.2fkm | %@", gongLi , [GameCommon getTimeWithMessageTime:time]];
    
    return allStr;
}

#pragma mark 动态时间格式
+(NSString *)dynamicListCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    int theCurrentT = [currentTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if ([messageDateStr isEqualToString:currentStr]) {
        return @"今天";
    }
    if ([[messageDateStr substringToIndex:8] isEqualToString:[currentStr substringToIndex:8]]&&[[currentStr substringFromIndex:8]intValue] -[[messageDateStr substringFromIndex:8] intValue] == 1) {
        return @"昨天";
    }
    return [messageDateStr substringFromIndex:5];
}
+(NSString *)DynamicCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    
    NSString * finalTime;
    int theCurrentT = [currentTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSString *chaStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT - theMessageT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if ([messageDateStr isEqualToString:currentStr]) {
        int hours = [[nowT substringToIndex:2] intValue];
        int msgHour = [[msgT substringToIndex:2] intValue];
        if (msgHour == hours) {
            int minutes = [[nowT substringFromIndex:3] intValue];
            int msgMin = [[msgT substringFromIndex:3] intValue];
            if (msgMin == minutes) {
                finalTime = @"1分钟内";
            }else{
                finalTime = [NSString stringWithFormat:@"%d分钟前",minutes - msgMin];
            }
        }else{
            finalTime = [NSString stringWithFormat:@"%d小时前",hours - msgHour];
        }
    }else if([[messageDateStr substringToIndex:7] isEqualToString:[currentStr substringToIndex:7]]){
        int msgDay = [[messageDateStr substringFromIndex:8] integerValue];
        int day = [[currentStr substringFromIndex:8] integerValue];
        finalTime = [NSString stringWithFormat:@"%d天前",day - msgDay];
    }else if([[chaStr substringToIndex:7] isEqualToString:@"1970-01"]){
        int day = [[chaStr substringFromIndex:8] integerValue];
        finalTime = [NSString stringWithFormat:@"%d天前",day];
    }else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
        int msgMonth = [[[messageDateStr substringToIndex:7] substringFromIndex:5]integerValue];
        int month = [[[currentStr substringToIndex:7] substringFromIndex:5]integerValue];
        finalTime = [NSString stringWithFormat:@"%d月前",month - msgMonth];
    }else{
        finalTime = messageDateStr;
    }
    return finalTime;
}

#pragma mark - 获得头衔字色
+(UIColor*)getAchievementColorWithLevel:(NSUInteger)level
{
    UIColor* color;
    switch (level) {
        case 1:
            color = kColorWithRGB(227, 53, 0, 1.0);//红色
            break;
        case 2:
            color = kColorWithRGB(225, 73, 21, 1.0);//橙色
            break;
        case 3:
            color = kColorWithRGB(103, 4, 146, 1.0);//紫色
            break;
        case 4:
            color = kColorWithRGB(0, 153, 255, 1.0);//蓝色
            break;
        case 5:
            color = kColorWithRGB(14, 132, 0, 1.0);//绿色
            break;
        case 6:
            color = kColorWithRGB(102, 102, 102, 1.0);//灰色
            break;
        default:
            break;
    }
    return color;
}

#pragma mark 获得头像
+ (NSString*)getHeardImgId:(NSString*)img
{
    if ([img isEqualToString:@""] || [img isEqualToString:@" "]) {
        return @"";
    }
    NSArray* arr = [img componentsSeparatedByString:@","];
    if ([arr count] != 0) {
        return [arr objectAtIndex:0];
    }
    return @"";
}

#pragma mark tabBar小红点
-(void)displayTabbarNotification
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:haveMyNews])
    {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:haveMyNews] isEqualToString:@"0"]) {
            [[Custom_tabbar showTabBar] notificationWithNumber:NO AndTheNumber:0 OrDot:YES WithButtonIndex:3];
        }
        else
        {
            [[Custom_tabbar showTabBar] removeNotificatonOfIndex:3];
        }
    }
    else
    {
        [[Custom_tabbar showTabBar] removeNotificatonOfIndex:3];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:haveFriendNews]) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:haveFriendNews] isEqualToString:@"0"]) {
            [[Custom_tabbar showTabBar] notificationWithNumber:NO AndTheNumber:0 OrDot:YES WithButtonIndex:2];
        }
        else
        {
            [[Custom_tabbar showTabBar] removeNotificatonOfIndex:2];
        }
    }
    else
    {
        [[Custom_tabbar showTabBar] removeNotificatonOfIndex:2];
    }
}

#pragma mark 粉丝数变化
- (void)fansCountChanged:(BOOL)addOne
{
    NSString* fansCout = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FansCount]) {
        fansCout = [[NSUserDefaults standardUserDefaults] objectForKey:FansCount];
    }
    NSInteger fansInt = addOne ? [fansCout integerValue] + 1 : [fansCout integerValue] - 1;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", fansInt] forKey:FansCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 注销
+ (void)loginOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:isFirstOpen];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FansCount];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:haveMyNews];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:haveFriendNews];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:PhoneNumKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [SFHFKeychainUtils deleteItemForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
    [SFHFKeychainUtils deleteItemForUsername:PASSWORD andServiceName:LOCALACCOUNT error:nil];
    [SFHFKeychainUtils deleteItemForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil];
    
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    TempData * tempData = [TempData sharedInstance];
    tempData.myUserID = nil;
    
    [app.xmppHelper disconnect];
}

#pragma mark 是否由1.0版本升级
+ (void)cleanLastData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLastVersion] && [[[NSUserDefaults standardUserDefaults] objectForKey:kLastVersion] floatValue] > 1.0) {
        NSLog(@"当前版本大于1.0");
    }
    else
    {
        [DataStoreManager deleteAllCommonMsg];
        [DataStoreManager deleteAllHello];
    }
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:kLastVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
