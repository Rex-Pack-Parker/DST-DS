
'---- ����
' 1.����Ҫ���غ�Steam�����������������
' 2.��ȡ���token,�����������̴洢���Cluster�ļ�����
' ----
' !!!!���޸Ĵ˽ű��е� [�Զ����趨] ����Ϊ��������Լ��ĵ��趨
' ----
' ��������Ҫ�󼴿ɼ���
'�� ʹ������������������� ��Ⱥ(Cluster) �� ģ��(MOD) ,���������[��Ⱥ]�޸�,��ӷ���������һ��
'�� ���ڴ����������� [��Ⱥ]��[ģ��] ���ú�,��ֱ����Ϊ����������.
'��  ������������½�\�޸�һ��[��Ⱥ],��ɺ��������˳���[��Ⱥ](Ҳ���ǻص�������)
'��  �ٴӴ˴�����������,�����Լ��ķ�ʽ����
'��  ��� ����\ɾ�� ģ��,������ǰִ��һ�� [2.ͬ��MOD]
'��


'----

'������·��
Const Path_DST = "D:\_Game\Game_Steam\common\Don't Starve Together\"
'������·��
Const Path_DSTDS = "D:\_Game\Game_Steam\common\Don't Starve Together Dedicated Server\"
'Steam Workshop 322330·��   ���û��,�����д����ļ���
Const Path_322330 = "D:\_Game\Game_Steam\workshop\content\322330\"
'�ĵ� Klei·��
Const Path_Klei = "D:\_Doc\Klei\"
'��Ⱥ�ļ�������д����ֵ��ļ��� ����UID�ļ���, ����д
Const DST_UID = ""

'---- init

Set GEOM_FSO		= CreateObject("Scripting.FileSystemObject")
Set GEOM_SA 		= CreateObject("Shell.Application")
Set GEOM_WSS		= CreateObject("WScript.Shell")
Set GEOM_SD 		= CreateObject("Scripting.Dictionary")

Set CS = New BaseCS

Const ScriptName = "����DST+DSһ�廯  by:Rex.Pack v:1.2"
Dim ScriptFilePath, ScriptFullName, Command, NowSHE
Dim Text

NowSHE = LCase(USplit(WScript.FullName, "\"))
ScriptFullName = WScript.ScriptFullName
ScriptFilePath = Replace(WScript.ScriptFullName, WScript.ScriptName, "")


CScript True
'----Run
'CS.Input
Dim Path_Klei_DST, Path_Klei_DSTR, Path_DST_Mod, Path_DSTDS_Mod
Path_Klei_DST = Path_Klei & "DoNotStarveTogether\"
Path_Klei_DSTR = Path_Klei & "DoNotStarveTogetherRail\"
Path_DST_Mod = Path_DST & "mods\"
Path_DSTDS_Mod = Path_DSTDS & "mods\"

Echo "��  �������������̨��������ο�"
Echo "��  c_connect(""127.0.0.1"",10999)  '�����ǽ"
Echo "��  c_connect(""loaclhost"",10999)"
Echo "��  c_connect(""s.es-geom.com"",10999,""password"")"
Echo "---- ȷ��"
Echo "������·��:" & IIf(tfFolder(Path_DST),"����","����")
Echo "�� " & Path_DST_Mod
Echo "������·��:" & IIf(tfFolder(Path_DSTDS),"����","����")
Echo "�� " & Path_DSTDS_Mod
Echo "Workshop·��:" & IIf(tfFolder(Path_322330),"����","����")
Echo "�� " & Path_322330
Echo "�ĵ�·��:" & IIf(tfFolder(Path_Klei),"����","����")
Echo "�� " & Path_Klei
Echo "�ĵ�DST·��:" & IIf(tfFolder(Path_Klei_DST),"����","����")
Echo "�� " & Path_Klei_DST
Echo "�ĵ�DSTR·��:" & IIf(tfFolder(Path_Klei_DSTR),"����","����")
Echo "�� " & Path_Klei_DSTR
Echo "----"

Call Main()

'---- Sub
Sub Main()
	Dim CM
	GEOM_SD.RemoveAll
	GEOM_SD.Add "a", "EndVBS"
	GEOM_SD.Add "b", "link_Cluster"
	GEOM_SD.Add "c", "link_MOD"
	GEOM_SD.Add "0", ""
	Text = ""
	
	InText "a: �˳�"
	InText "b: ����Ⱥ"
	InText "c: ����ģ��"
	InText "----"
	InText "ѡ�������ļ�Ⱥ:"
	
	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_Klei_DST & DST_UID).SubFolders
	For Each GEOM_TempDataVar In GEOM_TFO
		If Left(GEOM_TempDataVar.Name,8) = "Cluster_" Then
			I = I + 1
			GEOM_SD.Add CStr(I), GEOM_TempDataVar
			Dim Cluster_Name,Cluster_OffLine
			
			If tfFile(GEOM_TempDataVar & "\cluster.ini") Then
				For Each Line In Split(ReadUTF8(GEOM_TempDataVar & "\cluster.ini"), vbCrLf)
					If Not Line = "" Then
						TempData = Split(Line,"=")
						Select Case LCase(Trim(TempData(0)))
						Case "cluster_name"
							Cluster_Name = Trim(TempData(1))
						Case "offline_cluster"
							Cluster_OffLine = LCase(Trim(TempData(1)))
						End Select
					End If
				Next
			End If
			InText(I & ": " & GEOM_TempDataVar.Name & " - " & Cluster_Name & " - " & IIf(Cluster_OffLine="false","����","����"))
			InText(" �� ����:" & IIf(tfFolder(GEOM_TempDataVar & "\Master"),"����","��"))
			InText(" �� ��Ѩ:" & IIf(tfFolder(GEOM_TempDataVar & "\Caves"),"����","��"))
			If tfFile(GEOM_TempDataVar & "\cluster_token.txt") Then
				Set Token = GEOM_FSO.GetFile(GEOM_TempDataVar & "\cluster_token.txt")
				InText(" �� Token: " & Token.DateLastModified )
			Else
				InText(" �� Token: ��")
			End If
			
		End If
	Next
	
	
	CM = Trim(InputBox(Text, ScriptName))
	Select Case True
	Case CM = ""
	Case IsNumeric(CM)
		If GEOM_SD.Exists(CM) Then
			[������������] = "cmd /c Start" & _
				" ""���� - ����""" & _
				" /d" & _
				" " & PathC34(Path_DSTDS & "bin\") & _
				" cmd /t:0b /k  " & PathC34(Path_DSTDS & "bin\dontstarve_dedicated_server_nullrenderer") & _
				" -console " & _
				" -cluster " & PathC34(DST_UID & USplit(GEOM_SD.Item(CM),"\")) & _
				" -shard Master"
			Echo [������������]
			Echo Run([������������])
			
			If tfFolder(GEOM_SD.Item(CM) & "\Caves") Then
				[������Ѩ����] = "cmd /c Start" & _
					" ""���� - ��Ѩ""" & _
					" /d" & _
					" " & PathC34(Path_DSTDS & "bin\") & _
					" cmd /t:0d /k  " & PathC34(Path_DSTDS & "bin\dontstarve_dedicated_server_nullrenderer") & _
					" -console " & _
					" -cluster " & PathC34(DST_UID & USplit(GEOM_SD.Item(CM),"\")) & _
					" -shard Caves"
				Echo [������Ѩ����]
				Echo Run([������Ѩ����])
			End If
		Else
			Echo "System: �޴˼�Ⱥ."
		End If
	Case Else
		Select Case CM
		Case "a","b","c"
			Execute GEOM_SD.Item(CM)
		End Select
	End Select
	Call Main()
End Sub

Sub link_Cluster()
	CS.Print "����:������ɾ�� " & Path_Klei_DSTR & " �ļ���,��ȷ�������ݲ�����Ҫ.(y\n)"
	If CS.Input = "y" Then
		Call Exec("cmd /c rd /q " & PathC34(Path_Klei_DSTR))
		Call mklink(Path_Klei_DSTR, Path_Klei_DST)
	End If
End Sub

Sub link_MOD()
	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_DSTDS_Mod).SubFolders
	For Each GEOM_TempDataVar In GEOM_TFO
		Echo "�Ƴ�:" & GEOM_TempDataVar
		Call Exec("cmd /c rd /q " & PathC34(GEOM_TempDataVar))
	Next
	
	'Set GEOM_TFO = GEOM_FSO.GetFolder(Path_322330).SubFolders
	'For Each GEOM_TempDataVar In GEOM_TFO
	'	Echo "�Ƴ�:" & GEOM_TempDataVar
	'	Call Exec("cmd /c rd " & PathC34(GEOM_TempDataVar))
	'Next
	
	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_DST_Mod).SubFolders
	For Each GEOM_TempDataVar In GEOM_TFO
		Echo "����:" & PathC34(GEOM_TempDataVar)
		'If tfFolder(PathC34(Path_DSTDS_Mod & GEOM_TempDataVar.Name)) Then
		Set state = mklink( PathC34(Path_DSTDS_Mod & GEOM_TempDataVar.Name), PathC34(GEOM_TempDataVar))
		If state.Status = 0 Then state.Terminate
	Next

	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_322330).SubFolders
	For Each GEOM_TempDataVar In GEOM_TFO
		Echo "����:" & PathC34(GEOM_TempDataVar)
		If tfFolder(PathC34(Path_DSTDS_Mod & GEOM_TempDataVar.Name)) Then
			Echo "����:" & GEOM_TempDataVar.Name
		Else
			Set state = mklink( PathC34(Path_DSTDS_Mod & "workshop-" & GEOM_TempDataVar.Name), PathC34(GEOM_TempDataVar) )
			If state.Status = 0 Then state.Terminate
		End If
	Next
End Sub

Function InText(ByVal Str)
	Text = Text & Str & vbCrLf
End Function


'---- Function
Function ReadUTF8(filePath)
	Set Stream = CreateObject("Adodb.Stream")
	Stream.Type = 2
	Stream.mode = 3
	Stream.charset = "utf-8"
	Stream.Open
	Stream.LoadFromFile filePath
	ReadUTF8 = Stream.readtext
	Stream.close
End Function

Sub Sleep(ByVal S)						'�ӳ�:����
  WScript.Sleep S
 End Sub

Function mklink(ByVal PathN,ByVal PathS)
	Set mklink = Exec( "cmd /c mklink /j " & PathC34(PathN) & " " & PathC34(PathS) )
	'If state.Status = 0 Then state.Terminate
End Function

Function Exec(ByVal GEOM_ProgramPath)		'���г��� Exec ��ʽ ����
  On Error Resume Next
  Set ExeCM = GEOM_WSS.Exec(GEOM_ProgramPath)
	'echo ExeCM.StdOut.ReadAll
	Call Sleep(40)
  If EIF(True, False) = False Then Set Exec = Nothing Else Set Exec = ExeCM
 End Function

Function Run(ByVal GEOM_ProgramPath)		'���г��� Run ��ʽ ����
  On Error Resume Next
  GEOM_WSS.Run GEOM_ProgramPath
  Run = EIF(True, Err.Description)
 End Function
 
Sub CScript(ByVal CSave)	'����CScript����ģʽ��������, CSave = True Then ����CMD
	If Not NowSHE = "cscript.exe" Then
		GEOM_WSS.Run "cmd /t:e0 /q " & _
			IIf(CSave = True, "/k", "/c") & _
			" Title " & ScriptName & " & " & _
			" CScript //nologo " & PathC34(GEOM_FullName) & _
			" " & PathC34(ScriptFullName) & GEOM_ReRun
		EndVBS
	End If
 End Sub
 
Sub EndVBS()					'�˳��ű�
	WScript.Quit
 End Sub

Function USplit(ByVal GEOM_String, ByVal GEOM_Delimiter)
	GEOM_TempArray = Split(GEOM_String, GEOM_Delimiter)
	USplit = GEOM_TempArray(UBound(GEOM_TempArray))
 End Function

Sub Echo(ByVal GEOM_TempData)
	WScript.Echo GEOM_TempData
 End Sub

Function IIf(ByVal GEOM_tf, ByVal GEOM_T, ByVal GEOM_F)	'VB��IIf
	If GEOM_tf Then IIF = GEOM_T Else IIF = GEOM_F
 End Function
 
Function EIF(ByVal GEOM_T, ByVal GEOM_F)	'�����IIF
	EIF = IIf(Err.Number = 0, GEOM_T, GEOM_F)
	If Not Err.Number = 0 Then Err.Clear
 End Function
 
Sub MBT(ByVal GEOM_T)							'��Trueʱ��������ʾ,�Ա����Ĵ�����ȷ��
	If Not GEOM_T = True Then Echo GEOM_T
 End Sub
Sub MBE(ByVal GEOM_TempData)					'���޴�ʱ��������ʾ,�Ա����Ĵ�����ȷ��
	If Err.Number <> 0 Then Echo GEOM_TempData: Err.Clear
 End Sub
 

Function PathC34(ByVal GEOM_FP)			'�ж�·�����Ƿ��пո�,û����ȥ��"�� ���������""
	If InStr(GEOM_FP, " ") = 0 Then
		PathC34 = Replace(GEOM_FP, Chr(34), "")
	Else
		PathC34 = IIf(Left(GEOM_FP, 1) = Chr(34), "", Chr(34)) & GEOM_FP & IIf(Right(GEOM_FP, 1) = Chr(34), "", Chr(34))
	End If
 End Function
 
Function PathCC(ByVal GEOM_FP)			'ȥ��·����""��,������û�пո�
	PathCC = Replace(GEOM_FP, Chr(34), "")
 End Function

Function tfFile(ByVal GEOM_FilePath)		'�ļ��Ƿ����
	tfFile = IIf(GEOM_FSO.FileExists(PathCC(GEOM_FilePath)) = False, False, True)
 End Function
 
Function tfFolder(ByVal GEOM_FilePath)		'�ļ����Ƿ����
	tfFolder = IIf(GEOM_FSO.FolderExists(PathCC(GEOM_FilePath)) = False, False, True)
 End Function
 
Function CopyFile(ByVal GEOM_FPA, ByVal GEOM_FPB, ByVal GEOM_TF)		'�����ļ�
  On Error Resume Next
  GEOM_FSO.CopyFile PathC34(GEOM_FPA), PathC34(GEOM_FPB), IIf(GEOM_TF = False, False, True)
  CopyFile = EIf(True, Err.Description)
 End Function
Function CopyFolder(ByVal GEOM_FPA, ByVal GEOM_FPB, ByVal GEOM_TF)		'�����ļ���
  On Error Resume Next
  GEOM_FSO.CopyFolder PathC34(GEOM_FPA), PathC34(GEOM_FPB), IIf(GEOM_TF = False, False, True)
  CopyFolder = EIf(True, Err.Description)
 End Function
 
Function DeleteFile(ByVal GEOM_FPA)
	On Error Resume Next
	GEOM_FSO.DeleteFile PathC34(GEOM_FPA)
	DeleteFile = EIf(True, Err.Description)
End Function

Function DeleteFolder(ByVal GEOM_FPA)
	On Error Resume Next
	GEOM_FSO.DeleteFolder PathC34(GEOM_FPA)
	DeleteFolder = EIf(True, Err.Description)
End Function


'---- Class

Class BaseCS
    Sub Print(Texts)
        WScript.StdOut.Write(Texts)
    End Sub

    Sub PrintL(Texts)
        WScript.StdOut.WriteLine(Texts)
    End Sub

    Function InPut()'���뺯��
		On Error Resume Next
        GetInD = WScript.StdIn.ReadLine
		If Err.Number <> 0 Then PrintL "": PrintL Err.Description
		InPut = EIF(GetInD, Err.Description)
    End Function
 End Class