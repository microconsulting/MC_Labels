//%attributes = {"invisible":true,"preemptive":"capable"}
// _VersionToInt
// Goal: Convert a version string to it's longint value.
// Parameters:
// $T_Version, Text: The version to convert.
// ->, Integer: The converted version. 
// Author and creation date: MK 20.08.24
/* Changes (Author date and goal):
*/

#DECLARE($T_Version : Text) : Integer

var $L_Major; $L_Minor; $L_TypeCode; $L_Revision; $L_Position : Integer
var $T_TypeChar; $T_MinorType : Text
var $C_Parts : Collection
var $O_TypeMap : Object

ASSERT(Match regex("(\\d+)(\\.(\\d+)?([dabr])?(\\d+)?)?"; $T_Version))

$O_TypeMap:={}
$O_TypeMap.d:=0
$O_TypeMap.a:=1
$O_TypeMap.b:=2
$O_TypeMap.r:=3

$C_Parts:=Split string($T_Version; ".")

$L_Major:=Num($C_Parts[0])

Case of 
	: ($C_Parts.length>1)
		$T_MinorType:=$C_Parts[1]
		
End case 

For each ($T_TypeChar; $O_TypeMap) Until ($L_Position>0)
	$L_Position:=Position($T_TypeChar; $T_MinorType)
End for each 

If ($L_Position<1)
	$T_TypeChar:="r"
End if 

$L_Minor:=Num(Substring($T_MinorType; 1; $L_Position-1))
$L_Revision:=Num(Substring($T_MinorType; $L_Position))
$L_TypeCode:=$O_TypeMap[$T_TypeChar]

return ($L_Major << 24) | ($L_Minor << 16) | ($L_TypeCode << 12) | $L_Revision
