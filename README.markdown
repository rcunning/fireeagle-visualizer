# Fire Eagle Visualizer AIR app for developers

Fire Eagle Visualizer is an AIR app that shows real-time user location updates on a map using the Fire Eagle XMPP features.

## Getting started

Download a copy of fireeagle-visualizer:

[fireeagle-visualizer](http://github.com/rcunning/fireeagle-visualizer/tree/master# "fireeagle-visualizer")


Or clone fireeagle-visualizer source from github:

    $ git clone git://github.com/rcunning/fireeagle-visualizer.git


Download the other required sources:

[fireeagle-as3](http://github.com/rcunning/fireeagle-as3/tree/master# "fireeagle-as3")

[Yahoo! Y!OS AS3 library](http://developer.yahoo.com/flash/yos/ "Y!OS AS3 library")

[Seesmic AS3 XMPP library](http://code.google.com/p/seesmic-as3-xmpp/ "Seesmic AS3 XMPP library")

[Yahoo! Maps AS3 Component](http://developer.yahoo.com/flash/maps/ "Yahoo! Maps AS3 Component")


Setup:

    Download fireeagleas3tester to <your extract path>
    Download Fire Eagle AS3 classes to <your extract path>
    Download YOS to <your extract path>
    Download Seemic XMPP to <your extract path>
    Create a new workspace in Flex Builder 3+. 
    Import fireeagleas3tester Flex project 
      Right (or control) click in Flex Navigator, choose Import...
      select Flex Builder/Flex Project, click Next
      use project folder = <your extract path>/fireeagleas3tester
      uncheck 'Use default location'
      Finish
    Configure source directories
      Select Window->Preferences...
      General->Workspace->Linked Resources
      New... Name: FE_SRC, Location: <your extract path>
      Ok, Ok
    Make sure all source paths map correctly
      Right (or control) click on fireeagleas3tester project in Flex Navigator
      Select Flex Build Path
      Verify all paths are correct: src (FE AS3 classes), yos_as3_sdk (might have to change version), Seesmic XMPP (might not be in /seesmic-as3-xmpp-read-only)
    Optionally init your OAuth values
      Open fireeagleas3tester.mxml code edit in fireeagleas3tester project src
      Edit 'init values for OAuth params' near top
    All set to run!


## Want TODO:

Add SharedObject session store for OAuth values and XMPP login credentials


## Getting Help

Your best bet for help is to post a message to the Fire Eagle Yahoo! Group:
[http://tech.groups.yahoo.com/group/fireeagle/](http://tech.groups.yahoo.com/group/fireeagle/ "Fire Eagle Yahoo! Group")

See [http://fireeagle.yahoo.net](http://fireeagle.yahoo.net "Fire Eagle") for more info.
