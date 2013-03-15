AppRecorder
===========
Record you app user sessions and save them to the Photos app. 

##How to use
Added AppRecorder to your app in 4 simple steps:

**1)** Add AppRecorder.h & AppRecorder.m to your project.

**2)** Import AppRecorder.h where you would like to use it.
```objective-c
#import "AppRecorder.h"
````
**3)** Initialize an instance of AppRecorder 
```objective-c
AppRecorder *appRecorder = [[AppRecorder alloc] init];
````
**4)** Start & stop recording
```objective-c
[appRecorder start];

&

[appRecorder stop];
```` 
The recorded video is automatically stored into the Photos app on your iPhone.

##Roadmap
- Add audio recording funtionality to capture the user's voice along with the session. This would be great for recording How-To videos & tutorials for your App.
- Saving to multiple sources (Youtube, Dropbox) for easy distribution of the recorded videos.

##License

    Copyright (C) 2013 Neehar Cherabuddi (neehar@shoutt.me)
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
    documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
    the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
    and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all copies or substantial portions 
    of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
    TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
    IN THE SOFTWARE.
