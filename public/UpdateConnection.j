/*
 * The MIT License
 * 
 * Copyright (c) 2009, 2010 Leif Singer
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

@implementation UpdateConnection : CPObject
{
    long lastTimestamp;
}

- (void)init
{
    return [self initWithTimestamp: Math.round([[CPDate date] timeIntervalSince1970])];
}

- (void)initWithTimestamp:(long)aTimestamp
{
    self = [super init];
    
    if (self) {
        var request = [[CPURLRequest alloc] initWithURL:"/messages/since/" + aTimestamp];
        [request setHTTPMethod:"POST"];
        [request setValue:"application/x-www-form-urlencoded" forHTTPHeaderField:"Content-Type"];
        var connection = [CPURLConnection connectionWithRequest:request delegate:self];
        lastTimestamp = aTimestamp;
    }
    
    return self;
}

- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
    var newTimestamp;
    try {
        var newMessages = JSON.parse(data);
        [[[CPApplication sharedApplication] delegate] renderUpdates:newMessages];
        newTimestamp = newMessages[newMessages.length - 1].ts;
    } catch(error) {
        newTimestamp = lastTimestamp;
        setTimeout(function(){CPLog.debug("Connection broke with error \"" + error + "\"; waiting a second. ")}, 1000);
    }
    // TODO: can we reuse the existing connection?
    var newConnection = [[UpdateConnection alloc] initWithTimestamp: newTimestamp];
}

-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
    CPLog.debug("Failed with error: " + error);
}

@end