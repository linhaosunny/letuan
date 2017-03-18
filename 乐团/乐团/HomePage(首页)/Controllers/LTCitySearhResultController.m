//
//  LTCitySearhResultController.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTCitySearhResultController.h"
#import "LTCitiesModel.h"
#import "MJExtension.h"
#import "CommonDefine.h"

@interface LTCitySearhResultController ()
@property (nonatomic, strong) NSArray *results;
@end

static NSString * const ID = @"results";
@implementation LTCitySearhResultController



- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)setSearchText:(NSString *)searchText{
    _searchText = [searchText copy];
    

    // > 转成小写
    searchText = searchText.lowercaseString;
    
//    NSMutableArray * results = [NSMutableArray array];
    // > 1. 通用搜索匹配数据
//    for(LTCitiesModel *model  in self.cities){
//        if([model.name containsString:searchText] ||
//           [model.pinYin.uppercaseString containsString:searchText] ||
//           [model.pinYinHead.uppercaseString containsString:searchText]){
//            
//            [results addObject:model];
//        }
//    }
//    
//    self.results = [results copy];
    
    // > 2. 谓词搜索
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    
    self.results = [[LTCitiesModel cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    LTCitiesModel *model = self.results[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
/** 分组标题 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  
    return [NSString stringWithFormat:@"共搜索到%lu个结果",self.results.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LTCitiesModel *model = self.results[indexPath.row];
    
    // > 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:model.name,LTSelectedRegion:@"全部地区",LTSelectedSubRegion:@"全部",LTNotificationExit:@"NO",LTNotificationInit:@"YES"}];
    
    // > 退出
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
