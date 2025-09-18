//%attributes = {"invisible":true,"shared":true}
// ILBL_EditLabel
// Goal: Show label editor
// Parameters:
// Author and creation date: FD 16.09.2025
/* Changes (Author date and goal):
*/

#DECLARE($L_MasterTable : Integer; $X_LabelContent : Blob; $B_AutoClose : Boolean) : Object

var $Boo_autoClose : Boolean
var $Lon_masterTable; $Lon_parameters; $Win_hdl; $L_CountParam : Integer
var $Dir_resources; $Txt_labelDocument; $T_LabelContent : Text
var $O_Form : Object


// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	COMPILER_wizard
	
	//NO PARAMETERS REQUIRED
	
	//defaults values
	$L_CountParam:=Count parameters:C259
	If ($L_CountParam<1)
		$L_MasterTable:=-1
	End if 
	
	If ($L_CountParam<2)
		$T_LabelContent:=""
	End if 
	
	If ($L_CountParam<3)
		$B_AutoClose:=False:C215
	End if 
	
	C_MASTER_TABLE:=$L_MasterTable
	C_LABEL_DOCUMENT:=""
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (C_MASTER_TABLE>=0)
	
	$O_Form:={X_LabelContent: $X_LabelContent}
	If ($Boo_autoClose)
		
		$Win_hdl:=Open form window:C675("LABEL_WIZARD"; Plain form window:K39:10; *)
		DIALOG:C40("LABEL_WIZARD"; $O_Form; *)
		
	Else 
		
		$Win_hdl:=Open form window:C675("LABEL_WIZARD"; Movable form dialog box:K39:8; *)
		DIALOG:C40("LABEL_WIZARD"; $O_Form)
		CLOSE WINDOW:C154($Win_hdl)
		
	End if 
End if 

// ----------------------------------------------------
return {B_Success: (OK=1); X_LabelContent: $O_Form.X_LabelContent}