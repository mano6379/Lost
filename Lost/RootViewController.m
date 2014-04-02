//
//  RootViewController.m
//  Lost
//
//  Created by Marion Ano on 4/1/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//

#import "RootViewController.h"
#import <CoreData/CoreData.h>
#import "Character.h"
#import "MyCellTableViewCell.h"

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource>

@property NSArray *charactersArray;
@property (strong, nonatomic) IBOutlet UITableView *lostTableVlew;
@property (strong, nonatomic) IBOutlet UITextField *characterNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *actorNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *genderTextField;


@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
}

-(void)load
{
    
        NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Character"];
    //if you want to see the predicate property work, simply uncomment the line below
    //request.predicate = [NSPredicate predicateWithFormat:@"actor contains %@", @"Z"];
    
    NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc]initWithKey:@"actor" ascending:YES];
    NSSortDescriptor* sortDescriptor2 = [[NSSortDescriptor alloc]initWithKey:@"passenger" ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
                //assign the request to the properties "sortDescriptors"
                request.sortDescriptors = sortDescriptors;
    self.charactersArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
//      NSArray *characters = [self.managedObjectContext executeFetchRequest:request error:nil];
//      if (characters.count)
//      {
//       self.charactersArray = characters;
//      }
    //[self.lostTableVlew reloadData];


    //BOOL isCoreDataEmpty = self.charactersArray.count == 0;
    BOOL isFirstRun= ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasRunOnce"];
    if(isFirstRun)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"hasRunOnce"];
        [userDefaults synchronize];
   
    
        // get (from internet) array of dictionaries that represent lost characters
        NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/2/lost.plist"];
        self.charactersArray = [NSArray arrayWithContentsOfURL:url];
        
        // we will put the Character objects in here
        NSMutableArray *mutableArray = [NSMutableArray new];
        
        // crap! charactersArray is an array of dictionaries
        for (NSDictionary *characterDictionary in self.charactersArray)
        {
            // Convert each NSDictionary into a Character object
            Character* character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjectContext];
            character.actor= characterDictionary[@"actor"];
            character.passenger= characterDictionary[@"passenger"];

            [mutableArray addObject:character];

        }
        
        self.charactersArray = mutableArray;
    }

    [self.lostTableVlew reloadData];
}

#pragma mark -- Delete cells from Table View
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.managedObjectContext deleteObject:self.charactersArray[indexPath.row]];
        [self.managedObjectContext save:nil];
        [self load];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Smoke Monster";
}

#pragma mark -- TableView Delegate methods:
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.charactersArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Character *person = self.charactersArray[indexPath.row];
    MyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellReuseCellID"];
    cell.textLabel.text = person.actor.description;
    cell.detailTextLabel.text = person.passenger.description;
    cell.genderLabel.text = person.sex.description;
//    UIButton *checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 36, 36)];
//    
//    [checkBoxButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//    
//    [checkBoxButton setImage:[UIImage imageNamed:@"checkbox-pressed.png"] forState:UIControlStateHighlighted];
//    
//    [checkBoxButton setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
//    
//    checkBoxButton.tag = indexPath.row;
//    
//    [checkBoxButton addTarget:self action:@selector(checkBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //This add the UIButton to the Cell.
//    [cell.contentView addSubview:checkBoxButton];
    
    return cell;
}

- (IBAction)addCharacter:(id)sender

{
    
    Character* character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjectContext];
    character.actor = self.characterNameTextField.text;
    character.passenger = self.actorNameTextField.text;
    character.sex = self.genderTextField.text;
    [self.characterNameTextField resignFirstResponder];
    [self.actorNameTextField resignFirstResponder];
    [self.genderTextField resignFirstResponder];
    [self.managedObjectContext save:nil];
    [self load];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
