//
//  main.m
//  EncryptFile
//
//  Created by Colin Caufield on 2016-03-07.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQDataExtensions.h"

#define VALIDATE

int main(int argc, const char* argv[])
{
    if (argc != 4)
    {
        NSLog(@"Usage: EncryptFile <input-file> <output-file> <password>.\n");
        return 1;
    }
    
    NSString* inputFilename  = [NSString stringWithUTF8String:argv[1]];
    NSString* outputFilename = [NSString stringWithUTF8String:argv[2]];
    NSString* password       = [NSString stringWithUTF8String:argv[3]];
    
    NSData* rawData = [NSData dataWithContentsOfFile:inputFilename];
    if (rawData == nil || rawData.length == 0)
    {
        NSLog(@"Error reading from file %@.\n", inputFilename);
        return 1;
    }
    
    NSData* encryptedData = [rawData dataEncryptedWithPassword:password];
    if (encryptedData == nil || encryptedData.length == 0)
    {
        NSLog(@"Error encrypting with password %@.\n", password);
        return 1;
    }
    
    BOOL writeOk = [encryptedData writeToFile:outputFilename atomically:NO];
    if (writeOk == NO)
    {
        NSLog(@"Error writing to file %@.\n", outputFilename);
        return 1;
    }
    
    #ifdef VALIDATE
        
        NSData* unencryptedData = [encryptedData dataDecryptedWithPassword:password];
        if (unencryptedData == nil || ![unencryptedData isEqualToData:rawData])
        {
            NSLog(@"Validation failed.\n");
            return 1;
        }
        
    #endif
    
    return 0;
}
