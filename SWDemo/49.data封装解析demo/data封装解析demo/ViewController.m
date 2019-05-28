//
//  ViewController.m
//  data封装解析demo
//
//  Created by 杨建亮 on 2019/1/31.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test1];

    [self test2];
}

-(void)test1
{
    NSMutableData *dataM = [NSMutableData data];
    
    NSString *head = @"head123";
    NSData *data1 = [head dataUsingEncoding:NSUTF16StringEncoding];
    [dataM appendData:data1];
    
    //int转data
    int j = ntohl(100869123); //高低位转换    不然1 的结果是 1 0 0 0
    NSData *data2 = [NSData dataWithBytes: &j length: sizeof(100869123)];
    [dataM appendData:data2];
    
    char *headhead;
    uint32_t num;
    
    [dataM getBytes:&headhead range:NSMakeRange(0, 1)];
    [dataM getBytes:&num range:NSMakeRange(7, sizeof(uint32_t))];
    
    NSUInteger lenC = sizeof(char);//char一个字节
    NSUInteger lenInt = sizeof(uint32_t);//uint32_t占用四个字节
    
    char *data_out1 = (unsigned char *)[[dataM subdataWithRange:NSMakeRange(0, 7) ] bytes];
    uint32_t data_out2 = CFSwapInt32BigToHost(num);
    
    NSLog(@"==%s==%u",data_out1,data_out2);
}
-(void)test2
{
    NSString *str = @"head123";
    NSString *utf16 = [self hexStringFromString:str];
    
    NSString *utf8 = [self stringFromHexString:utf16];
    NSLog(@"%@==%@",utf16,utf8);

}


// 十六进制转换为普通字符串
- (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
}
//普通字符串转十六进制字符串
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

//data转为十六进制字符串
-(NSString *)HexStringWithData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;
}
//十六进制字符串转data
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
//    1. 字符串转Data
//    NSString * str =@"str";
//    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];

//    2.NSData 转NSString
//    NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

//    3.data 转char
//    NSData *data;
//    char * haha=[data bytes];
//
//    4. char 转data
//    byte * byteData = malloc(sizeof(byte)*16);
//    NSData *content=[NSData dataWithBytes:byteData length:16];


//    //4字节表示的int
//    NSData *intData = [data subdataWithRange:NSMakeRange(2, 4)];
//    int value = CFSwapInt32BigToHost(*(int*)([intData bytes]));//655650
//    //2字节表示的int
//    NSData *intData = [data subdataWithRange:NSMakeRange(4, 2)];
//    int value = CFSwapInt16BigToHost(*(int*)([intData bytes]));//290
//    //1字节表示的int
//    char *bs = (unsigned char *)[[data subdataWithRange:NSMakeRange(5, 1) ] bytes];
//    int value = *bs;//34


@end
