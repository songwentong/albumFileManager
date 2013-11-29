//
//  LeShowPhotoManageCenter.m
//  LeShow
//
//  Created by song on 13-11-6.
//  Copyright (c) 2013年 HTTD. All rights reserved.
//

#import "LeShowPhotoManageCenter.h"

@implementation LeShowPhotoManageCenter
//相册名字
#define kAlbumList @"kAlbumList"

//图片管理器文件夹
#define kPhotoManagerDir @"PhotoManagerDir"
//图片数组文件名
#define kListName  @"kListName"

/*
 
 文件结构
 
 NSHomeDir
 |
 V
 
 Documents
 
 |
 |
 |
 V
 
 PhotoManagerDir
 |
 |
 ----------------------------------
 |              |                 |
 V              V                 V
 
 album1         album2          album3
 (imagelist)    (imagelist)      (imagelist)
 
 */

//相册列表
-(NSArray*)albumList
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array = [myUserDefault objectForKey:kAlbumList];
    
    
    return array;
    
    
}
-(NSArray*)thumbUrlForAblum:(NSString*)album
{
    NSArray *albumList = [self photoURLForAlbum:album];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in albumList) {
        NSString *path = [NSString stringWithFormat:@"%@thumb",str];
        [array addObject:path];
    }
    return array;
}

//相册路径
-(NSString*)pathForAblum:(NSString*)album
{
    NSString *path = NSHomeDirectory();
    path = [NSString stringWithFormat:@"%@/Documents/%@/%@",path,kPhotoManagerDir,album];
    
    
    return path;
}


-(NSArray*)photoURLForAlbum:(NSString*)name
{
    NSArray *array = [self photoListFromAlbum:name];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *str in array) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/%@/%@/%@",NSHomeDirectory(),kPhotoManagerDir,name,str];
        [result addObject:path];
    }
    
    
    
    return result;
    
}


//相册名字列表
-(NSArray*)photoListFromAlbum:(NSString*)name
{
    NSString *path = NSHomeDirectory();
    path = [NSString stringWithFormat:@"%@/Documents/%@/%@/%@",path,kPhotoManagerDir,name,kListName];
    
    NSFileManager *manager  =[NSFileManager defaultManager];
    NSArray *array = [NSArray array];
    if ([manager fileExistsAtPath:path]) {
        array = [NSArray arrayWithContentsOfFile:path];
    }else
    {
        [array writeToFile:path atomically:YES];
    }
    return array;
}
#pragma mark - 图片处理

//添加相册
-(BOOL)addPhotoAlbums:(NSString*)name
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self albumList]];
    [array addObject:name];
    
    
    //    add a dir
    NSFileManager *manager = [NSFileManager defaultManager];
    
    
    NSString *managerDirPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),kPhotoManagerDir];
    BOOL flag = [manager fileExistsAtPath:managerDirPath];
    if (!flag) {
        [manager createDirectoryAtPath:managerDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //    exist
    
    
    NSString *albumPath = [NSString stringWithFormat:@"%@/%@",managerDirPath,name];
    BOOL success = [manager createDirectoryAtPath:albumPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    if (success) {
        
        
        
        
        
        NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
        [myUserDefault setObject:array forKey:kAlbumList];
        [myUserDefault synchronize];
    }
    return success;
    
}
//删除相册
-(BOOL)deleteAlbums:(NSString*)name
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self albumList]];
    [array removeObject:name];
    
    
    //    remove a dir
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *managerDirPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),kPhotoManagerDir];
    NSString *albumPath = [NSString stringWithFormat:@"%@/%@",managerDirPath,name];
    if ([manager fileExistsAtPath:albumPath]) {
        BOOL sucess = [manager removeItemAtPath:albumPath error:YES];
        if (sucess) {
            NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
            [myUserDefault setObject:array forKey:kAlbumList];
            [myUserDefault synchronize];
            return sucess;
        }else
        {
            
        }
    }
    return NO;
    
}

#pragma mark - 图片操作


//添加图片
-(void)addPhoto:(UIImage*)image toAlbum:(NSString*)name
{
    //    NSArray *albumListArray = [self listForAlbum:name];
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    __block BOOL arrayflag = NO;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSData *smallData = UIImageJPEGRepresentation(image, 0.0);
        NSMutableArray *photoNameArray = [[self photoListFromAlbum:name] mutableCopy];
        NSString *randname = [self getStringOutOfSet:[NSSet setWithArray:photoNameArray]];
        NSString *path = NSHomeDirectory();
        path = [NSString stringWithFormat:@"%@/Documents/%@/%@/%@",path,kPhotoManagerDir,name,randname];
        NSString *smallImagePath = [NSString stringWithFormat:@"%@thumb",path];
        __block BOOL flag = [data writeToFile:path atomically:YES];
        [smallData writeToFile:smallImagePath atomically:YES];
        if (flag) {
            
            [photoNameArray addObject:randname];
            
            path = [NSString stringWithFormat:@"%@/Documents/%@/%@/%@",NSHomeDirectory(),kPhotoManagerDir,name,kListName];
            
            
            
            
            
            [photoNameArray writeToFile:path atomically:YES];
            
            
        }
    }];
    
    
    [operation start];
    
    
    
    
    
}

-(NSString*)getStringOutOfSet:(NSSet*)set
{
    NSString *str = [NSString stringWithFormat:@"%ld",random()];
    if ([set containsObject:str]) {
        return [self getStringOutOfSet:set];
    }
    return str;
}
//删除图片
-(void)deletePhoto:(NSString*)imageName toAlbum:(NSString*)name
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *photoNameArray = [[self photoListFromAlbum:name] mutableCopy];
        if ([photoNameArray containsObject:imageName]) {
            [photoNameArray removeObject:imageName];
            NSString *path = [NSString stringWithFormat:@"%@/Documents/%@/%@/%@",NSHomeDirectory(),kPhotoManagerDir,name,kListName];
            [photoNameArray writeToFile:path atomically:YES];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            path =[NSString stringWithFormat:@"%@/Documents/%@/%@/%@",NSHomeDirectory(),kPhotoManagerDir,name,imageName];
            NSString *thumbPath = [NSString stringWithFormat:@"%@thumb",path];
            if ([manager fileExistsAtPath:path]) {
                [manager removeItemAtPath:path error:nil];
                
            }
            
            if ([manager fileExistsAtPath:thumbPath]) {
                [manager removeItemAtPath:thumbPath error:nil];
            }
        }
    }];
    [operation start];
    
}



#pragma mark - 单例必须方法
static LeShowPhotoManageCenter *sharedInstance = nil;
+ (LeShowPhotoManageCenter*)instance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _numberOfImageByte = 0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
