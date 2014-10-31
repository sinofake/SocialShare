//
//  ViewController.m
//  SSSocialShare
//
//  Created by sskh on 14/10/30.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "ViewController.h"
#import "ShareManager.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ShareManager *shareManager;


@end

@implementation ViewController

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"share_wechat.png"];
            cell.textLabel.text = @"微信";
        }
            break;
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"share_wechat_timeline.png"];
            cell.textLabel.text = @"微信朋友圈";
        }
            break;
        case 2:
        {
            cell.imageView.image = [UIImage imageNamed:@"share_qq.png"];
            cell.textLabel.text = @"QQ";
        }
            break;
        case 3:
        {
            cell.imageView.image = [UIImage imageNamed:@"share_qqzone.png"];
            cell.textLabel.text = @"QQ空间";
        }
            break;
        case 4:
        {
            cell.imageView.image = [UIImage imageNamed:@"share_weibo.png"];
            cell.textLabel.text = @"微博";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [self.shareManager sendMessageToWeixinWithScene:WeixinSceneTypeSession messageType:ShareMessageTypeWebpage infoDict:nil];
        }
            break;
        case 1:
        {
            [self.shareManager sendMessageToWeixinWithScene:WeixinSceneTypeTimeline messageType:ShareMessageTypeWebpage infoDict:nil];
        }
            break;
        case 2:
        {
            [self.shareManager sendMessageToQQWithType:ShareMessageTypeWebpage infoDict:nil];
        }
            break;
        case 3:
        {
            [self.shareManager sendMessageToQQZoneWithType:ShareMessageTypeWebpage infoDict:nil];
        }
            break;
        case 4:
        {
            [self.shareManager sendMessageToWeiboWithType:ShareMessageTypeWebpage infoDict:nil];
        }
            break;
            
        default:
            break;
    }
}


- (ShareManager *)shareManager {
    if (!_shareManager) {
        _shareManager = [[ShareManager alloc] init];
    }
    return _shareManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
