//%attributes = {"invisible":true,"preemptive":"capable"}
// _VersionToText
// Goal: Convert a longint version to it's text value.
// Parameters:
// $L_Version, Integer: The version to convert.
// ->, Text: The converted version. 
// Author and creation date: MK 20.08.24
/* Changes (Author date and goal):
*/


#DECLARE($L_Version : Integer)->$T_Version : Text

var $L_Major; $L_Minor; $L_TypeCode; $L_Revision : Integer
var $T_TypeChar : Text
var $C_TypeMap : Collection

$C_TypeMap:=["d"; "a"; "b"; "r"]
$L_Major:=($L_Version >> 24) & 0x00FF
$L_Minor:=($L_Version >> 16) & 0x00FF
$L_TypeCode:=($L_Version >> 12) & 0x000F
$L_Revision:=$L_Version & 0x0FFF

$T_TypeChar:=$C_TypeMap[$L_TypeCode]

$T_Version:=String($L_Major)+"."+String($L_Minor)
$T_Version+=($L_Revision>0) ? $T_TypeChar+String($L_Revision) : ""

return $T_Version