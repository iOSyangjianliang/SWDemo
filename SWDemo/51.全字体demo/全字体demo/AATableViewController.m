//
//  AATableViewController.m
//  全字体demo
//
//  Created by 顺网-yjl on 2019/4/19.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "AATableViewController.h"
#import "AATableViewCell.h"
#import "BBViewController.h"

#import <CoreText/CoreText.h>

@interface AATableViewController ()
@property(nonatomic, strong) NSMutableArray *arrayM;

@property(nonatomic, assign)  NSInteger isExtend;


@property(nonatomic, strong) NSMutableArray *arrayMNeed;


@end

@implementation AATableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStyleDone target:self action:@selector(ccc:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AATableViewCell" bundle:nil] forCellReuseIdentifier:@"777"];
    self.tableView.rowHeight = 40.f;
    
    _arrayM = [NSMutableArray arrayWithArray:[UIFont familyNames]];

   
    NSString *fontPath  = [[NSBundle mainBundle]pathForResource:@"SentyCandy-color" ofType:@"ttf"];
    NSString *fontPath1  = [[NSBundle mainBundle]pathForResource:@"侧耳倾听" ofType:@"ttf"];
    NSString *fontPath2  = [[NSBundle mainBundle]pathForResource:@"一纸情书" ofType:@"ttf"];

  
    NSString *fontName = [self addFont:fontPath];
    NSString *fontName1 =[self addFont:fontPath1];
    NSString *fontName2 =[self addFont:fontPath2];

    [_arrayM insertObject:fontName atIndex:0];
    [_arrayM insertObject:fontName1 atIndex:0];
    [_arrayM insertObject:fontName2 atIndex:0];

    _isExtend = -1;

    self.navigationItem.title = [NSString stringWithFormat:@"字体种类%lu",(unsigned long)_arrayM.count];
    
    _arrayMNeed = [NSMutableArray array];
    

}


-(NSString *)addFont:(NSString *)fontPath
{
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
    CGFontRef customfont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    NSString *fontName = (__bridge NSString *)CGFontCopyFullName(customfont);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(customfont, &error);
    if (error){
        // 为了可以重复注册
        CTFontManagerUnregisterGraphicsFont(customfont, &error);
        CTFontManagerRegisterGraphicsFont(customfont, &error);
    }
    CGFontRelease(customfont);
    return fontName;
}
-(void)ccc:(UIBarButtonItem *)sender
{
    BBViewController *vc = [[BBViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayM.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _isExtend) {
        return 160;
    }
    return 40.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"777" forIndexPath:indexPath];
    
    cell.oneLabe.text = _arrayM[indexPath.row];
    
    cell.twoLabe.text = @"汉体 苹果在去年停售 iPhone SE，但关于 iPhone SE 2 的传言依旧存在并且关注度很高.🐑😄😂🌹";
    cell.threeLabe.text = @"Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table. ";

    cell.oneLabe.font =  cell.twoLabe.font =  cell.threeLabe.font = [UIFont fontWithName:_arrayM[indexPath.row] size:15]; ;
    
//    cell.fourLabe.font = [UIFont fontWithName:@"yizhiqingshu" size:15]; ;//.SFUIText默认字体
    cell.fourLabe.text =  @"";
    
    // Configure the cell...
    
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isExtend = indexPath.row;
    [self.tableView reloadData];
    
    [_arrayMNeed addObject:_arrayM[indexPath.row]];
    NSLog(@"%@",_arrayMNeed);
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
