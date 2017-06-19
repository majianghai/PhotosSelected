//
//  UJPProgressHUD.h
//  UJPin
//
//  Created by 赵英楠 on 15/12/22.
//  Copyright © 2015年 ujipin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface UJPProgressHUD : NSObject
{
    MBProgressHUD *HUD;
}


+(instancetype)shareHUD;

-(void)showMessage:(NSString *)text;
- (void)showMessageAfterLoadingFinish:(NSString *)text;

-(void)showLoading;
-(void)loadingFinish;

@end
