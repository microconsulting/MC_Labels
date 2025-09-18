//%attributes = {"invisible":true}
// IL_SaveLabel
// Goal: Save current label format and return it in blob in returned object
// Parameters:
// Author and creation date: FD 17.09.2025
/* Changes (Author date and goal):
*/

#DECLARE : Boolean

var $O_Form : Object
var $X_Format : Blob

$O_Form:=(OBJECT Get pointer:C1124(Object named:K67:5; "object"))->

DOM EXPORT TO VAR:C863($O_Form.dom; $X_Format)

If (OK=1)
	Form:C1466.X_LabelContent:=$X_Format
End if 

return (OK=1)
