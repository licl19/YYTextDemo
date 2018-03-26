//
//  ViewController.m
//  YYTextDemo
//
//  Created by lichanglai on 2018/3/26.
//  Copyright © 2018年 sankai. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <YYText.h>
#import <YYImage.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height



/// model
@interface CellModel : NSObject
    
@property (nonatomic,strong) YYTextLayout *textLayout;
@property (nonatomic) CGFloat cellHeight;
    
@end

@implementation CellModel
@end



/// cell
@interface UserVCCell : UITableViewCell
    
@property (nonatomic,strong) CellModel *data;
@property (nonatomic, strong) YYLabel *contentLabel;
    
@end

@implementation UserVCCell
    
#define kWidth   280
#define kLabelMarginTop  10
    
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.contentLabel];
    }
    return self;
}
    
-(void)setData:(CellModel *)data
{
    _data = data;
    YYTextLayout *layout = data.textLayout;
    self.contentLabel.textLayout = layout;
    CGRect frame = self.contentLabel.frame;
    frame.size = layout.textBoundingSize;
    self.contentLabel.frame = frame;
}
    
-(YYLabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[YYLabel alloc] initWithFrame:CGRectMake((kScreenWidth - kWidth)/2.0, kLabelMarginTop, 0, 0)];
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.numberOfLines = 0;
        UIFont *font = [UIFont systemFontOfSize:16];
        _contentLabel.font = font;
        _contentLabel.displaysAsynchronously = YES; /// enable async display
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        [_contentLabel setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2]];
        }
    return _contentLabel;
}
@end



/// vc
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataList;
@end

@implementation ViewController

NSMutableAttributedString *attributeText;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView registerClass:[UserVCCell class] forCellReuseIdentifier:@"tableCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *arrays = [NSMutableArray new];
        for (int i = 0; i<100; i++)
        {
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            NSString *title11 = @"开始 ";
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:title11 attributes:nil]];
            UIFont *font = [UIFont systemFontOfSize:16];
            NSArray *names = @[@"001", @"022", @"019",@"056",@"085",@"001", @"022", @"019",@"056",@"085",@"001", @"022", @"019",@"056",@"085",@"001", @"022", @"019",@"056",@"085",@"001", @"022",@"001",@"001",@"022",@"022",@"022",@"022",@"022",@"022",@"022",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"022",@"022",@"022",@"022",@"001", @"022", @"019",@"056",@"085",@"001", @"022", @"019",@"056",@"085",@"001", @"022", @"019",@"056",@"085",@"001", @"022", @"019",@"056",@"085",@"001", @"022",@"001",@"001",@"022",@"022",@"022",@"022",@"022",@"022",@"022",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"001",@"022",@"022",@"022",@"022"];
            
            for (int j = 0;j<names.count && j< arc4random()%names.count ;j++)
            {
                NSString *name  = names[j];
                NSString *path = [self pathForScaledResource:name ofType:@"png" inDirectory:@"EmoticonQQ.bundle"];
                NSData *data = [NSData dataWithContentsOfFile:path];
                YYImage *image = [YYImage imageWithData:data scale:2];//修改表情大小
                image.preloadAllAnimatedImageFrames = YES;
                YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                [text appendAttributedString:attachText];
                if(arc4random()%5==0)
                {
                    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"这是乱七八糟的文字" attributes:nil]];
                }
            }
            
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"结束" attributes:nil]];
            YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWidth, MAXFLOAT)];
            YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:text];
            
            CellModel *model = [[CellModel alloc] init];
            model.textLayout = textLayout;
            model.cellHeight = textLayout.textBoundingSize.height;
            [arrays addObject:model];
        }
        self.dataList = arrays;
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    });
}
- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)bundlePath {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [[NSBundle mainBundle] pathForResource:name ofType:ext inDirectory:bundlePath];
        
    NSString *path = nil;
    NSString *scaledName = [NSString stringWithFormat:@"%@@%@x",name,@(2)];
    path = [[NSBundle mainBundle] pathForResource:scaledName ofType:ext inDirectory:bundlePath];
        
    return path;
}
    
    

/// tableView delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"tableCell";
    UserVCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UserVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CellModel *model = self.dataList[indexPath.row];
    cell.data = model;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *model = self.dataList[indexPath.row];
    CGFloat height = model.cellHeight;
    return height + 2*kLabelMarginTop;
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
