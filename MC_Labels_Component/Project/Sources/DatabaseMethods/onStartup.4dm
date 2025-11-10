// On Startup
// Author and creation date: ??
/* Changes (Author date and goal):
*/

var $T_ : Text
var $L_ : Integer

// MARK:-: DO NOT DELETE, MC SETUP AUTOMATED BUILDS
If (Not:C34(Is compiled mode:C492))
	
	$L_:=Get database parameter:C643(User param value:K37:94; $T_)  // 108
	
	Case of 
		: ($T_="build@")
			BUILD APPLICATION:C871(Replace string:C233($T_; "build@"; ""))
			QUIT 4D:C291
			
	End case 
	
End if 


If (Not:C34(Is compiled mode:C492))
	
	ARRAY TEXT:C222($componentsArray; 0)
	COMPONENT LIST:C1001($componentsArray)
	
	If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
		
		// Installing quickOpen
		EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
		ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
		
	End if 
End if 
