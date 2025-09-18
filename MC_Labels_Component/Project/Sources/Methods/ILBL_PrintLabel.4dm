//%attributes = {"invisible":true,"shared":true}
// ILBL_PrintLabel
// Goal: Print the label
// Parameters:
// Author and creation date: FD 17.09.2025
/* Changes (Author date and goal):
*/

// ----------------------------------------------------
// Project method : C_Print_label
// Database: 4D Labels
// ID[9F9C4D578CED4E42909F143CCD47BF55]
// Created #19-2-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
//PRINT LABEL ( {aTable }{;}{ document {; * | >}} )
//aTable     Table     Table to print, or Default table, if omitted
//document   String    Name of disk label document
//* | >               * to suppress the printing dialog boxes, or > to not reinitialize print settings
//
// ----------------------------------------------------
// Declarations

#DECLARE($L_MasterTable : Integer; $X_LabelContent : Blob; $T_Option : Text; $F_ProgressCallback : 4D:C1709.Function; $B_PreviewMode : Boolean) : Integer

var $Blb_buffer : Blob
var $Boo_OK; $Boo_withPrintSettings : Boolean
var $Lon_bottom; $Lon_error; $Lon_height; $Lon_left; $Lon_orientation; $Lon_parameters; $Lon_right; $Lon_top; $Lon_width : Integer
var $Pic_buffer : Picture
var $Ptr_table : Pointer
var $Dom_label; $File_; $File_path; $Txt_form; $Txt_onErrorMethod; $T_Content : Text
var $file; $o : Object

ARRAY LONGINT:C221($tLon_records; 0)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	ASSERT:C1129(4D_LOG("Begin C_PRINT_LABEL"))
	
	ASSERT:C1129(4D_LOG("Table id: "+String:C10($L_MasterTable)))
	
	COMPILER_LABELS
	LABELS_INIT
	
	//Optional parameters
	If ($Lon_parameters>=3)
		ASSERT:C1129(4D_LOG("Options: "+$T_Option))
		
	End if 
	
	If ($Lon_parameters<4)
		$F_ProgressCallback:=Null:C1517
	End if 
	
	If ($Lon_parameters<5)
		$B_PreviewMode:=False:C215
	End if 
	
	$Ptr_table:=Table:C252($L_MasterTable)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Is nil pointer:C315($Ptr_table))
		
		$Lon_error:=17  //A table was expected
		
		ASSERT:C1129(4D_LOG("A table was expected"))
		
		//______________________________________________________
	: (Records in selection:C76($Ptr_table->)=0)
		
		$Lon_error:=1138  //Selection is Null
		
		ASSERT:C1129(4D_LOG("Selection is Null"))
		
		//______________________________________________________
	: (BLOB size:C605($X_LabelContent)=0)
		
		$Lon_error:=1122
		
		ASSERT:C1129(4D_LOG("BLOB is Null"))
		
	Else 
		$T_Content:=BLOB to text:C555($X_LabelContent; UTF8 C string:K22:15)
		
		If ($T_Content="form:@")  //
			// Current form name prefixed with "form:"
			$Txt_form:=Delete string:C232($File_path; 1; 5)
			
			ASSERT:C1129(4D_LOG("Form: "+$Txt_form))
			
			$Dom_label:=DOM Parse XML source:C719(Get 4D folder:C485(Current resources folder:K5:16)+"default.4lbp")
			DOM SET XML ATTRIBUTE:C866(DOM Find XML element by ID:C1010($Dom_label; "form"); "name"; $Txt_form)
			
			//#ACI0099882
			//FORM SCREENSHOT($Ptr_table->;$Txt_form;$Pic_buffer)
			//PICTURE PROPERTIES($Pic_buffer;$Lon_width;$Lon_height)
			//CLEAR VARIABLE($Pic_buffer)
			FORM GET PROPERTIES:C674($Ptr_table->; $Txt_form; $Lon_width; $Lon_height)
			
			//#ACI0104365
			//#ACI0100146 ===========================================================================================================
			//If (Bool(Get database parameter(Is host database a project)))
			//If (Is compiled mode(*))
			//$file:=Folder(fk database folder; *).files().query("extension = :1"; ".4DZ").pop()
			//If (Bool($file.exists))
			//$file:=ZIP Read archive($file).root.file("Project/Sources/TableForms/"+String($L_MasterTable)+"/"+$Txt_form+"/form.4DForm")
			//End if 
			//Else 
			//$file:=Folder(fk database folder; *).file("Project/Sources/TableForms/"+String($L_MasterTable)+"/"+$Txt_form+"/form.4DForm")
			//End if 
			//If ($file.exists)
			//$o:=JSON Parse($file.getText())
			//End if 
			//Else 
			//If (Is compiled mode(*))
			//// NO WAY OUT
			//Else 
			//$o:=FORM Convert to dynamic($Ptr_table->; $Txt_form)
			//End if 
			//End if 
			//If ($o#Null)
			//$Lon_height:=Num($o.markerBody)-Num($o.markerHeader)  // MarkerHeader is undefined if equal to 0
			//Else 
			//FORM SCREENSHOT($Ptr_table->; $Txt_form; $Pic_buffer)
			//PICTURE PROPERTIES($Pic_buffer; $Lon_width; $Lon_height)
			//CLEAR VARIABLE($Pic_buffer)
			//End if 
			//=======================================================================================================================
			
			DOM SET XML ATTRIBUTE:C866(DOM Find XML element by ID:C1010($Dom_label; "size"); \
				"width"; $Lon_width; \
				"height"; $Lon_height)
			
			GET PRINTABLE MARGIN:C711($Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
			DOM SET XML ATTRIBUTE:C866(DOM Find XML element by ID:C1010($Dom_label; "margin"); \
				"left"; $Lon_left; \
				"top"; $Lon_top; \
				"right"; $Lon_right; \
				"bottom"; $Lon_bottom)
			
			$Boo_OK:=(OK=1)
		Else 
			$Boo_OK:=True:C214
		End if 
		
		//______________________________________________________
End case 

If ($Boo_OK)
	If ($T_Content="<?xml@")  // 4lbp
		$Dom_label:=DOM Parse XML variable:C720($T_Content)
	Else   // 4lb
		$Dom_label:=parse_data(->$X_LabelContent; $Boo_withPrintSettings)
	End if 
	
	If (Length:C16($Dom_label)>0)
		
		Case of 
				
				//………………………………………………………………
			: ($T_Option="*")
				
				//The * parameter causes a print job using the current print parameters.
				
				//………………………………………………………………
			: ($T_Option=">")
				
				//Furthermore, the > parameter causes a print job without reinitializing the
				//current print parameters. This setting is useful for executing several
				//successive calls to PRINT LABEL (ex. inside a loop) while maintaining previously
				//set customized print parameters.
				
				//………………………………………………………………
			Else 
				
				PRINT SETTINGS:C106
				
				$Boo_OK:=(OK=1)
				
				//………………………………………………………………
		End case 
		
		If ($Boo_OK)
			
			GET PRINT OPTION:C734(Orientation option:K47:2; $Lon_orientation)
			
			DOM SET XML ATTRIBUTE:C866(DOM Find XML element by ID:C1010($Dom_label; "setting"); \
				"landscape"; ($Lon_orientation=2))
			
			//print
			If ($F_ProgressCallback=Null:C1517)
				$Lon_error:=Print_Label($L_MasterTable; $Dom_label; $B_PreviewMode)
			Else 
				$Lon_error:=Print_Label($L_MasterTable; $Dom_label; $B_PreviewMode; $F_ProgressCallback)
			End if 
			
			ASSERT:C1129(4D_LOG(Choose:C955($Lon_error=0; "No error"; "Error: "+String:C10($Lon_error))))
			
		Else 
			
			$Lon_error:=-128  //Printing interrupted by the user
			
			ASSERT:C1129(4D_LOG("Printing interrupted by the user"))
			
		End if 
		
		DOM CLOSE XML:C722($Dom_label)
		
	Else 
		
		If ($Lon_error=0)
			
			$Lon_error:=-9914  //Internal fault
			
			ASSERT:C1129(4D_LOG("Internal fault"))
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Lon_error

// ----------------------------------------------------
// End