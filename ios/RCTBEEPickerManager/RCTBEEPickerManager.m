//
//  RCTBEEPickerManager.m
//  RCTBEEPickerManager
//
//  Created by MFHJ-DZ-001-417 on 16/9/6.
//  Copyright © 2016年 MFHJ-DZ-001-417. All rights reserved.
//

#import "RCTBEEPickerManager.h"
#import "BzwPicker.h"
#import "RCTEventDispatcher.h"

@interface RCTBEEPickerManager()

@property(nonatomic,strong)BzwPicker *pick;

@end

@implementation RCTBEEPickerManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(_init:(NSDictionary *)indic){
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        result = nextResponder;
    
    else
        
        result = window.rootViewController;
    
    NSString *pickerConfirmBtnText=indic[@"pickerConfirmBtnText"];
    NSString *pickerCancelBtnText=indic[@"pickerCancelBtnText"];
    NSString *pickerTitleText=indic[@"pickerTitleText"];
    NSArray *pickerConfirmBtnColor=indic[@"pickerConfirmBtnColor"];
    NSArray *pickerCancelBtnColor=indic[@"pickerCancelBtnColor"];
    NSArray *pickerTitleColor=indic[@"pickerTitleColor"];
    NSArray *pickerToolBarBg=indic[@"pickerToolBarBg"];
    NSArray *pickerBg=indic[@"pickerBg"];
    NSArray *selectArry=indic[@"selectedValue"];
    
    CGFloat ButtonFontSize=[indic[@"ButtonFontSize"] floatValue];
    CGFloat TitleFontSize=[indic[@"TitleFontSize"] floatValue];
    CGFloat ItemFontSize=[indic[@"ItemFontSize"] floatValue];
    NSArray *ItemFontColor=indic[@"ItemFontColor"];
    NSArray *ItemLineColor=indic[@"ItemLineColor"];
    
    
    
    id pickerData=indic[@"pickerData"];
    
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];
    
    dataDic[@"pickerData"]=pickerData;
    
    [result.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[BzwPicker class]]) {
            [obj removeFromSuperview];
        }
        
    }];
    
    self.pick=[[BzwPicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)
                                          dic:dataDic
                                      leftStr:pickerCancelBtnText
                                    centerStr:pickerTitleText
                                     rightStr:pickerConfirmBtnText
                                   topbgColor:pickerToolBarBg
                                bottombgColor:pickerBg
                               leftbtnbgColor:pickerCancelBtnColor
                              rightbtnbgColor:pickerConfirmBtnColor
                               centerbtnColor:pickerTitleColor
                               ButtonFontSize:ButtonFontSize
                                TitleFontSize:TitleFontSize
                                 ItemFontSize:ItemFontSize
                                ItemFontColor:ItemFontColor
                                ItemLineColor:ItemLineColor
                              selectValueArry:selectArry];
    
    _pick.bolock=^(NSDictionary *backinfoArry){
        
        [self.bridge.eventDispatcher sendAppEventWithName:@"pickerEvent" body:backinfoArry];
    };
    
    [result.view addSubview:_pick];
    
    [UIView animateWithDuration:.3 animations:^{
        
        [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250)];
        
    }];
    
}

RCT_EXPORT_METHOD(show){
    if (self.pick) {
        [UIView animateWithDuration:.3 animations:^{
            [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250)];
            
        }];
    }return;
}

RCT_EXPORT_METHOD(hide){
    
    if (self.pick) {
        [UIView animateWithDuration:.3 animations:^{
            [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
        }];
    }
    return;
}
RCT_EXPORT_METHOD(isPickerShow:(RCTResponseSenderBlock)getBack){
    
    if (self.pick) {
        
        CGFloat pickY=_pick.frame.origin.y;
        
        if (pickY==SCREEN_HEIGHT) {
            
            getBack(@[@YES]);
        }else
        {
            getBack(@[@NO]);
        }
    }else{
        getBack(@[@"picker不存在"]);
    }
}
- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end
