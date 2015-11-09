//
//  DynamicViewController.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "DynamicViewController.h"
#import "DynamicModel.h"
#import "DynamicTableViewCell.h"
#import "PublicNewDynamicViewController.h"
#import "NSString+GetSize.h"
#import "GetPicturesHeight.h"
#define CellID @"Cell"
@interface DynamicViewController () {
    int _page;
}

@property (nonatomic,strong)NSMutableArray *dynamicDataArray;

@end

@implementation DynamicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dynamicDataArray = [NSMutableArray array];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicNewDynamic)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[DynamicTableViewCell class] forCellReuseIdentifier:CellID];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 0;
        [weakSelf.dynamicDataArray removeAllObjects];
        [weakSelf getData];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self getData];
}

- (void)getData {
    BmobQuery *dynamicQuery = [BmobQuery queryWithClassName:USER_DYNAMIC];
    dynamicQuery.limit = 20;
    dynamicQuery.skip = _page;
    [dynamicQuery orderByDescending:@"createdAt"];
    __block NSMutableArray *blockArray = _dynamicDataArray;
    __weak typeof(self) weakSelf = self;
    [dynamicQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        for (BmobObject *objc in array) {
            DynamicModel *model = [[DynamicModel alloc]init];
            model.userIcon = [objc objectForKey:@"usericon"];
            model.userName = [objc objectForKey:@"username"];
            model.images = [objc objectForKey:@"images"];
            model.content = [objc objectForKey:@"content"];
            model.createDate = [objc createdAt];
            [blockArray addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    }];
    _page +=20;
}

#pragma tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dynamicDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DynamicModel *model = [_dynamicDataArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicModel *model = [_dynamicDataArray objectAtIndex:indexPath.row];
    
    return DEFAYLT_HEIGHT + [NSString getStringSizeWithString:model.content withStringFont:[UIFont systemFontOfSize:14] withStringMaxSize:CGSizeMake(kSCREEN_WIDTH - 70, MAXFLOAT)].height +[GetPicturesHeight getPicturesHeightWith:model.images];
}

#pragma mark buttonClick

- (void)publicNewDynamic {
    PublicNewDynamicViewController *publicCtl = [[PublicNewDynamicViewController alloc] init];
    publicCtl.block = ^(DynamicModel *model){
        [_dynamicDataArray insertObject:model atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:publicCtl animated:YES];
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
