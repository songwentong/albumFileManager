//
//  LeShowPhotoManageCenter.h
//  LeShow
//  相册管理
//  Created by song on 13-11-6.
//  Copyright (c) 2013年 HTTD. All rights reserved.
//
/*
 
 功能：
 1.添加删除相册
 2.添加删除图片
 
 */
#import <Foundation/Foundation.h>

@interface LeShowPhotoManageCenter : NSObject
{
    
}
//图片下载的大小（单位：byte）
@property (nonatomic,assign) NSUInteger numberOfImageByte;

+ (LeShowPhotoManageCenter*)instance;

//相册列表
-(NSArray*)albumList;


//添加相册
-(BOOL)addPhotoAlbums:(NSString*)name;
//删除相册
-(BOOL)deleteAlbums:(NSString*)name;

//相册路径列表  （一个包含所有图片的路径的list）
-(NSArray*)photoURLForAlbum:(NSString*)name;
//相册名字列表
-(NSArray*)photoListFromAlbum:(NSString*)name;
//缩略图路径
-(NSArray*)thumbUrlForAblum:(NSString*)album;

//添加图片
-(void)addPhoto:(UIImage*)image toAlbum:(NSString*)name;
//删除图片
-(void)deletePhoto:(NSString*)imageName toAlbum:(NSString*)name;


@end
