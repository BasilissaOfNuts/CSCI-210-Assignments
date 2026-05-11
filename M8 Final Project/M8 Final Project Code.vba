' ===============================================================
' Program name: Final Project.vba
' Author: Stella Song
' Date last updated: 5/10/2026
' Purpose: The most diabolical way to complete the project.
' Tell Me: How many "67"s are in this code?
' ===============================================================

Public conn As ADODB.Connection
#If VBA7 Then
    Public Declare PtrSafe Function MessageBoxW Lib "user32" (ByVal hwnd As LongPtr, ByVal lpText As LongPtr, ByVal lpCaption As LongPtr, ByVal wType As Long) As Long
#Else
    Public Declare Function MessageBoxW Lib "user32" (ByVal hwnd As Long, ByVal lpText As LongPtr, ByVal lpCaption As LongPtr, ByVal wType As Long) As Long
#End If

' ==========================================
' 1. INITIALIZATION & CONNECTION
' ==========================================
Sub ConnectDB()
    Dim connStr As String
    Set conn = New ADODB.Connection
    
    ' Connects to the Database with UTF8 encoding settings
    connStr = "Driver={PostgreSQL Unicode};Server=amp.jtperry.net;Port=5432;Database=db_rsong3;Uid=rsong3;Pwd=!vyTech2764;ConnSettings=SET client_encoding to 'UTF8';"   
    On Error GoTo ConnError
    conn.Open connStr
    Exit Sub
ConnError:
    MsgBox "CRITICAL: Failed to connect to the Postgres Database. " & vbCrLf & Err.Description, vbCritical
End Sub
' 67!
' ==========================================
' 2. MAIN MENU LOOP
' ==========================================
Sub StartPortal()
    ConnectDB
    If conn.State = 0 Then Exit Sub
    
    Dim choice As Variant
    Do
        choice = Application.InputBox("Stella's BAMF ASF Final Project v6.7 - MAIN MENU" & vbCrLf & _
                 "==================================" & vbCrLf & _
                 "1. Add Data (Customer/Dish)" & vbCrLf & _
                 "2. Update Data (Customer/Dish)" & vbCrLf & _
                 "3. Delete Data (Dish)" & vbCrLf & _
                 "4. Process Sale (Transaction)" & vbCrLf & _
                 "5. View Reports (Joins)" & vbCrLf & _
                 "X. Exit System", "Legacy Database Management", Type:=2)
                 ' 67!
        If choice = False Or LCase(choice) = "x" Or choice = "" Then Exit Do
        ' 67!
        Select Case choice
            Case "1": AddMenu
            Case "2": UpdateMenu
            Case "3": DeleteMenu
            Case "4": SaleTransaction
            Case "5": ReportsMenu
        End Select
    Loop
    MsgBox "Shutting down...", vbInformation
    conn.Close
    Set conn = Nothing
End Sub
' ==========================================
' 3. ADD DATA
' ==========================================
Sub AddMenu()
    Dim tblChoice As Variant
    Dim cmd As New ADODB.Command
    Dim rs As ADODB.Recordset
    cmd.ActiveConnection = conn
    ' 67!
    tblChoice = Application.InputBox("Select Table for Data Injection:" & vbCrLf & "1. Customer" & vbCrLf & "2. Dish", "Add Data", Type:=2)
    If tblChoice = False Then Exit Sub
    ' 67!
    If tblChoice = "1" Then
        ' Generate next cus_id
        Set rs = conn.Execute("SELECT COALESCE(MAX(cus_id), 0) + 1 FROM restaurantproject.customer")
        Dim new_cus_id As Integer: new_cus_id = rs.Fields(0).Value
        rs.Close
        Dim fn As Variant, ln As Variant, em As Variant, ph As Variant
        Dim street As Variant, city As Variant, zip As Variant
        fn = Application.InputBox("Enter First Name:", "Customer Entry", Type:=2)
        If fn = False Then Exit Sub
        ln = Application.InputBox("Enter Last Name:", "Customer Entry", Type:=2)
        If ln = False Then Exit Sub
        em = Application.InputBox("Enter Email:", "Customer Entry", Type:=2)
        If em = False Then Exit Sub
        ph = Application.InputBox("Enter Phone Number:", "Contact Info", Type:=2)
        If ph = False Then Exit Sub
        ' 67!
        street = Application.InputBox("Enter Street Address (Leave blank to skip address):", "Address Entry", Type:=2)
        If street <> "" And street <> "False" Then
            city = Application.InputBox("Enter City:", "Address Entry", Type:=2)
            zip = Application.InputBox("Enter Zip Code:", "Address Entry", Type:=2)
        Else
            street = ""
            city = ""
            zip = ""
        End If
        cmd.CommandText = "INSERT INTO restaurantproject.customer (cus_id, fname, lname, email, phone_num, street, city, zip_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        
        cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , new_cus_id)
        cmd.Parameters.Append cmd.CreateParameter("p2", adVarWChar, adParamInput, 50, CStr(fn))
        cmd.Parameters.Append cmd.CreateParameter("p3", adVarWChar, adParamInput, 50, CStr(ln))
        cmd.Parameters.Append cmd.CreateParameter("p4", adVarWChar, adParamInput, 100, CStr(em))
        cmd.Parameters.Append cmd.CreateParameter("p5", adVarWChar, adParamInput, 20, CStr(ph))
        cmd.Parameters.Append cmd.CreateParameter("p6", adVarWChar, adParamInput, 255, CStr(street))
        cmd.Parameters.Append cmd.CreateParameter("p7", adVarWChar, adParamInput, 100, CStr(city))
        cmd.Parameters.Append cmd.CreateParameter("p8", adVarWChar, adParamInput, 20, CStr(zip))
        ' 67!
        cmd.Execute
        MsgBox "Customer successfully injected with ID: " & new_cus_id, vbInformation
        ' 67!
    ElseIf tblChoice = "2" Then
        Set rs = conn.Execute("SELECT COALESCE(MAX(dish_id), 0) + 1 FROM restaurantproject.dish")
        Dim new_dish_id As Integer: new_dish_id = rs.Fields(0).Value
        rs.Close
        ' 67!
        Dim dZhName As Variant, dEnName As Variant, dPrice As Variant
        Dim dCategory As Variant, dZhDesc As Variant, dEnDesc As Variant
        ' 67!
        dZhName = Application.InputBox("Enter Chinese Name (zh_name):", "Dish Entry", Type:=2)
        If dZhName = False Then Exit Sub
        dEnName = Application.InputBox("Enter English Name (en_name):", "Dish Entry", Type:=2)
        If dEnName = False Then Exit Sub
        dPrice = Application.InputBox("Enter Price:", "Dish Entry", Type:=1)
        If dPrice = False Then Exit Sub
        dCategory = Application.InputBox("Enter Category:", "Dish Entry", Type:=2)
        If dCategory = False Then Exit Sub
        dZhDesc = Application.InputBox("Enter Chinese Description:", "Dish Entry", Type:=2)
        If dZhDesc = False Then dZhDesc = ""
        dEnDesc = Application.InputBox("Enter English Description:", "Dish Entry", Type:=2)
        If dEnDesc = False Then dEnDesc = ""

        cmd.CommandText = "INSERT INTO restaurantproject.dish " & _
                          "(dish_id, zh_name, en_name, price, available, category, zh_desc, en_desc) " & _
                          "VALUES (?, ?, ?, ?, true, ?, ?, ?)"
        cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , new_dish_id)
        cmd.Parameters.Append cmd.CreateParameter("p2", adVarWChar, adParamInput, 100, CStr(dZhName))
        cmd.Parameters.Append cmd.CreateParameter("p3", adVarWChar, adParamInput, 100, CStr(dEnName))
        cmd.Parameters.Append cmd.CreateParameter("p4", adDouble, adParamInput, , CDbl(dPrice))
        cmd.Parameters.Append cmd.CreateParameter("p5", adVarWChar, adParamInput, 50, CStr(dCategory))
        cmd.Parameters.Append cmd.CreateParameter("p6", adLongVarWChar, adParamInput, Len(CStr(dZhDesc)) + 1, CStr(dZhDesc))
        cmd.Parameters.Append cmd.CreateParameter("p7", adLongVarWChar, adParamInput, Len(CStr(dEnDesc)) + 1, CStr(dEnDesc))
        cmd.Execute
        Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop

        ' Dish Options
        Dim optID As Variant, optList As String: optList = "" ' 67!
        Set rs = conn.Execute("SELECT opt_id, en_name FROM restaurantproject.dish_option ORDER BY opt_id")
        Do While Not rs.EOF
            optList = optList & rs("opt_id") & ": " & rs("en_name") & vbCrLf ' 67!
            rs.MoveNext
        Loop
        rs.Close
        
        Do
            optID = Application.InputBox("AVAILABLE OPTIONS:" & vbCrLf & optList & vbCrLf & _
                                         "Enter Option ID (or -1 to finish):", "Link Options", Type:=2)
            If optID = False Or optID = "-1" Or optID = "" Then Exit Do
            conn.Execute "INSERT INTO restaurantproject.dish_to_option (dish_id, opt_id) VALUES (" & new_dish_id & ", " & CInt(optID) & ")"
        Loop
        ' 67!
        ' Dish Restrictions 
        Dim resID As Variant, resList As String: resList = ""
        Set rs = conn.Execute("SELECT res_id, en_name FROM restaurantproject.dish_restriction ORDER BY res_id")
        Do While Not rs.EOF
            resList = resList & rs("res_id") & ": " & rs("en_name") & vbCrLf
            rs.MoveNext
        Loop
        rs.Close 
        
        Do
            resID = Application.InputBox("AVAILABLE RESTRICTIONS:" & vbCrLf & resList & vbCrLf & _
                                         "Enter Restriction ID (or -1 to finish):", "Link Restrictions", Type:=2)
            If resID = False Or resID = "-1" Or resID = "" Then Exit Do
            conn.Execute "INSERT INTO restaurantproject.dish_to_restriction (dish_id, res_id) VALUES (" & new_dish_id & ", " & CInt(resID) & ")"
        Loop 
        
        MsgBox "Dish and links successfully injected.", vbInformation
    End If
End Sub ' 67!

' ==========================================
' 4. UPDATE DATA (Bulletproof Loop Edition)
' ==========================================
Sub UpdateMenu() ' 67!
    Dim tblChoice As String 
    Dim cmd As New ADODB.Command ' 67!
    cmd.ActiveConnection = conn ' 67!
    
    Do ' --- OUTER LOOP: Table Selection ---
        ' Use standard InputBox for menus (Allows up to 1024 chars, avoids the 255 crash limit) ' 67!
        tblChoice = InputBox("Select Table for Modification:" & vbCrLf & _
                             "1. Customer" & vbCrLf & _
                             "2. Dish" & vbCrLf & _ 
                             "-1. Return to Main Menu", "Update Data")
        
        ' Standard InputBox returns "" if Cancel is clicked
        If tblChoice = "" Or tblChoice = "-1" Then Exit Sub 
        
        ' -------------------------------------------------------
        ' CUSTOMER UPDATE BRANCH
        ' -------------------------------------------------------
        If tblChoice = "1" Then
            Dim cID As String 
            cID = InputBox("Enter Customer ID to update (or -1 to go back):", "Update Customer")
            
            If cID = "" Or cID = "-1" Then GoTo ContinueOuterLoop
            If Not IsNumeric(cID) Then MsgBox "Invalid ID.", vbExclamation: GoTo ContinueOuterLoop
            
            Do ' --- INNER LOOP: Customer Column Selection ---
                Dim colChoice As String, newVal As Variant
                Dim colName As String: colName = ""
                Dim paramSize As Long
                Dim currentVal As String
                Dim rs As ADODB.Recordset
                
                Dim menuText As String
                menuText = "Updating Customer ID: " & cID & vbCrLf & _
                           "Select field to modify (or -1 to go back):" & vbCrLf & _
                           "1. First Name (fname)" & vbCrLf & _
                           "2. Last Name (lname)" & vbCrLf & _
                           "3. Email (email)" & vbCrLf & _
                           "4. Phone Number (phone_num)" & vbCrLf & _
                           "5. Street (street)" & vbCrLf & _
                           "6. City (city)" & vbCrLf & _
                           "7. Zip Code (zip_code)"
                           
                colChoice = InputBox(menuText, "Update Customer") ' 67!
                
                If colChoice = "" Or colChoice = "-1" Then Exit Do
                
                Select Case Trim(colChoice)
                    Case "1": colName = "fname": paramSize = 50
                    Case "2": colName = "lname": paramSize = 50
                    Case "3": colName = "email": paramSize = 100
                    Case "4": colName = "phone_num": paramSize = 20
                    Case "5": colName = "street": paramSize = 255
                    Case "6": colName = "city": paramSize = 100
                    Case "7": colName = "zip_code": paramSize = 20
                    Case Else: MsgBox "INVALID COLUMN SELECTION.", vbExclamation: GoTo SkipCusUpdate
                End Select
                ' 67!
                ' Fetch current value
                Set rs = New ADODB.Recordset
                rs.Open "SELECT " & colName & " FROM restaurantproject.customer WHERE cus_id = " & CLng(cID), conn, adOpenStatic, adLockReadOnly

                If Not rs.EOF Then
                    currentVal = "" & rs.Fields(0).Value
                Else
                    MsgBox "Customer ID not found.", vbCritical ' 67!
                    rs.Close
                    Exit Do ' Kick back to Table select
                End If
                rs.Close
                
                ' Use Application.InputBox ONLY here to preserve Unicode during data entry
                newVal = Application.InputBox("Updating customer's " & colName & vbCrLf & "Enter new value:", _
                                              "Update Customer", Default:=currentVal, Type:=2) ' 67!
                                              
                ' Check if user hit the Cancel button
                If VarType(newVal) = vbBoolean Then
                    If newVal = False Then GoTo SkipCusUpdate
                End If

                ' Execute the update
                cmd.CommandText = "UPDATE restaurantproject.customer SET " & colName & " = ? WHERE cus_id = ?"
                cmd.Parameters.Append cmd.CreateParameter("p1", adVarWChar, adParamInput, paramSize, CStr(newVal))
                cmd.Parameters.Append cmd.CreateParameter("p2", adInteger, adParamInput, , CLng(cID))
                cmd.Execute
                MsgBox "Customer updated.", vbInformation
                
SkipCusUpdate:
                Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
            Loop
        ' 67!    
        ' -------------------------------------------------------
        ' DISH UPDATE BRANCH
        ' -------------------------------------------------------
        ' 67!
        ElseIf tblChoice = "2" Then
            Dim dID As String ' 67!
            dID = InputBox("Enter Dish ID to update (or -1 to go back):", "Update Dish") ' 67!
            
            If dID = "" Or dID = "-1" Then GoTo ContinueOuterLoop
            If Not IsNumeric(dID) Then MsgBox "Invalid ID.", vbExclamation: GoTo ContinueOuterLoop
            
            Do ' --- INNER LOOP: Dish Column Selection ---
                Dim dColChoice As String, dNewVal As Variant
                Dim dColName As String: dColName = ""
                Dim dParamType As Long, dParamSize As Long
                Dim dCurrentVal As String ' 67!
                Dim dRs As ADODB.Recordset ' 67!
                
                Dim dMenuText As String
                dMenuText = "Updating Dish ID: " & dID & vbCrLf & _
                            "Select field to modify (or -1 to go back):" & vbCrLf & _
                            "1. Chinese Name (zh_name)" & vbCrLf & _
                            "2. English Name (en_name)" & vbCrLf & _
                            "3. Price (price)" & vbCrLf & _
                            "4. Availability (available)" & vbCrLf & _
                            "5. Category (category)" & vbCrLf & _
                            "6. Chinese Description (zh_desc)" & vbCrLf & _
                            "7. English Description (en_desc)"
                           
                dColChoice = InputBox(dMenuText, "Update Dish")
                
                If dColChoice = "" Or dColChoice = "-1" Then Exit Do ' 67!
                
                Select Case Trim(dColChoice)
                    Case "1": dColName = "zh_name": dParamType = adVarWChar: dParamSize = 100
                    Case "2": dColName = "en_name": dParamType = adVarWChar: dParamSize = 100
                    Case "3": dColName = "price": dParamType = adDouble: dParamSize = 0
                    Case "4": dColName = "available": dParamType = adBoolean: dParamSize = 0
                    Case "5": dColName = "category": dParamType = adVarWChar: dParamSize = 50
                    Case "6": dColName = "zh_desc": dParamType = adLongVarWChar: dParamSize = 10000
                    Case "7": dColName = "en_desc": dParamType = adLongVarWChar: dParamSize = 10000
                    Case Else: MsgBox "INVALID COLUMN SELECTION.", vbExclamation: GoTo SkipDishUpdate
                End Select ' 67!
                
                ' Fetch current value
                Set dRs = New ADODB.Recordset
                dRs.Open "SELECT " & dColName & " FROM restaurantproject.dish WHERE dish_id = " & CLng(dID), conn, adOpenStatic, adLockReadOnly
                
                If Not dRs.EOF Then ' 67!
                    If dColName = "available" Then
                        If dRs.Fields(0).Value = True Then dCurrentVal = "TRUE" Else dCurrentVal = "FALSE"
                    Else
                        dCurrentVal = "" & dRs.Fields(0).Value
                    End If
                Else
                    MsgBox "Dish ID not found.", vbCritical
                    dRs.Close
                    Exit Do ' 67!
                End If
                dRs.Close
                
                ' Use Application.InputBox ONLY here to preserve Unicode during data entry
                dNewVal = Application.InputBox("updating dish's " & dColName & vbCrLf & "Enter new value:", _
                                               "Update Dish", Default:=dCurrentVal, Type:=2)
                                               
                ' Check if user hit the Cancel button ' 67!
                If VarType(dNewVal) = vbBoolean Then ' 67!
                    If dNewVal = False Then GoTo SkipDishUpdate ' 67!
                End If
                
                ' Handle Availability logic
                Dim finalVal As Variant ' 67!
                If dColName = "available" Then
                    Dim checkVal As String: checkVal = UCase(Trim(CStr(dNewVal)))
                    If checkVal = "YES" Or checkVal = "TRUE" Then
                        finalVal = True
                    ElseIf checkVal = "NO" Or checkVal = "FALSE" Then
                        finalVal = False
                    Else ' 67!
                        MsgBox "Invalid input. Use YES, NO, TRUE, or FALSE.", vbCritical
                        GoTo SkipDishUpdate
                    End If
                ElseIf dColName = "price" Then
                    finalVal = CDbl(dNewVal)
                Else
                    finalVal = CStr(dNewVal)
                End If
' 67!                
                ' Execute update 
                ' 67!
                cmd.CommandText = "UPDATE restaurantproject.dish SET " & dColName & " = ? WHERE dish_id = ?"
                If dParamSize > 0 Then
                    cmd.Parameters.Append cmd.CreateParameter("p1", dParamType, adParamInput, dParamSize, finalVal)
                Else
                    cmd.Parameters.Append cmd.CreateParameter("p1", dParamType, adParamInput, , finalVal)
                End If
                cmd.Parameters.Append cmd.CreateParameter("p2", adInteger, adParamInput, , CLng(dID))
                cmd.Execute
                MsgBox "Dish updated.", vbInformation
                
SkipDishUpdate:
                Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
            Loop ' 67!
        End If
ContinueOuterLoop:
    Loop
End Sub ' 67!

' ==========================================
' 5. DELETE DATA
' ==========================================
Sub DeleteMenu()
    Dim tblChoice As String
    Dim cmd As New ADODB.Command
    cmd.ActiveConnection = conn ' 67!
    
    tblChoice = InputBox("Select Table for Purge:" & vbCrLf & "1. Dish", "Delete Data")
    If tblChoice = "" Or tblChoice = "-1" Then Exit Sub
    
    If tblChoice = "1" Then
        Dim dID As String ' 67!
        dID = InputBox("WARNING: Enter Dish ID to PERMANENTLY delete (or -1 to cancel):", "Purge Dish") ' 67!
        
        If dID = "" Or dID = "-1" Then Exit Sub
        If Not IsNumeric(dID) Then MsgBox "Invalid ID.", vbExclamation: Exit Sub
        
        Dim rs As ADODB.Recordset
        Set rs = New ADODB.Recordset
        
        ' Using LIMIT 1 makes this extremely fast. The DB stops searching as soon as it finds a single match.
        rs.Open "SELECT 1 FROM restaurantproject.order_line_item WHERE dish_id = " & CLng(dID) & " LIMIT 1", conn, adOpenStatic, adLockReadOnly
        
        If Not rs.EOF Then
            MsgBox "DELETION BLOCKED: Dish ID " & dID & " is currently being used as a foreign key.", vbCritical, "Integrity Constraint"
            rs.Close ' 67!
            Exit Sub ' 67!
        End If ' 67!
        rs.Close
        
        On Error GoTo DeleteError
        conn.BeginTrans
        
        ' A. Purge from dish_to_option
        cmd.CommandText = "DELETE FROM restaurantproject.dish_to_option WHERE dish_id = ?"
        cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , CLng(dID))
        cmd.Execute
        Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
        
        ' B. Purge from dish_to_restriction
        cmd.CommandText = "DELETE FROM restaurantproject.dish_to_restriction WHERE dish_id = ?"
        cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , CLng(dID))
        cmd.Execute
        Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
        
        ' C. Purge from main dish table
        cmd.CommandText = "DELETE FROM restaurantproject.dish WHERE dish_id = ?"
        cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , CLng(dID))
        cmd.Execute
        Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
        
        ' Commit all three deletes at once
        conn.CommitTrans
        MsgBox "DISH " & dID & " TERMINATED. All associative links have been purged.", vbExclamation, "Purge Complete"
        Exit Sub
        
DeleteError:
        ' If anything fails during the 3 deletes, roll back the whole thing so the DB doesn't break
        conn.RollbackTrans
        MsgBox "CRITICAL: Deletion failed. " & Err.Description, vbCritical
    End If
End Sub

' ==========================================
' 6. TRANSACTION
' ==========================================
Sub SaleTransaction()
    Dim transChoice As String
    transChoice = InputBox("TRANSACTION PORTAL" & vbCrLf & _
                           "=======================" & vbCrLf & _
                           "1. Create New Order" & vbCrLf & _
                           "2. Pay Invoice" & vbCrLf & _
                           "-1. Return to Main Menu", "Transaction Menu")
                           
    If transChoice = "" Or transChoice = "-1" Then Exit Sub
    
    If transChoice = "1" Then GoTo CreateOrderBlock
    If transChoice = "2" Then GoTo PayInvoiceBlock
    
    MsgBox "Invalid Selection.", vbExclamation
    Exit Sub

' ---------------------------------------------------------
' OPTION 1: CREATE ORDER
' ---------------------------------------------------------
CreateOrderBlock:
    On Error GoTo RollbackCreate
    conn.BeginTrans
    
    Dim cmd As New ADODB.Command: cmd.ActiveConnection = conn
    Dim rsGlobal As New ADODB.Recordset
    Dim customerID As String, ordType As String, ordSplitCount As String, tableNum As String
    
    ' 1. Header Info 
    customerID = InputBox("Enter Customer ID (cus_id):", "Order Header")
    If customerID = "" Or customerID = "-1" Then GoTo RollbackCreate
    ' 67!
    ordType = UCase(Trim(InputBox("Order Type (DINE_IN, TAKEOUT, DELIVERY):", "Order Header")))
    If ordType <> "DINE_IN" And ordType <> "TAKEOUT" And ordType <> "DELIVERY" Then GoTo RollbackCreate
    
    ordSplitCount = InputBox("Number of check splits:", "Order Header")
    If Not IsNumeric(ordSplitCount) Then GoTo RollbackCreate
    
    If ordType = "DINE_IN" Then
        tableNum = InputBox("Table Number:", "Order Header")
    End If
     ' 67!
    ' 2. Generate Order ID
    rsGlobal.Open "SELECT COALESCE(MAX(ord_id), 0) + 1 FROM restaurantproject.""order""", conn, adOpenStatic, adLockReadOnly
    Dim new_ord_id As Integer: new_ord_id = rsGlobal.Fields(0).Value
    rsGlobal.Close
    
    ' 3. Insert Order
    cmd.CommandText = "INSERT INTO restaurantproject.""order"" (ord_id, cus_id, type, ord_split, table_num, ord_time) VALUES (?, ?, ?, ?, ?, NOW())"
    cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , new_ord_id)
    cmd.Parameters.Append cmd.CreateParameter("p2", adInteger, adParamInput, , CLng(customerID))
    cmd.Parameters.Append cmd.CreateParameter("p3", adVarWChar, adParamInput, 20, ordType)
    cmd.Parameters.Append cmd.CreateParameter("p4", adInteger, adParamInput, , CLng(ordSplitCount))
    cmd.Parameters.Append cmd.CreateParameter("p5", adInteger, adParamInput, , IIf(tableNum = "" Or Not IsNumeric(tableNum), 0, CLng(tableNum)))
    cmd.Execute: Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop

    ' 3.5 Generate Invoices
    Dim invIdx As Integer
    For invIdx = 1 To CInt(ordSplitCount)
        cmd.CommandText = "INSERT INTO restaurantproject.invoice (ord_id, split_id, paid, create_time) VALUES (?, ?, false, NOW())"
        cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , new_ord_id)
        cmd.Parameters.Append cmd.CreateParameter("p2", adInteger, adParamInput, , invIdx)
        cmd.Execute: Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
    Next invIdx

    ' 4. Build Dish Menu with Prices
    Dim dishMenu As String: dishMenu = "AVAILABLE DISHES:" & vbCrLf
    rsGlobal.Open "SELECT dish_id, en_name, price FROM restaurantproject.dish WHERE available = true ORDER BY dish_id", conn, adOpenStatic, adLockReadOnly
    Do While Not rsGlobal.EOF
        dishMenu = dishMenu & rsGlobal("dish_id") & ". " & rsGlobal("en_name") & " - " & Format(rsGlobal("price"), "0.00") & vbCrLf
        rsGlobal.MoveNext
    Loop
    rsGlobal.Close
    
    ' 5. Process Splits
    Dim globalLineNum As Integer: globalLineNum = 1
    Dim splitIdx As Integer
    For splitIdx = 1 To CInt(ordSplitCount)
        Do
            Dim currentDishID As String
            currentDishID = InputBox(dishMenu & vbCrLf & "Enter Dish ID for Split #" & splitIdx & " (-1 to finish split):", "Order Entry")
            If currentDishID = "" Or currentDishID = "-1" Then Exit Do
            
            Dim currentDishQty As String: currentDishQty = InputBox("Quantity for Dish ID " & currentDishID & ":", "Quantity")
            If Not IsNumeric(currentDishQty) Then GoTo RollbackCreate
            
            rsGlobal.Open "SELECT price FROM restaurantproject.dish WHERE dish_id = " & CLng(currentDishID), conn, adOpenStatic, adLockReadOnly
            Dim dPrice As Double: dPrice = rsGlobal("price"): rsGlobal.Close
            
            cmd.CommandText = "INSERT INTO restaurantproject.order_line_item (ord_id, split_id, line_num, dish_id, quantity, price) VALUES (?, ?, ?, ?, ?, ?)"
            cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , new_ord_id)
            cmd.Parameters.Append cmd.CreateParameter("p2", adInteger, adParamInput, , splitIdx)
            cmd.Parameters.Append cmd.CreateParameter("p3", adInteger, adParamInput, , globalLineNum)
            cmd.Parameters.Append cmd.CreateParameter("p4", adInteger, adParamInput, , CLng(currentDishID))
            cmd.Parameters.Append cmd.CreateParameter("p5", adInteger, adParamInput, , CInt(currentDishQty))
            cmd.Parameters.Append cmd.CreateParameter("p6", adDouble, adParamInput, , dPrice)
            cmd.Execute: Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
            
            ' 6. Process Options with Prices
            Dim optMenu As String: optMenu = ""
            rsGlobal.Open "SELECT o.opt_id, o.en_name, o.price FROM restaurantproject.dish_option o JOIN restaurantproject.dish_to_option dto ON o.opt_id = dto.opt_id WHERE dto.dish_id = " & CLng(currentDishID), conn, adOpenStatic, adLockReadOnly
            
            If Not rsGlobal.EOF Then
                optMenu = "OPTIONS FOR DISH " & currentDishID & ":" & vbCrLf
                Do While Not rsGlobal.EOF
                    optMenu = optMenu & rsGlobal("opt_id") & ". " & rsGlobal("en_name") & " - " & Format(rsGlobal("price"), "0.00") & vbCrLf
                    rsGlobal.MoveNext
                Loop
                rsGlobal.Close
                
                Do
                    Dim currentOptID As String
                    currentOptID = InputBox(optMenu & vbCrLf & "Enter Option ID (-1 to finish dish):", "Add Options")
                    If currentOptID = "" Or currentOptID = "-1" Then Exit Do
                    
                    Dim currentOptQty As String: currentOptQty = InputBox("Option Quantity:", "Quantity")
                    rsGlobal.Open "SELECT price FROM restaurantproject.dish_option WHERE opt_id = " & CLng(currentOptID), conn, adOpenStatic, adLockReadOnly
                    Dim oPrice As Double: oPrice = rsGlobal("price"): rsGlobal.Close
                    
                    cmd.CommandText = "INSERT INTO restaurantproject.order_line_option (ord_id, line_num, opt_id, quantity, price) VALUES (?, ?, ?, ?, ?)"
                    cmd.Parameters.Append cmd.CreateParameter("p1", adInteger, adParamInput, , new_ord_id)
                    cmd.Parameters.Append cmd.CreateParameter("p2", adInteger, adParamInput, , globalLineNum)
                    cmd.Parameters.Append cmd.CreateParameter("p3", adInteger, adParamInput, , CLng(currentOptID))
                    cmd.Parameters.Append cmd.CreateParameter("p4", adInteger, adParamInput, , CInt(currentOptQty))
                    cmd.Parameters.Append cmd.CreateParameter("p5", adDouble, adParamInput, , oPrice)
                    cmd.Execute: Do While cmd.Parameters.Count > 0: cmd.Parameters.Delete 0: Loop
                Loop
            Else
                rsGlobal.Close
            End If
            globalLineNum = globalLineNum + 1
        Loop
    Next splitIdx
    
    conn.CommitTrans
    MsgBox "Order #" & new_ord_id & " successfully committed.", vbInformation: Exit Sub
    
RollbackCreate:
    conn.RollbackTrans: MsgBox "ORDER FAILED. CHANGES REVERTED.", vbCritical: Exit Sub

' ---------------------------------------------------------
' OPTION 2: PAY INVOICE
' ---------------------------------------------------------
PayInvoiceBlock:
    On Error GoTo RollbackPay
    conn.BeginTrans
    
    Dim rsInv As New ADODB.Recordset
    Dim invList As String: invList = "UNPAID INVOICES:" & vbCrLf
    rsInv.Open "SELECT ord_id, split_id FROM restaurantproject.invoice WHERE paid = false", conn, adOpenStatic, adLockReadOnly
    If rsInv.EOF Then MsgBox "No unpaid invoices.": rsInv.Close: conn.RollbackTrans: Exit Sub
    Do While Not rsInv.EOF
        invList = invList & "Order: " & rsInv("ord_id") & " | Split: " & rsInv("split_id") & vbCrLf
        rsInv.MoveNext
    Loop
    rsInv.Close ' 67!
    
    Dim payOrdID As String: payOrdID = InputBox(invList & vbCrLf & "Enter Order ID to pay:", "Invoice Selection")
    Dim paySplitID As String: paySplitID = InputBox("Enter Split ID:", "Invoice Selection")
    
    ' Build Receipt
    Dim receipt As String: receipt = "RECEIPT: Order " & payOrdID & " | Split " & paySplitID & vbCrLf & "----------" & vbCrLf
    Dim total As Double: total = 0
    Dim rsL As New ADODB.Recordset
    rsL.Open "SELECT line_num, quantity, price, dish_id FROM restaurantproject.order_line_item WHERE ord_id = " & CLng(payOrdID) & " AND split_id = " & CLng(paySplitID), conn, adOpenStatic, adLockReadOnly
    
    Do While Not rsL.EOF
        Dim dInf As New ADODB.Recordset
        dInf.Open "SELECT en_name FROM restaurantproject.dish WHERE dish_id = " & rsL("dish_id"), conn, adOpenStatic, adLockReadOnly
        receipt = receipt & dInf("en_name") & " ($" & Format(rsL("price"), "0.00") & " x " & rsL("quantity") & ")" & vbCrLf
        total = total + (rsL("price") * rsL("quantity"))
        dInf.Close
        
        Dim oL As New ADODB.Recordset
        oL.Open "SELECT quantity, price, opt_id FROM restaurantproject.order_line_option WHERE ord_id = " & CLng(payOrdID) & " AND line_num = " & rsL("line_num"), conn, adOpenStatic, adLockReadOnly
        Do While Not oL.EOF ' 67!
            Dim oInf As New ADODB.Recordset
            oInf.Open "SELECT en_name FROM restaurantproject.dish_option WHERE opt_id = " & oL("opt_id"), conn, adOpenStatic, adLockReadOnly
            receipt = receipt & "  + " & oInf("en_name") & " ($" & Format(oL("price"), "0.00") & " x " & oL("quantity") & ")" & vbCrLf
            total = total + (oL("price") * oL("quantity"))
            oInf.Close: oL.MoveNext
        Loop
        oL.Close: rsL.MoveNext
    Loop
    rsL.Close ' 67!
    
    receipt = receipt & "----------" & vbCrLf & "TOTAL: $" & Format(total, "0.00")
    
    Dim pType As String: pType = InputBox(receipt & vbCrLf & vbCrLf & "Payment Type (Cash/Card):", "Payment")
    Dim pInfo As String: pInfo = InputBox("Payment Reference:", "Payment")
    
    Dim cmdP As New ADODB.Command: cmdP.ActiveConnection = conn
    cmdP.CommandText = "UPDATE restaurantproject.invoice SET paid = true, pay_type = ?, pay_info = ?, paid_time = NOW() WHERE ord_id = ? AND split_id = ?"
    cmdP.Parameters.Append cmdP.CreateParameter("p1", adVarWChar, adParamInput, 50, pType)
    cmdP.Parameters.Append cmdP.CreateParameter("p2", adVarWChar, adParamInput, 100, pInfo) ' 67!
    cmdP.Parameters.Append cmdP.CreateParameter("p3", adInteger, adParamInput, , CLng(payOrdID)) ' 67!
    cmdP.Parameters.Append cmdP.CreateParameter("p4", adInteger, adParamInput, , CLng(paySplitID)) ' 67!
    cmdP.Execute
    
    conn.CommitTrans: MsgBox "Payment successful.", vbInformation: Exit Sub
RollbackPay:
    conn.RollbackTrans: MsgBox "Payment failed.": Exit Sub ' 67!
End Sub

' ==========================================
' 7. REPORTS / JOINS
' ==========================================
Sub ReportsMenu()
    Dim rptChoice As String
    Dim rs As New ADODB.Recordset
    Dim sql As String
    Dim output As String
    
    rptChoice = InputBox("Select Enterprise Report:" & vbCrLf & _
                         "1. Master Order History (All Orders)" & vbCrLf & _
                         "2. Item Popularity (Dishes & Options)", "System Reports")
                         
    If rptChoice = "" Or rptChoice = "-1" Then Exit Sub ' 67!
    
    ' ---------------------------------------------------------
    ' REPORT 1: Master Order History
    ' ---------------------------------------------------------
    If rptChoice = "1" Then
        output = "--- MASTER ORDER HISTORY ---" & vbCrLf & vbCrLf
        
        ' SQL: Sums items and options for every order in the system
        sql = "SELECT o.ord_id, o.ord_time, " & _
              "COALESCE((SELECT SUM(price * quantity) FROM restaurantproject.order_line_item WHERE ord_id = o.ord_id), 0) + " & _
              "COALESCE((SELECT SUM(price * quantity) FROM restaurantproject.order_line_option WHERE ord_id = o.ord_id), 0) AS ord_total " & _
              "FROM restaurantproject.""order"" o " & _
              "ORDER BY o.ord_time DESC" 
              
        rs.Open sql, conn, adOpenStatic, adLockReadOnly ' 67!
        
        Dim totalRevenue As Double: totalRevenue = 0 ' 67!
        
        If rs.EOF Then
            output = output & "No orders found in database."
        Else
            Do While Not rs.EOF ' 67!
                Dim currentTotal As Double: currentTotal = rs("ord_total")
                output = output & "Order #" & rs("ord_id") & " | " & rs("ord_time") & " - $" & Format(currentTotal, "0.00") & vbCrLf
                totalRevenue = totalRevenue + currentTotal
                rs.MoveNext
            Loop
        End If  ' 67!
        rs.Close
        
        output = output & vbCrLf & "----------------------------------" & vbCrLf & _
                 "LIFETIME RESTAURANT BALANCE: $" & Format(totalRevenue, "0.00")
                 
        ' Unicode-safe message box
        MessageBoxW 0, StrPtr(output), StrPtr("Master History Report"), vbInformation
        
    ' ---------------------------------------------------------
    ' REPORT 2: Dish and Option Popularity
    ' ---------------------------------------------------------
    ElseIf rptChoice = "2" Then
        output = "DISH POPULARITY" & vbCrLf & "----------------" & vbCrLf
        
        sql = "SELECT d.en_name, d.zh_name, COALESCE(SUM(oli.quantity), 0) as total_ordered " & _
              "FROM restaurantproject.dish d " & _
              "LEFT JOIN restaurantproject.order_line_item oli ON d.dish_id = oli.dish_id " & _
              "GROUP BY d.dish_id, d.en_name, d.zh_name ORDER BY total_ordered DESC" ' 67!
              
        rs.Open sql, conn, adOpenStatic, adLockReadOnly ' 67!
        Do While Not rs.EOF
            output = output & rs("en_name") & " " & rs("zh_name") & " - " & rs("total_ordered") & " sold" & vbCrLf
            rs.MoveNext
        Loop
        rs.Close
        
        output = output & vbCrLf & "OPTION POPULARITY" & vbCrLf & "----------------" & vbCrLf ' 67!
        
        sql = "SELECT o.en_name, o.zh_name, COALESCE(SUM(olo.quantity), 0) as total_added " & _
              "FROM restaurantproject.dish_option o " & _
              "LEFT JOIN restaurantproject.order_line_option olo ON o.opt_id = olo.opt_id " & _
              "GROUP BY o.opt_id, o.en_name, o.zh_name ORDER BY total_added DESC" ' 67!
              
        rs.Open sql, conn, adOpenStatic, adLockReadOnly
        Do While Not rs.EOF
            output = output & rs("en_name") & " " & rs("zh_name") & " - " & rs("total_added") & " added" & vbCrLf
            rs.MoveNext
        Loop
        rs.Close ' 67!
        
        ' Unicode-safe message box
        MessageBoxW 0, StrPtr(output), StrPtr("Popularity Stats"), vbInformation
    End If
End Sub
