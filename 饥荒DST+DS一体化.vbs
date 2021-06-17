
'---- 描述
' 1.你需要下载好Steam联机版与服务器程序
' 2.获取你的token,并按常规流程存储你的Cluster文件夹里
' 3.涉及的所有路径需要其磁盘文件系统为NTFS
' ----
' !!!!请修改此脚本中的 [自定义设定] 内容为符合你电脑饥荒的设定
' ----
' 符合以上要求即可继续
'┆ 使你联机版与服务器共用 集群(Cluster) 与 模组(MOD) ,从联机版对[集群]修改,与从服务器运行一致
'┆ 便于从联机版配置 [集群]或[模组] 设置后,可直接作为服务器启动.
'┆  当你从联机版新建\修改一个[集群],完成后联机版退出该[集群](也就是回到主界面)
'┆  再从此处启动服务器,或你自己的方式启动
'┆  如果 新增\删除 模组,再启动前执行一次 [c.部署MOD]
'┆


'----

'联机版路径
Const Path_DST = "D:\_Game\Game_Steam\common\Don't Starve Together\"
'服务器路径
Const Path_DSTDS = "D:\_Game\Game_Steam\common\Don't Starve Together Dedicated Server\"
'Steam Workshop 322330路径   如果没有,请自行创建文件夹
Const Path_322330 = "D:\_Game\Game_Steam\workshop\content\322330\"
'文档 Klei路径
Const Path_Klei = "D:\_Doc\Klei\"
'集群文件夹如果有纯数字的文件夹 即你UID文件夹, 有则写
Const DST_UID = ""

'---- init

Set GEOM_FSO		= CreateObject("Scripting.FileSystemObject")
Set GEOM_SA 		= CreateObject("Shell.Application")
Set GEOM_WSS		= CreateObject("WScript.Shell")
Set GEOM_SD 		= CreateObject("Scripting.Dictionary")

Set CS = New BaseCS

Const ScriptName = "饥荒DST+DS一体化  by:Rex.Pack v:1.2"
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

Echo "┆  饥荒联机版控制台联机命令参考"
Echo "┆  c_connect(""127.0.0.1"",10999)  '免防火墙"
Echo "┆  c_connect(""loaclhost"",10999)"
Echo "┆  c_connect(""s.es-geom.com"",10999,""password"")"
Echo "---- 确认"
Echo "联机版路径:" & IIf(tfFolder(Path_DST),"存在","错误")
Echo "└ " & Path_DST_Mod
Echo "服务器路径:" & IIf(tfFolder(Path_DSTDS),"存在","错误")
Echo "└ " & Path_DSTDS_Mod
Echo "Workshop路径:" & IIf(tfFolder(Path_322330),"存在","错误")
Echo "└ " & Path_322330
Echo "文档路径:" & IIf(tfFolder(Path_Klei),"存在","错误")
Echo "└ " & Path_Klei
Echo "文档DST路径:" & IIf(tfFolder(Path_Klei_DST),"存在","错误")
Echo "└ " & Path_Klei_DST
Echo "文档DSTR路径:" & IIf(tfFolder(Path_Klei_DSTR),"存在","错误")
Echo "└ " & Path_Klei_DSTR
Echo "----"

Call Main()

'---- Sub
Sub Main()
	Dim CM
	GEOM_SD.RemoveAll
	GEOM_SD.Add "a", "EndVBS"
	GEOM_SD.Add "b", "link_Cluster"
	GEOM_SD.Add "c", "link_MOD"
	Text = ""
	
	InText "a: 退出"
	InText "b: 部署集群"
	InText "c: 部署模组"
	InText "----"
	InText "选择启动的集群:"
	
	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_Klei_DST & DST_UID).SubFolders
	I = 0
	For Each GEOM_TempDataVar In GEOM_TFO
		If Left(GEOM_TempDataVar.Name,8) = "Cluster_" Then
			GEOM_SD.Add CStr(I), GEOM_TempDataVar
			Dim Cluster_Name,Cluster_OffLine,Max_Players
			
			If tfFile(GEOM_TempDataVar & "\cluster.ini") Then
				For Each Line In Split(ReadUTF8(GEOM_TempDataVar & "\cluster.ini"), vbCrLf)
					If Not Line = "" Then
						TempData = Split(Line,"=")
						Select Case LCase(Trim(TempData(0)))
						Case "cluster_name"
							Cluster_Name = Trim(TempData(1))
						Case "offline_cluster"
							Cluster_OffLine = LCase(Trim(TempData(1)))
						Case "max_players"
							Max_Players = Trim(TempData(1))
						End Select
					End If
				Next
			End If
			InText(I+1 & ": " & GEOM_TempDataVar.Name & " | " & Cluster_Name & " | " & IIf(Cluster_OffLine="false","线上","本地")) & " | " & "人数上限:" & Max_Players
			InText(" ├ 地面:" & IIf(tfFolder(GEOM_TempDataVar & "\Master"),"存在","无"))
			InText(" ├ 洞穴:" & IIf(tfFolder(GEOM_TempDataVar & "\Caves"),"存在","无"))
			If tfFile(GEOM_TempDataVar & "\cluster_token.txt") Then
				Set Token = GEOM_FSO.GetFile(GEOM_TempDataVar & "\cluster_token.txt")
				InText(" └ Token: " & Token.DateLastModified )
			Else
				InText(" └ Token: 无")
			End If
			
			I = I + 1
		End If
	Next
	
	
	CM = Trim(InputBox(Text, ScriptName,"",0,0))
	Select Case True
	Case CM = ""
	Case IsNumeric(CM)
		If GEOM_SD.Exists(CM-1) Then
			[启动地面命令] = "cmd /c Start" & _
				" ""饥荒 - 地面""" & _
				" /d" & _
				" " & PathC34(Path_DSTDS & "bin\") & _
				" cmd /t:0b /k  " & PathC34(Path_DSTDS & "bin\dontstarve_dedicated_server_nullrenderer") & _
				" -console " & _
				" -cluster " & PathC34(DST_UID & USplit(GEOM_SD.Item(CM),"\")) & _
				" -shard Master"
			Echo [启动地面命令]
			Echo Run([启动地面命令])
			
			If tfFolder(GEOM_SD.Item(CM) & "\Caves") Then
				[启动洞穴命令] = "cmd /c Start" & _
					" ""饥荒 - 洞穴""" & _
					" /d" & _
					" " & PathC34(Path_DSTDS & "bin\") & _
					" cmd /t:0d /k  " & PathC34(Path_DSTDS & "bin\dontstarve_dedicated_server_nullrenderer") & _
					" -console " & _
					" -cluster " & PathC34(DST_UID & USplit(GEOM_SD.Item(CM),"\")) & _
					" -shard Caves"
				Echo [启动洞穴命令]
				Echo Run([启动洞穴命令])
			End If
		Else
			Echo "System: 无此集群."
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
	CS.Print "警告:将会先删除 " & Path_Klei_DSTR & " 文件夹,请确保其内容不再需要.(y\n)"
	If CS.Input = "y" Then
		Call Exec("cmd /c rd /q " & PathC34(Path_Klei_DSTR))
		Call mklink(Path_Klei_DSTR, Path_Klei_DST)
	End If
End Sub

Sub link_MOD()
	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_DSTDS_Mod).SubFolders
	For Each GEOM_TempDataVar In GEOM_TFO
		Echo "移除:" & GEOM_TempDataVar
		Call Exec("cmd /c rd /q " & PathC34(GEOM_TempDataVar))
	Next
	
	'Set GEOM_TFO = GEOM_FSO.GetFolder(Path_322330).SubFolders
	'For Each GEOM_TempDataVar In GEOM_TFO
	'	Echo "移除:" & GEOM_TempDataVar
	'	Call Exec("cmd /c rd " & PathC34(GEOM_TempDataVar))
	'Next
	
	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_DST_Mod).SubFolders
	For Each GEOM_TempDataVar In GEOM_TFO
		Echo "链接:" & PathC34(GEOM_TempDataVar)
		'If tfFolder(PathC34(Path_DSTDS_Mod & GEOM_TempDataVar.Name)) Then
		Set state = mklink( PathC34(Path_DSTDS_Mod & GEOM_TempDataVar.Name), PathC34(GEOM_TempDataVar))
		If state.Status = 0 Then state.Terminate
	Next

	Set GEOM_TFO = GEOM_FSO.GetFolder(Path_322330).SubFolders
	For Each GEOM_TempDataVar In GEOM_TFO
		Echo "链接:" & PathC34(GEOM_TempDataVar)
		If tfFolder(PathC34(Path_DSTDS_Mod & GEOM_TempDataVar.Name)) Then
			Echo "跳过:" & GEOM_TempDataVar.Name
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

Sub Sleep(ByVal S)						'延迟:毫秒
  WScript.Sleep S
 End Sub

Function mklink(ByVal PathN,ByVal PathS)
	Set mklink = Exec( "cmd /c mklink /j " & PathC34(PathN) & " " & PathC34(PathS) )
	'If state.Status = 0 Then state.Terminate
End Function

Function Exec(ByVal GEOM_ProgramPath)		'运行程序 Exec 方式 待改
  On Error Resume Next
  Set ExeCM = GEOM_WSS.Exec(GEOM_ProgramPath)
	'echo ExeCM.StdOut.ReadAll
	Call Sleep(40)
  If EIF(True, False) = False Then Set Exec = Nothing Else Set Exec = ExeCM
 End Function

Function Run(ByVal GEOM_ProgramPath)		'运行程序 Run 方式 待改
  On Error Resume Next
  GEOM_WSS.Run GEOM_ProgramPath
  Run = EIF(True, Err.Description)
 End Function
 
Sub CScript(ByVal CSave)	'改用CScript宿主模式重新启动, CSave = True Then 保留CMD
	If Not NowSHE = "cscript.exe" Then
		GEOM_WSS.Run "cmd /t:e0 /q " & _
			IIf(CSave = True, "/k", "/c") & _
			" Title " & ScriptName & " & " & _
			" CScript //nologo " & PathC34(GEOM_FullName) & _
			" " & PathC34(ScriptFullName) & GEOM_ReRun
		EndVBS
	End If
 End Sub
 
Sub EndVBS()					'退出脚本
	WScript.Quit
 End Sub

Function USplit(ByVal GEOM_String, ByVal GEOM_Delimiter)
	GEOM_TempArray = Split(GEOM_String, GEOM_Delimiter)
	USplit = GEOM_TempArray(UBound(GEOM_TempArray))
 End Function

Sub Echo(ByVal GEOM_TempData)
	WScript.Echo GEOM_TempData
 End Sub

Function IIf(ByVal GEOM_tf, ByVal GEOM_T, ByVal GEOM_F)	'VB的IIf
	If GEOM_tf Then IIF = GEOM_T Else IIF = GEOM_F
 End Function
 
Function EIF(ByVal GEOM_T, ByVal GEOM_F)	'除错版IIF
	EIF = IIf(Err.Number = 0, GEOM_T, GEOM_F)
	If Not Err.Number = 0 Then Err.Clear
 End Function
 
Sub MBT(ByVal GEOM_T)							'当True时不进行提示,以便审阅代码正确性
	If Not GEOM_T = True Then Echo GEOM_T
 End Sub
Sub MBE(ByVal GEOM_TempData)					'当无错时不进行提示,以便审阅代码正确性
	If Err.Number <> 0 Then Echo GEOM_TempData: Err.Clear
 End Sub
 

Function PathC34(ByVal GEOM_FP)			'判断路径中是否含有空格,没有则去除"号 有则添加上""
	If InStr(GEOM_FP, " ") = 0 Then
		PathC34 = Replace(GEOM_FP, Chr(34), "")
	Else
		PathC34 = IIf(Left(GEOM_FP, 1) = Chr(34), "", Chr(34)) & GEOM_FP & IIf(Right(GEOM_FP, 1) = Chr(34), "", Chr(34))
	End If
 End Function
 
Function PathCC(ByVal GEOM_FP)			'去除路径的""号,无论有没有空格
	PathCC = Replace(GEOM_FP, Chr(34), "")
 End Function

Function tfFile(ByVal GEOM_FilePath)		'文件是否存在
	tfFile = IIf(GEOM_FSO.FileExists(PathCC(GEOM_FilePath)) = False, False, True)
 End Function
 
Function tfFolder(ByVal GEOM_FilePath)		'文件夹是否存在
	tfFolder = IIf(GEOM_FSO.FolderExists(PathCC(GEOM_FilePath)) = False, False, True)
 End Function
 
Function CopyFile(ByVal GEOM_FPA, ByVal GEOM_FPB, ByVal GEOM_TF)		'复制文件
  On Error Resume Next
  GEOM_FSO.CopyFile PathC34(GEOM_FPA), PathC34(GEOM_FPB), IIf(GEOM_TF = False, False, True)
  CopyFile = EIf(True, Err.Description)
 End Function
Function CopyFolder(ByVal GEOM_FPA, ByVal GEOM_FPB, ByVal GEOM_TF)		'复制文件夹
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

    Function InPut()'输入函数
		On Error Resume Next
        GetInD = WScript.StdIn.ReadLine
		If Err.Number <> 0 Then PrintL "": PrintL Err.Description
		InPut = EIF(GetInD, Err.Description)
    End Function
 End Class
