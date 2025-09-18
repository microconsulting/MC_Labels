//%attributes = {"invisible":true,"preemptive":"capable"}
// _GetVersion
// Goal: Convert a version string or a version longint into its counterpart
// Parameters:
// $V_Version, Variant: Either a Text or an Integer.
// ->, Variant: The converted version. Either a Text or an Integer
// Author and creation date: MK 20.08.24
/* Changes (Author date and goal):
*/

#DECLARE($V_Version : Variant) : Variant

var $L_ValueType : Integer

$L_ValueType:=Value type($V_Version)

Case of 
	: ($L_ValueType=Is longint)
		return _VersionToText($V_Version)
		
	: ($L_ValueType=Is text)
		return _VersionToInt($V_Version)
		
	Else 
		return "INVALID TYPE"
		
End case 
