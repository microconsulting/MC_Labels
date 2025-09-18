//%attributes = {"invisible":true}
// IL_ParseVariable
// Goal: Parse a variable containing the label content
// Parameters:
// Author and creation date: FD 17.09.2025
/* Changes (Author date and goal):
*/

#DECLARE($X_LabelContent : Blob; $B_WithPrintSettings : Boolean) : Text

var $Blb_buffer : Blob
var $Boo_converted; $Boo_OK : Boolean
var $Lon_parameters; $Lon_version; $i : Integer
var $Dom_; $Dom_label; $Txt_onErrorMethod; $t; $T_LabelContent : Text

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	//Required parameters
	//$File_path:=$1  //path of the label document
	
	//Optional parameters
	If ($Lon_parameters>=2)
		
		//$Boo_withPrintSettings:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
//SET ASSERT ENABLED(True)
If (BLOB size:C605($X_LabelContent)>0)
	$T_LabelContent:=BLOB to text:C555($X_LabelContent; UTF8 C string:K22:15)
Else   // empty blob = new format => load default file content
	$T_LabelContent:=File:C1566(Folder:C1567(fk resources folder:K87:11).platformPath+"default.4lbp"; fk platform path:K87:2).getText()
End if 


If ($T_LabelContent="<?xml@")
	
	$Dom_label:=DOM Parse XML variable:C720($T_LabelContent)
	
	// #ACI0100054 {
	// Don't omit to update Resources/default.4lbp
	If (OK=1)
		
		xml_GET_ATTRIBUTE_BY_NAME($Dom_label; "version"; ->$Lon_version)
		
		If ($Lon_version<2)
			
			//fix ACI0100054
			ARRAY TEXT:C222($tDom_objects; 0x0000)
			$tDom_objects{0}:=DOM Find XML element:C864($Dom_label; "label/objects/object"; $tDom_objects)
			
			If (OK=1)
				
				
				For ($i; 1; Size of array:C274($tDom_objects); 1)
					
					DOM GET XML ATTRIBUTE BY NAME:C728($tDom_objects{$i}; "type"; $t)
					
					If ($t="round-rect")
						
						DOM SET XML ATTRIBUTE:C866($tDom_objects{$i}; \
							"rx"; Num:C11(<>label_params.defaultRoundRect); \
							"ry"; Num:C11(<>label_params.defaultRoundRect))
						
					End if 
				End for 
				
				$Lon_version:=2
				
			End if 
			
			DOM SET XML ATTRIBUTE:C866($Dom_label; "version"; $Lon_version)
			
		End if 
	End if   //}
	
Else 
	$Dom_label:=parse_data(->$X_LabelContent; $B_WithPrintSettings)
	
	$Boo_converted:=True:C214
	
End if 

// Store the converted status or not
OB SET:C1220((OBJECT Get pointer:C1124(Object named:K67:5; "object"))->; "converted"; $Boo_converted)

// Add missing elements if any
If (Asserted:C1132(xml_IsValidReference($Dom_label)))
	
	$Dom_:=DOM Find XML element:C864($Dom_label; "label/selects")
	
	If (OK=0)
		
		$Dom_:=DOM Create XML element:C865($Dom_label; "selects"; "id"; "selects")
		
	End if 
	
	$Dom_:=DOM Find XML element:C864($Dom_label; "label/objects")
	
	If (OK=0)
		
		$Dom_:=DOM Create XML element:C865($Dom_label; "objects"; "id"; "objects")
		
	End if 
	
End if 

// ----------------------------------------------------
// Return
return $Dom_label

// ----------------------------------------------------
// End