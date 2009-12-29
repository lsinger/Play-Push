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
    var newConnection = [[UpdateConnection alloc] initWithTimestamp: newTimestamp];
}

-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
    CPLog.debug("Failed with error: " + error);
}

@end