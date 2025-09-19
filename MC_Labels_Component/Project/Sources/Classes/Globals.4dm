// Class Globals
// Goal:
// Author and creation date: MK 20.08.24
/* Changes (Author date and goal):
   FD 18.09.25, 8.0b1
   FD 18.09.25, 8.0b2
   FD 19.09.25, 8.0b3
*/

/**
#class
#description
Singleton instance holding globals.
#properties
VERSION Text // The current version of the component.
**/

property VERSION : Text

singleton Class constructor
	
Function get VERSION : Text
	return "8.0b3"