; DNS Speed Checker GUI
; Tests DNS server response times and displays results

#NoEnv
#SingleInstance Force
SetBatchLines, -1

; Create main GUI
Gui, Font, s10, Segoe UI
Gui, Add, Text, x10 y10 w580, DNS Speed Checker - Test DNS server response times
Gui, Font, s9

; DNS Server List
Gui, Add, GroupBox, x10 y40 w580 h200, DNS Servers to Test
Gui, Add, ListView, x20 y60 w560 h170 vDNSList Checked, Select|DNS Name|IP Address|Status|Response Time (ms)

; Pre-populate with common DNS servers
LV_Add("Check", "Google DNS Primary", "8.8.8.8", "Ready", "")
LV_Add("Check", "Google DNS Secondary", "8.8.4.4", "Ready", "")
LV_Add("Check", "Cloudflare Primary", "1.1.1.1", "Ready", "")
LV_Add("Check", "Cloudflare Secondary", "1.0.0.1", "Ready", "")
LV_Add("Check", "Quad9 Primary", "9.9.9.9", "Ready", "")
LV_Add("Check", "Quad9 Secondary", "149.112.112.112", "Ready", "")
LV_Add("Check", "OpenDNS Primary", "208.67.222.222", "Ready", "")
LV_Add("Check", "OpenDNS Secondary", "208.67.220.220", "Ready", "")
LV_Add("Check", "AdGuard DNS Primary", "94.140.14.14", "Ready", "")
LV_Add("Check", "AdGuard DNS Secondary", "94.140.15.15", "Ready", "")

LV_ModifyCol(1, 50)
LV_ModifyCol(2, 150)
LV_ModifyCol(3, 120)
LV_ModifyCol(4, 100)
LV_ModifyCol(5, 140)

; Custom DNS input
Gui, Add, GroupBox, x10 y250 w580 h80, Add Custom DNS Server
Gui, Add, Text, x20 y275, Name:
Gui, Add, Edit, x80 y272 w200 vCustomName, Custom DNS
Gui, Add, Text, x290 y275, IP Address:
Gui, Add, Edit, x360 y272 w150 vCustomIP
Gui, Add, Button, x520 y271 w60 h23 gAddCustomDNS, Add

; Test domain input
Gui, Add, GroupBox, x10 y340 w580 h60, Test Settings
Gui, Add, Text, x20 y365, Test Domain:
Gui, Add, Edit, x100 y362 w200 vTestDomain, google.com
Gui, Add, Text, x310 y365, Timeout (ms):
Gui, Add, Edit, x390 y362 w60 vTimeout, 5000
Gui, Add, Text, x460 y365, Tests per DNS:
Gui, Add, Edit, x550 y362 w30 vTestCount, 3

; Progress bar
Gui, Add, Progress, x10 y410 w580 h20 vProgressBar

; Control buttons
Gui, Add, Button, x10 y440 w180 h35 gStartTest Default, Start Speed Test
Gui, Add, Button, x200 y440 w180 h35 gClearResults, Clear Results
Gui, Add, Button, x390 y440 w90 h35 gSelectAll, Select All
Gui, Add, Button, x490 y440 w100 h35 gDeselectAll, Deselect All

; Status text
Gui, Add, Text, x10 y485 w580 h20 vStatusText Center, Ready to test DNS servers

Gui, Show, w600 h520, DNS Speed Checker
return

; Add custom DNS server
AddCustomDNS:
    Gui, Submit, NoHide
    if (CustomName = "" or CustomIP = "") {
        MsgBox, 48, Error, Please enter both name and IP address.
        return
    }

    ; Validate IP format (basic check)
    if !RegExMatch(CustomIP, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
        MsgBox, 48, Error, Invalid IP address format.
        return
    }

    LV_Add("Check", CustomName, CustomIP, "Ready", "")
    GuiControl,, CustomName, Custom DNS
    GuiControl,, CustomIP,
    GuiControl, Text, StatusText, Custom DNS server added: %CustomIP%
return

; Start DNS speed test
StartTest:
    Gui, Submit, NoHide

    ; Disable start button during test
    GuiControl, Disable, StartTest
    GuiControl, Text, StatusText, Starting DNS speed tests...
    GuiControl,, ProgressBar, 0

    ; Count checked items using proper method
    checkedCount := 0
    row := 0
    Loop {
        row := LV_GetNext(row, "Checked")
        if !row
            break
        checkedCount++
    }

    if (checkedCount = 0) {
        MsgBox, 48, Warning, Please select at least one DNS server to test.
        GuiControl, Enable, StartTest
        GuiControl, Text, StatusText, No DNS servers selected
        return
    }

    ; Validate test settings
    if (TestDomain = "") {
        MsgBox, 48, Error, Please enter a test domain.
        GuiControl, Enable, StartTest
        return
    }

    if (TestCount < 1 or TestCount > 10) {
        MsgBox, 48, Error, Tests per DNS must be between 1 and 10.
        GuiControl, Enable, StartTest
        return
    }

    currentTest := 0
    totalTests := checkedCount

    ; Test each checked DNS server using proper iteration
    row := 0
    Loop {
        row := LV_GetNext(row, "Checked")
        if !row
            break

        currentTest++

        LV_GetText(dnsName, row, 2)
        LV_GetText(dnsIP, row, 3)

        ; Update status
        LV_Modify(row, , , dnsName, dnsIP, "Testing...", "")
        GuiControl, Text, StatusText, Testing %dnsName% (%dnsIP%) - DNS %currentTest%/%totalTests%
        GuiControl,, ProgressBar, % (currentTest - 1) * 100 / totalTests

        ; Perform DNS speed test with progress updates
        responseTime := TestDNSSpeed(dnsIP, dnsName, TestDomain, Timeout, TestCount, currentTest, totalTests)

        ; Update results
        if (responseTime = -1) {
            LV_Modify(row, , , dnsName, dnsIP, "Failed/Timeout", "N/A")
        } else {
            LV_Modify(row, , , dnsName, dnsIP, "Success", Round(responseTime, 2))
        }

        GuiControl,, ProgressBar, % currentTest * 100 / totalTests
    }

    ; Sort by response time (fastest first)
    LV_ModifyCol(5, "SortFloat")

    ; Re-enable start button
    GuiControl, Enable, StartTest
    GuiControl,, ProgressBar, 100
    GuiControl, Text, StatusText, Testing complete! Check results above.

    ; Find fastest DNS
    fastestTime := 999999
    fastestDNS := ""
    Loop, % LV_GetCount() {
        LV_GetText(time, A_Index, 5)
        LV_GetText(status, A_Index, 4)
        if (status = "Success" && time < fastestTime && time != "") {
            fastestTime := time
            LV_GetText(fastestDNS, A_Index, 3)
        }
    }

    if (fastestDNS != "")
        GuiControl, Text, StatusText, Testing complete! Fastest DNS: %fastestDNS% (%fastestTime% ms)
return

; Test DNS speed function with hidden CMD windows and detailed progress
TestDNSSpeed(dnsServer, dnsName, domain, timeout, testCount, currentDNS, totalDNS) {
    totalTime := 0
    successCount := 0

    Loop, %testCount% {
        testNum := A_Index

        ; Update status with current test progress
        GuiControl, Text, StatusText, Testing %dnsName% (%dnsServer%) - DNS %currentDNS%/%totalDNS% | Test %testNum%/%testCount%

        startTime := A_TickCount

        ; Create temporary file for output
        tempFile := A_Temp . "\dns_test_" . A_TickCount . ".txt"

        ; Use nslookup to test DNS resolution
        cmd := "nslookup -timeout=1 " . domain . " " . dnsServer . " > """ . tempFile . """ 2>&1"

        ; Run command with hidden window (0 = hide window, true = wait for completion)
        shell := ComObjCreate("WScript.Shell")
        shell.Run(ComSpec " /c " . cmd, 0, true)

        endTime := A_TickCount
        responseTime := endTime - startTime

        ; Check if response time exceeds timeout
        if (responseTime > timeout) {
            FileDelete, %tempFile%
            continue
        }

        ; Read output from temp file
        FileRead, output, %tempFile%
        FileDelete, %tempFile%

        ; Check if the lookup was successful
        if (InStr(output, "Name:") || InStr(output, "Address:") && !InStr(output, "can't find")) {
            totalTime += responseTime
            successCount++
        }

        Sleep, 100  ; Small delay between tests
    }

    ; Return average response time or -1 if all failed
    if (successCount = 0)
        return -1
    else
        return totalTime / successCount
}

; Clear all results
ClearResults:
    Loop, % LV_GetCount() {
        LV_GetText(dnsName, A_Index, 2)
        LV_GetText(dnsIP, A_Index, 3)
        LV_Modify(A_Index, , , dnsName, dnsIP, "Ready", "")
    }
    GuiControl,, ProgressBar, 0
    GuiControl, Text, StatusText, Results cleared. Ready to test DNS servers.
return

; Select all DNS servers
SelectAll:
    Loop, % LV_GetCount() {
        LV_Modify(A_Index, "Check")
    }
    GuiControl, Text, StatusText, All DNS servers selected
return

; Deselect all DNS servers
DeselectAll:
    Loop, % LV_GetCount() {
        LV_Modify(A_Index, "-Check")
    }
    GuiControl, Text, StatusText, All DNS servers deselected
return

GuiClose:
ExitApp
