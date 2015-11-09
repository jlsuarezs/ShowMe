//
//  VideoViewController.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoModel.h"
#import "VideoTableViewCell.h"
#import "PublicNewVideoViewController.h"
#define CellID @"cell"
@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    int _page;
}
 @property (nonatomic,strong) NSMutableArray *viewDataArray;

@end

@implementation VideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewDataArray = [NSMutableArray array];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicNewVideo)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:CellID];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 0;
        [_viewDataArray removeAllObjects];
        [weakSelf getData];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [self getData];
}

- (void)getData {
    BmobQuery *videoQuery = [BmobQuery queryWithClassName:USER_VIDEO];
    videoQuery.limit = 20;
    videoQuery.skip = _page;
    [videoQuery orderByDescending:@"createdAt"];
    __block NSMutableArray *blockArray = _viewDataArray;
    __weak typeof(self) weakSelf = self;
    [videoQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        for (BmobObject *objc in array) {
            VideoModel *model = [[VideoModel alloc]init];
            model.iconUrl = [objc objectForKey:@"usericon"];
            model.userName = [objc objectForKey:@"username"];
            model.videoUrl = [objc objectForKey:@"videourl"];
            model.content = [objc objectForKey:@"content"];
            model.thumbilUrl = [objc objectForKey:@"thumbil"];
            model.createDate = [objc createdAt];
            
            NSLog(@"%@.......%@",model.videoUrl,model.thumbilUrl);
            [blockArray addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    }];
    _page +=20;
}

#pragma mark buttonClick
- (void)publicNewVideo {
    PublicNewVideoViewController *publicCtl = [[PublicNewVideoViewController alloc] init];
    publicCtl.block = ^(VideoModel *model){
        [_viewDataArray insertObject:model atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
    [self.navigationController pushViewController:publicCtl animated:YES];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _viewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_viewDataArray.count > 0) {
        VideoModel *model = _viewDataArray[indexPath.row];
        cell.model = model;
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewDataArray.count > 0) {
        VideoModel *model = _viewDataArray[indexPath.row];
        return 50 + kSCREEN_WIDTH/kSCREEN_HEIGHT * (kSCREEN_WIDTH-20) + [NSString getStringSizeWithString:model.content withStringFont:[UIFont systemFontOfSize:14] withStringMaxSize:CGSizeMake(kSCREEN_WIDTH-70, MAXFLOAT)].height+10;
    }
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
