//
//  PublicAPI.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/20.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "PublicAPI.h"

@implementation PublicAPI


/**
 设置请求的NSMutableURLRequest和请求方式
 
 @param path 请求的路径
 @param requestMethod 请求的方式
 @return 设置好的NSMutableURLRequest
 */
+(NSMutableURLRequest *)setupURLRequestAndPath:(NSString *)path param:(id)param requestMethod:(NSString *)requestMethod
{
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if ([requestMethod isEqualToString:@"POST"]) {
        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    }
    request.timeoutInterval = 200;
    request.HTTPMethod = requestMethod;
    return request;
}


/**
 发起session请求
 
 @param urlRequest 要访问的NSMutableURLRequest
 @param success 访问成功的回调
 @param failure 访问失败的回调
 */
+(void)httpSession:(NSMutableURLRequest *)urlRequest success:(void(^)(id responseOjb))success failure:(void(^)(NSError *))failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            success(dict);
        }
    }] resume];
}

+(void)requestForRegister:(NSString *)user_phone user_password:(NSString *)user_password callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/register",IPAdress];
    
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:[NSString stringWithFormat:@"username=%@&password=%@&user_phone=%@",nil,user_password,user_phone]  requestMethod:@"POST"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForLoginUser_phone:(NSString *)user_phone userpassword:(NSString *)user_password callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/login",IPAdress];
    
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:[NSString stringWithFormat:@"username=%@&password=%@&user_phone=%@",nil,user_password,user_phone] requestMethod:@"POST"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForPitchParam:(id)param callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/pitch",IPAdress];
    
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:param requestMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForCloseStallParam:(id)param callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/closeStall",IPAdress];
    
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:param requestMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForQueryAllStallInfo:(NSDictionary *)params Callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/queryAllUserInfo",IPAdress];
    NSString *param = [NSString stringWithFormat:@"letfUpCoorlatitude=%@&letfUpCoorlongitude=%@&rightUpCoorlatitude=%@&rightUpCoorlongitude=%@&leftDownCoorlatitude=%@&leftDownCoorlongitude=%@&rightDownCoorlatitude=%@&rightDownCoorlongitude=%@",params[@"letfUpCoorlatitude"],params[@"letfUpCoorlongitude"],params[@"rightUpCoorlatitude"],params[@"rightUpCoorlongitude"],params[@"leftDownCoorlatitude"],params[@"leftDownCoorlongitude"],params[@"rightDownCoorlatitude"],params[@"rightDownCoorlongitude"]];
    
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:param requestMethod:@"POST"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForUpdateLocation:(NSDictionary *)params callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/updateLocation?user_coorLatitude=%@&user_coorLongtitude=%@&user_phone=%@",IPAdress,params[@"user_coorLatitude"],params[@"user_coorLongtitude"],params[@"user_phone"]];
    NSLog(@"path = %@",path);
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:nil requestMethod:@"GET"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForJudeDeadlineToken:(NSString *)token callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/judgeDeadLine",IPAdress];
    NSString *param = [NSString stringWithFormat:@"user_token=%@",token];
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:param requestMethod:@"POST"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForStoreReceiptToServerToken:(NSString *)token receipt:(NSString *)receipt purchase_date:(NSString *)purchase_date expires_date:(NSString *)expires_date buy_frequency:(NSString *)buy_frequency transaction_id:(NSString *)transaction_id  callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/IAPReceiptStore",IPAdress];
    NSString *param = [NSString stringWithFormat:@"user_token=%@&receipt=%@&purchase_date=%@&expires_date=%@&buy_frequency=%@&transaction_id=%@",token,receipt,purchase_date,expires_date,buy_frequency,transaction_id];
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:param requestMethod:@"POST"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForCheckUpExpires_dateToken:(NSString *)user_token callback:(ZFCallBack)callback
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/checkExpires_date",IPAdress];
    NSString *param = [NSString stringWithFormat:@"user_token=%@",user_token];
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:param requestMethod:@"POST"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
        callback(responseOjb);
    } failure:^(NSError *error) {
        callback(error.localizedDescription);
    }];
}

+(void)requestForVerify
{
    NSString *path = [NSString stringWithFormat:@"http://%@:8080/MoveStall/verifyReceipt",IPAdress];
//    NSString *param = [NSString stringWithFormat:@"user_token=%@",user_token];
    NSMutableURLRequest *request = [PublicAPI setupURLRequestAndPath:path param:nil requestMethod:@"GET"];
    [PublicAPI httpSession:request success:^(id responseOjb) {
//        callback(responseOjb);
    } failure:^(NSError *error) {
//        callback(error.localizedDescription);
    }];
}

@end
