//
//  CouponClassChoiceViewController.m
//  UCAI
//
//  Created by  on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CouponClassChoiceViewController.h"

#import "CouponListViewController.h"
#import "CouponOrderListViewController.h"

#import "PiosaFileManager.h"
#import "StaticConf.h"

@implementation CouponClassChoiceViewController

- (void)dealloc{
    [_choiceTableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom

- (void)phoneCall{
    if ([[UIApplication  sharedApplication] canOpenURL:[NSURL  URLWithString:@"tel://4006840060"]]) {
        UIActionSheet * phoneActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打电话40068 40060" otherButtonTitles:nil, nil];
        phoneActionSheet.delegate = self;
        [phoneActionSheet showInView:[UIApplication sharedApplication].keyWindow];
		[phoneActionSheet release];
    }
}

- (void)backOrHome:(UIButton *) button
{
    switch (button.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 102:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
    }
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.title = @"优惠劵中心";
	
	//返回按钮
    NSString *backButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *backButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    backButton.tag = 101;
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonNormalPath] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonHighlightedPath] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
    [backButton release];
    
    //主页按钮
    NSString *homeButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *homeButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    homeButton.tag = 102;
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonNormalPath] forState:UIControlStateNormal];
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonHighlightedPath] forState:UIControlStateHighlighted];
    [homeButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeBarButtonItem;
    [homeBarButtonItem release];
    [homeButton release];
    
	//设置背景图片
    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
    bgImageView.frame = CGRectMake(0, 0, 320, 416);
	[self.view addSubview:bgImageView];
	[bgImageView release];
	
	UITableView * uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 386) style:UITableViewStyleGrouped];
    uiTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	uiTableView.backgroundColor = [UIColor clearColor];
	uiTableView.dataSource = self;
	uiTableView.delegate = self;
    _choiceTableView = uiTableView;
	[self.view addSubview:uiTableView];
    
    //底部视图的设置
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 386, 320, 30)];
    bottomView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    UIButton * phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 2, 156, 26)];
    NSString *phonecallButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_normal" inDirectory:@"CommonView/BottomItem"];
    NSString *phonecallButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_highlighted" inDirectory:@"CommonView/BottomItem"];
    [phoneButton setImage:[UIImage imageNamed:phonecallButtonNormalPath] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:phonecallButtonHighlightedPath] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneButton];
    [self.view addSubview:bottomView];
    [phoneButton release];
    [bottomView release];
}

- (void)viewWillAppear:(BOOL)animated{
    [_choiceTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableDictionary *loginDict = [PiosaFileManager applicationPlistFromFile:UCAI_LOGIN_FILE_NAME];
    
    if ([[loginDict objectForKey:@"isLogin"] boolValue]) {
        return 2;
    } else {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *loginDict = [PiosaFileManager applicationPlistFromFile:UCAI_LOGIN_FILE_NAME];
    
    if ([[loginDict objectForKey:@"isLogin"] boolValue]) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 2;
                break;
            default:
                return 0;
                break;
        }
    } else {
        return 2;
    }
}

//设置表格单元的展现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    NSMutableDictionary *loginDict = [PiosaFileManager applicationPlistFromFile:UCAI_LOGIN_FILE_NAME];
    
    if ([[loginDict objectForKey:@"isLogin"] boolValue]) {
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = @"我的订单";
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"免费优惠劵";
                        break;
                    case 1:
                        cell.textLabel.text = @"购买优惠劵";
                        break;
                }
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"免费优惠劵";
                break;
            case 1:
                cell.textLabel.text = @"购买优惠劵";
                break;
        }
    }
    
	
	
    cell.textLabel.highlightedTextColor = [PiosaColorManager themeColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if ([_choiceTableView numberOfRowsInSection:indexPath.section] == 1) {
        NSString *tableViewCellSingleNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_normal" inDirectory:@"CommonView/TableViewCell"];
        NSString *tableViewCellSingleHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_highlighted" inDirectory:@"CommonView/TableViewCell"];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleNormalPath]] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleHighlightedPath]] autorelease];
    } else {
        if (indexPath.row == 0) {
            NSString *tableViewCellTopNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellTopHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopHighlightedPath]] autorelease];
        } else if(indexPath.row == [_choiceTableView numberOfRowsInSection:indexPath.section]-1){
            NSString *tableViewCellBottomNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_bottom_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellBottomHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_bottom_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBottomNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBottomHighlightedPath]] autorelease];
        } else {
            NSString *tableViewCellCenterNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_center_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellCenterHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_center_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellCenterNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellCenterHighlightedPath]] autorelease];
        }
    }
    
    NSString *accessoryDisclosureIndicatorPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"accessoryDisclosureIndicator" inDirectory:@"CommonView/TableViewCell"];
    UIImageView * accessoryViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:accessoryDisclosureIndicatorPath]];
    accessoryViewTemp.frame = CGRectMake(0, 0, 10, 16);
    cell.accessoryView = accessoryViewTemp;
    [accessoryViewTemp release];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *loginDict = [PiosaFileManager applicationPlistFromFile:UCAI_LOGIN_FILE_NAME];
    
    if ([[loginDict objectForKey:@"isLogin"] boolValue]) {
        switch (indexPath.section) {
            case 0:{
                CouponOrderListViewController *couponOrderListViewController = [[CouponOrderListViewController alloc] init];
                [self.navigationController pushViewController:couponOrderListViewController animated:YES];
                [couponOrderListViewController release];
            }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:{
                        CouponListViewController * couponListViewController = [[CouponListViewController alloc] initWithCouponType:1];
                        [self.navigationController pushViewController:couponListViewController animated:YES];
                        [couponListViewController release];
                    }
                        break;
                    case 1:{
                        CouponListViewController * couponListViewController = [[CouponListViewController alloc] initWithCouponType:2];
                        [self.navigationController pushViewController:couponListViewController animated:YES];
                        [couponListViewController release];
                    }
                        break;
                }
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:{
                CouponListViewController * couponListViewController = [[CouponListViewController alloc] initWithCouponType:1];
                [self.navigationController pushViewController:couponListViewController animated:YES];
                [couponListViewController release];
            }
                break;
            case 1:{
                CouponListViewController * couponListViewController = [[CouponListViewController alloc] initWithCouponType:2];
                [self.navigationController pushViewController:couponListViewController animated:YES];
                [couponListViewController release];
            }
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet cancelButtonIndex] != buttonIndex) {
        //拨打客服电话
        [[UIApplication  sharedApplication] openURL:[NSURL  URLWithString:@"tel://4006840060"]];
    }
}





@end
