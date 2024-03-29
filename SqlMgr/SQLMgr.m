//
//  SQLMgr.m
//  Online_Education
//
//  Created by hana on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SQLMgr.h"
#import "FMDatabaseAdditions.h"

#define FMDBQuickCheck(SomeBool) {if(!(SomeBool)){ NSLog(@"Faliure On Line %d",__LINE__);return 123;}}

@implementation SQLMgr
-(id) init
{
    if([super init]){
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filePath = [paths objectAtIndex:0];
        dbFilePath = [filePath stringByAppendingPathComponent:@"schedule.sqlite"];
    }
    return self;
}

- (void) dealloc {
    [rs release];
    [super dealloc];
}

-(void) connect
{
    mDatabase = [FMDatabase databaseWithPath:dbFilePath];
}
-(void) disconnect
{
    mDatabase = nil;
}
-(BOOL) open
{
    return [mDatabase open];
}
- (void) close
{
    [rs close];
    [mDatabase close];
}

-(BOOL) executeQuery:(NSString*)query
{
    mErrorCode = 0;
    mErrorStr = NULL;
    [mDatabase setShouldCacheStatements:YES];
    rs =  [mDatabase executeQuery:query];
 //   FMDBQuickCheck([mDatabase hadError]);
    if ([mDatabase hadError]){
        mErrorCode = [mDatabase lastErrorCode];
        mErrorStr = [mDatabase lastErrorMessage];
        NSLog(@"<-----------\n execute query:= %@",query);
        NSLog(@"execute query result = FALSE with result : %@ \n---------->", mErrorStr);
        return FALSE;
    }
    return TRUE;
}
- (BOOL) executeUpdate:(NSString*)sql
{
    BOOL res = [mDatabase executeUpdate:sql];
    if([mDatabase hadError]){
        mErrorCode = [mDatabase lastErrorCode];
        mErrorStr = [mDatabase lastErrorMessage];
        NSLog(@"<-----------\n execute query:= %@",sql);
        NSLog(@"execute query result = FALSE with result : %@ \n---------->", mErrorStr);
        return FALSE;
    }
    return res;

}
-(NSString*) getLastError
{
    return mErrorStr;
}
-(BOOL) next
{
    return [rs next];
}
-(NSString*) getValue:(NSString*) recordName
{
    return [rs stringForColumn:recordName];
}
-(NSString*) getValueAt:(int) index
{
    return [rs stringForColumnIndex:index];
}

- (int)getIntValue:(NSString *)recordName {
	return [rs intForColumn:recordName];
}

-(void) transation
{
    [mDatabase beginTransaction];
}
-(void) commit
{
    [mDatabase commit];
}
-(void) rollback
{
    [mDatabase rollback];
}
@end
