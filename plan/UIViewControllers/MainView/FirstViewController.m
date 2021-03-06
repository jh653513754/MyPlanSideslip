//
//  FirstViewController.m
//  plan
//
//  Created by Fengzy on 15/8/28.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "DataCenter.h"
#import "PlanCache.h"
#import "ShareCenter.h"
#import "ThreeSubView.h"
#import "UIButton+Util.h"
#import "WZLBadgeImport.h"
#import "FirstViewController.h"
#import "SettingsViewController.h"
#import "SideMenuViewController.h"
#import <RESideMenu/RESideMenu.h>

NSUInteger const kSecondsPerDay = 86400;


@interface FirstViewController () <UITextFieldDelegate> {
    
    ThreeSubView *nickNameView;
    ThreeSubView *liftetimeView;
    ThreeSubView *daysLeftView;
    ThreeSubView *secondsLeftView;
    UIView *statisticsView;
    ThreeSubView *everydayView;
    ThreeSubView *longtermView;
    UIView *shareLogoView;
    
    NSTimer *timer;
    NSInteger daysLeft;
    NSDate *deadDay;
    
    NSUInteger xMiddle;
    NSUInteger yOffset;
    NSUInteger ySpace;
}

@end

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = STRViewTitle1;
    self.tabBarItem.title = STRViewTitle1;
    [self createNavBarButton];
    
    [NotificationCenter addObserver:self selector:@selector(refreshView:) name:Notify_Settings_Save object:nil];
    [NotificationCenter addObserver:self selector:@selector(refreshView:) name:Notify_Plan_Save object:nil];
    [NotificationCenter addObserver:self selector:@selector(refreshRedDot) name:Notify_Messages_Save object:nil];
    
    [DataCenter setPlanBeginDate];
    
    [self loadCustomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkUnread:self.tabBarController.tabBar index:0];
    [self refreshRedDot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

- (void)createNavBarButton {
    self.leftBarButtonItem = [self createBarButtonItemWithNormalImageName:png_Btn_LeftMenu selectedImageName:png_Btn_LeftMenu selector:@selector(leftMenuAction:)];
    self.rightBarButtonItem = [self createBarButtonItemWithNormalImageName:png_Btn_Share selectedImageName:png_Btn_Share selector:@selector(shareAction)];
}

- (void)leftMenuAction:(UIButton *)button {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)shareAction {
    shareLogoView.hidden = NO;
    
    UIImage* image = [UIImage imageNamed:png_ImageDefault];
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO , 0.0f);//高清，效率比较慢
    {

        [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    shareLogoView.hidden = YES;
    
    [ShareCenter showShareActionSheet:self.view image:image];
}

- (void)refreshView:(NSNotification*)notification {
    [self loadCustomView];
}

- (void)refreshRedDot {
    //小红点
    if ([PlanCache hasUnreadMessages]) {
        [self.leftBarButtonItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        self.leftBarButtonItem.badgeCenterOffset = CGPointMake(-8, 0);
    } else {
        [self.leftBarButtonItem clearBadge];
    }
}

- (void)loadCustomView {
    //加载个人设置
    [Config shareInstance].settings = [PlanCache getPersonalSettings];
    
    //小红点
    [self refreshRedDot];
    
    [self createAvatar];
    [self createLabelText];
    [self createStatisticsView];
    [self createShareLogo];
}

- (void)createAvatar {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger avatarBgSize = WIDTH_FULL_SCREEN / 3;
    NSUInteger avatarSize = avatarBgSize - 6;
    xMiddle = WIDTH_FULL_SCREEN / 2;
    yOffset = iPhone4 ? HEIGHT_FULL_SCREEN / 28 : HEIGHT_FULL_SCREEN / 15;
    ySpace = HEIGHT_FULL_SCREEN / 25;
    
    UIImage *bgImage = [UIImage imageNamed:png_AvatarBg];
    UIImageView *avatarBg = [[UIImageView alloc] initWithFrame:CGRectMake(xMiddle - avatarBgSize / 2, yOffset, avatarBgSize, avatarBgSize)];
    avatarBg.backgroundColor = [UIColor clearColor];
    avatarBg.image = bgImage;
    avatarBg.layer.cornerRadius = avatarBgSize / 2;
    avatarBg.clipsToBounds = YES;
    avatarBg.userInteractionEnabled = YES;
    avatarBg.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSettingsViewController)];
    [avatarBg addGestureRecognizer:singleTap];
    [self.view addSubview:avatarBg];
    {
        UIImage *image = [UIImage imageNamed:png_AvatarDefault];
        if ([Config shareInstance].settings.avatar) {
            image = [UIImage imageWithData:[Config shareInstance].settings.avatar];
        }
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(ceilf((avatarBgSize - avatarSize)/2), ceilf((avatarBgSize - avatarSize)/2), avatarSize, avatarSize)];
        avatar.backgroundColor = [UIColor clearColor];
        avatar.image = image;
        avatar.layer.cornerRadius = avatarSize / 2;
        avatar.clipsToBounds = YES;
        avatar.contentMode = UIViewContentModeScaleAspectFit;
        
        [avatarBg addSubview:avatar];
    }
    
    yOffset += avatarBgSize + ySpace;
}

- (void)createLabelText {
    NSString *nickname = str_NickName;
    NSInteger lifetime = 100;
    CGFloat labelHeight = HEIGHT_FULL_SCREEN / 62;
    CGFloat labelWidth = WIDTH_FULL_SCREEN / 3 > 125 ? WIDTH_FULL_SCREEN / 3 : 125;

    if (![CommonFunction isEmptyString:[Config shareInstance].settings.nickname]) {
        nickname = [Config shareInstance].settings.nickname;
    }
    if (![CommonFunction isEmptyString:[Config shareInstance].settings.lifespan]) {
        NSString *life = [Config shareInstance].settings.lifespan;
        lifetime = [life integerValue];
    }
    
    __weak typeof(self) weakSelf = self;
    ThreeSubView *nickNameSubView = [[ThreeSubView alloc] initWithFrame:CGRectMake(xMiddle, yOffset, labelWidth, labelHeight)leftButtonSelectBlock:nil centerButtonSelectBlock:^{
        
        [weakSelf toSettingsViewController];
        
    } rightButtonSelectBlock:nil];
    
    [nickNameSubView.centerButton.titleLabel setFont:font_Bold_32];
    [nickNameSubView.centerButton setAllTitleColor:[CommonFunction getGenderColor]];
    [nickNameSubView.centerButton setAllTitle:nickname];
    [nickNameSubView autoLayout];
    
    [self.view addSubview:nickNameSubView];
    
    nickNameView = nickNameSubView;
    
    CGRect nickFrame = CGRectZero;
    nickFrame.size.width = nickNameView.frame.size.width;
    nickFrame.size.height = nickNameView.frame.size.height;
    nickFrame.origin.x = xMiddle - nickNameView.frame.size.width/2;
    nickFrame.origin.y = yOffset;
    
    nickNameView.frame = nickFrame;
    yOffset += nickNameView.frame.size.height + ySpace * 2;
    
    ThreeSubView *liftetimeSubView = [[ThreeSubView alloc] initWithFrame:CGRectMake(xMiddle, yOffset, labelWidth, labelHeight)leftButtonSelectBlock:nil centerButtonSelectBlock:nil rightButtonSelectBlock:nil];
    
    [liftetimeSubView.leftButton.titleLabel setFont:font_Normal_16];
    [liftetimeSubView.leftButton setAllTitleColor:color_Black];
    [liftetimeSubView.leftButton setAllTitle:str_FirstView_1];
    [liftetimeSubView.centerButton.titleLabel setFont:font_Normal_24];
    [liftetimeSubView.centerButton setAllTitleColor:color_Red];
    [liftetimeSubView.centerButton setAllTitle:[NSString stringWithFormat:@"%zd",lifetime]];
    [liftetimeSubView.rightButton.titleLabel setFont:font_Normal_16];
    [liftetimeSubView.rightButton setAllTitleColor:color_Black];
    [liftetimeSubView.rightButton setAllTitle:str_FirstView_2];
    [liftetimeSubView autoLayout];
    [self.view addSubview:liftetimeSubView];
    
    liftetimeView = liftetimeSubView;
    
    CGRect lifeFrame = CGRectZero;
    lifeFrame.size.width = liftetimeView.frame.size.width;
    lifeFrame.size.height = liftetimeView.frame.size.height;
    lifeFrame.origin.x = xMiddle - liftetimeView.frame.size.width/2;
    lifeFrame.origin.y = yOffset;
    
    liftetimeView.frame = lifeFrame;
    yOffset += liftetimeView.frame.size.height + ySpace;
    
    NSString *birthdayFormat = @"1987-03-05 00:00:00";
    if (![CommonFunction isEmptyString:[Config shareInstance].settings.birthday]) {
        birthdayFormat = [NSString stringWithFormat:@"%@ 00:00:00", [Config shareInstance].settings.birthday];
    }
    
    NSDate *birthday = [CommonFunction NSStringDateToNSDate:birthdayFormat formatter:str_DateFormatter_yyyy_MM_dd_HHmmss];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp = [calendar components:units fromDate:birthday];
    NSInteger year = [comp year];
    year += lifetime;
    [comp setYear:year];

    deadDay = [calendar dateFromComponents:comp];
    
    NSDate *now = [NSDate date];
    NSTimeInterval secondsBetweenDates= [deadDay timeIntervalSinceDate:now];
    if(secondsBetweenDates < 0) {
        daysLeft = 0;
    } else {
        daysLeft = secondsBetweenDates/kSecondsPerDay;
    }
    
    ThreeSubView *daysLeftSubView = [[ThreeSubView alloc] initWithFrame:CGRectMake(xMiddle, yOffset, labelWidth, labelHeight)leftButtonSelectBlock:nil centerButtonSelectBlock:nil rightButtonSelectBlock:nil];
    [daysLeftSubView.leftButton.titleLabel setFont:font_Normal_16];
    [daysLeftSubView.leftButton setAllTitleColor:color_Black];
    [daysLeftSubView.leftButton setAllTitle:str_FirstView_3];
    [daysLeftSubView.centerButton.titleLabel setFont:font_Normal_24];
    [daysLeftSubView.centerButton setAllTitleColor:color_Red];
    if (![CommonFunction isEmptyString:[Config shareInstance].settings.birthday]) {
        [daysLeftSubView.centerButton setAllTitle:[CommonFunction integerToDecimalStyle:daysLeft]];
    } else {
        [daysLeftSubView.centerButton setAllTitle:@"X"];
    }
    [daysLeftSubView.rightButton.titleLabel setFont:font_Normal_16];
    [daysLeftSubView.rightButton setAllTitleColor:color_Black];
    [daysLeftSubView.rightButton setAllTitle:str_FirstView_4];
    [daysLeftSubView autoLayout];
    [self.view addSubview:daysLeftSubView];
    
    daysLeftView = daysLeftSubView;
    
    CGRect daysFrame = CGRectZero;
    daysFrame.size.width = daysLeftView.frame.size.width;
    daysFrame.size.height = daysLeftView.frame.size.height;
    daysFrame.origin.x = xMiddle - daysLeftView.frame.size.width/2;
    daysFrame.origin.y = yOffset;
    
    daysLeftView.frame = daysFrame;
    yOffset += daysLeftView.frame.size.height + ySpace;
    
    ThreeSubView *secondsLeftSubView = [[ThreeSubView alloc] initWithFrame:CGRectMake(xMiddle, yOffset, labelWidth, labelHeight)leftButtonSelectBlock:nil centerButtonSelectBlock:nil rightButtonSelectBlock:nil];
    [secondsLeftSubView.leftButton.titleLabel setFont:font_Normal_16];
    [secondsLeftSubView.leftButton setAllTitleColor:color_Black];
    [secondsLeftSubView.leftButton setAllTitle:str_FirstView_5];
    [secondsLeftSubView.centerButton.titleLabel setFont:font_Normal_24];
    [secondsLeftSubView.centerButton setAllTitleColor:color_Red];
    [secondsLeftSubView.centerButton setAllTitle:[CommonFunction integerToDecimalStyle:kSecondsPerDay]];
    [secondsLeftSubView.rightButton.titleLabel setFont:font_Normal_16];
    [secondsLeftSubView.rightButton setAllTitleColor:color_Black];
    [secondsLeftSubView.rightButton setAllTitle:str_FirstView_6];
    [secondsLeftSubView autoLayout];
    [self.view addSubview:secondsLeftSubView];
    
    secondsLeftView = secondsLeftSubView;
    
    CGRect secondsFrame = CGRectZero;
    secondsFrame.size.width = secondsLeftView.frame.size.width;
    secondsFrame.size.height = secondsLeftView.frame.size.height;
    secondsFrame.origin.x = xMiddle - secondsLeftView.frame.size.width/2;
    secondsFrame.origin.y = yOffset;
    
    secondsLeftView.frame = secondsFrame;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondsCountdown) userInfo:nil repeats:YES];
}

- (void)createStatisticsView {
    BOOL isiPhone4oriPhone5 = iPhone4 || iPhone5;
    
    CGFloat xOffset = isiPhone4oriPhone5 ? WIDTH_FULL_SCREEN / 15 : WIDTH_FULL_SCREEN / 7;
    CGFloat viewWidth = WIDTH_FULL_SCREEN - xOffset * 2;
    CGFloat subviewWidth = viewWidth / 3;
    CGFloat viewHeight = HEIGHT_FULL_SCREEN * 0.1875;
    CGFloat subviewHeight = viewHeight / 3;
    
    yOffset += iPhone4 ? ySpace : ySpace * 2;
    
    UIView *statisticsBgView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, yOffset, viewWidth, subviewHeight * 2)];
    [self.view addSubview:statisticsBgView];
    [self addSeparatorForLeft:statisticsBgView];
    [self addSeparatorForMiddleLeft:statisticsBgView];
    [self addSeparatorForMiddleRight:statisticsBgView];
    [self addSeparatorForTop:statisticsBgView];
    [self addSeparatorForRight:statisticsBgView];
    statisticsView = statisticsBgView;
    
    ThreeSubView *topTitleView = [[ThreeSubView alloc] initWithFrame:CGRectMake(0, 0, subviewWidth * 3, subviewHeight)leftButtonSelectBlock:nil centerButtonSelectBlock:nil rightButtonSelectBlock:nil];
    [topTitleView.leftButton.titleLabel setFont:font_Normal_16];
    [topTitleView.leftButton setAllTitleColor:color_Black];
    [topTitleView.leftButton setAllTitle:str_FirstView_7];
    topTitleView.fixLeftWidth = subviewWidth;
    [topTitleView.centerButton.titleLabel setFont:font_Normal_16];
    [topTitleView.centerButton setAllTitleColor:color_Black];
    [topTitleView.centerButton setAllTitle:str_FirstView_8];
    topTitleView.fixCenterWidth = subviewWidth;
    [topTitleView.rightButton.titleLabel setFont:font_Normal_16];
    [topTitleView.rightButton setAllTitleColor:color_Black];
    [topTitleView.rightButton setAllTitle:str_FirstView_9];
    topTitleView.fixRightWidth = subviewWidth;
    [self addSeparatorForBottom:topTitleView];
    [topTitleView autoLayout];
    [statisticsView addSubview:topTitleView];

    {
        ThreeSubView *everydayStatisticsView = [[ThreeSubView alloc] initWithFrame:CGRectMake(0, subviewHeight, subviewWidth * 3, subviewHeight)leftButtonSelectBlock:nil centerButtonSelectBlock:nil rightButtonSelectBlock:nil];
        
        //plantype 1 每日计划
        float total = [[PlanCache getPlanTotalCount:@"ALL"] floatValue];
        [everydayStatisticsView.leftButton.titleLabel setFont:font_Normal_16];
        [everydayStatisticsView.leftButton setAllTitleColor:color_Black];
        [everydayStatisticsView.leftButton setAllTitle:[NSString stringWithFormat:@"%.0f", total]];
        everydayStatisticsView.fixLeftWidth = subviewWidth;
        
        float done = [[PlanCache getPlanCompletedCount] floatValue];
        [everydayStatisticsView.centerButton.titleLabel setFont:font_Normal_16];
        [everydayStatisticsView.centerButton setAllTitleColor:color_Green_Emerald];
        [everydayStatisticsView.centerButton setAllTitle:[NSString stringWithFormat:@"%.0f", done]];
        everydayStatisticsView.fixCenterWidth = subviewWidth;
        
        float percent = 0;
        if (total > 0) {
            percent = (float)done*100 /(float)total;
        }
        [everydayStatisticsView.rightButton.titleLabel setFont:font_Normal_16];
        [everydayStatisticsView.rightButton setAllTitleColor:color_Red];
        [everydayStatisticsView.rightButton setAllTitle:[NSString stringWithFormat:@"%.2f%%", percent]];
        everydayStatisticsView.fixRightWidth = subviewWidth;
        
        [self addSeparatorForBottom:everydayStatisticsView];
        [everydayStatisticsView autoLayout];
        [statisticsView addSubview:everydayStatisticsView];
    }

    yOffset += viewHeight + 20;
}

- (void)createShareLogo {
    CGFloat viewWidth = 110;
    CGFloat viewHeight = 20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_FULL_SCREEN - viewWidth - 5, yOffset, viewWidth, viewHeight)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewHeight, viewHeight)];
    logo.image = [UIImage imageNamed:png_Icon_Logo_512];
    [view addSubview:logo];
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight + 2, 0, viewWidth - viewHeight - 2, viewHeight)];
    labelName.text = str_Share_Tips1;
    labelName.font = font_Normal_10;
    labelName.textColor = [CommonFunction getGenderColor];
    [view addSubview:labelName];
    view.hidden = YES;
    shareLogoView = view;
    [self.view addSubview:view];
}

- (void)addSeparatorForTop:(UIView *)view {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds) - 1, 1)];
    separator.backgroundColor = color_GrayLight;
    [view addSubview:separator];
}

- (void)addSeparatorForBottom:(UIView *)view {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.bounds) - 1, CGRectGetWidth(view.bounds) - 1, 1)];
    separator.backgroundColor = color_GrayLight;
    [view addSubview:separator];
}

- (void)addSeparatorForLeft:(UIView *)view {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(view.bounds))];
    separator.backgroundColor = color_GrayLight;
    [view addSubview:separator];
}

- (void)addSeparatorForMiddleLeft:(UIView *)view {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.bounds) / 3, 0, 1, CGRectGetHeight(view.bounds))];
    separator.backgroundColor = color_GrayLight;
    [view addSubview:separator];
}

- (void)addSeparatorForMiddleRight:(UIView *)view {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.bounds) * 2 / 3 + 1, 0, 1, CGRectGetHeight(view.bounds))];
    separator.backgroundColor = color_GrayLight;
    [view addSubview:separator];
}

- (void)addSeparatorForRight:(UIView *)view {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.bounds) - 1, 0, 1, CGRectGetHeight(view.bounds))];
    separator.backgroundColor = color_GrayLight;
    [view addSubview:separator];
}

- (void)secondsCountdown {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    NSInteger secondsLeft = kSecondsPerDay - hour*3600 - minute*60 -second;
    
    [secondsLeftView.centerButton setAllTitle:[CommonFunction integerToDecimalStyle:secondsLeft]];
    [secondsLeftView autoLayout];
    CGRect frame = secondsLeftView.frame;
    frame.origin.x = self.view.frame.size.width / 2 - secondsLeftView.frame.size.width / 2;
    secondsLeftView.frame = frame;
    
    if (secondsLeft == kSecondsPerDay) {
        NSTimeInterval secondsBetweenDates= [deadDay timeIntervalSinceDate:now];
        if(secondsBetweenDates < 0) {
            daysLeft = 0;
        } else {
            daysLeft = secondsBetweenDates/kSecondsPerDay;
        }
        
        [daysLeftView.centerButton setAllTitle:[CommonFunction integerToDecimalStyle:daysLeft]];
        [daysLeftView autoLayout];
        CGRect frame = daysLeftView.frame;
        frame.origin.x = self.view.frame.size.width / 2 - daysLeftView.frame.size.width / 2;
        daysLeftView.frame = frame;
    }
}

- (void)toSettingsViewController {
    SettingsViewController *controller = [[SettingsViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
