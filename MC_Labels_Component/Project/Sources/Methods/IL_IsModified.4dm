//%attributes = {"invisible":true}
// IL_IsModified
// Goal: return if the label has been modified
// Parameters:
// Author and creation date: FD 17.09.2025
/* Changes (Author date and goal):
*/

#DECLARE : Boolean

var $T_Current; $T_Origin : Text

DOM EXPORT TO VAR:C863((OBJECT Get pointer:C1124(Object named:K67:5; "object"))->dom; $T_Current)
$T_Origin:=(OBJECT Get pointer:C1124(Object named:K67:5; "object"))->origin

return ($T_Current#$T_Origin)