; DNS Speed Checker GUI - Enhanced Version
; Tests DNS server response times and displays results with advanced features

#NoEnv
#SingleInstance Force
SetBatchLines, -1

; Global variables for statistics
global TestResults := {}
global TestHistory := []

; Create main GUI
Gui, Font, s10 Bold, Segoe UI
Gui, Add, Text, x10 y10 w680, DNS Speed Checker - Enhanced Edition
Gui, Font, s9 Normal

; DNS Server List
Gui, Add, GroupBox, x10 y40 w680 h220, DNS Servers to Test
Gui, Add, ListView, x20 y60 w660 h190 vDNSList Checked AltSubmit, Select|DNS Name|IP Address|Status|Avg (ms)|Min (ms)|Max (ms)|Success Rate

; Pre-populate with common DNS servers
LV_Add("Check", "Google DNS Primary", "8.8.8.8", "Ready", "", "", "", "")
LV_Add("Check", "Google DNS Secondary", "8.8.4.4", "Ready", "", "", "", "")
LV_Add("Check", "Cloudflare Primary", "1.1.1.1", "Ready", "", "", "", "")
LV_Add("Check", "Cloudflare Secondary", "1.0.0.1", "Ready", "", "", "", "")
LV_Add("Check", "Quad9 Primary", "9.9.9.9", "Ready", "", "", "", "")
LV_Add("Check", "Quad9 Secondary", "149.112.112.112", "Ready", "", "", "", "")
LV_Add("Check", "OpenDNS Primary", "208.67.222.222", "Ready", "", "", "", "")
LV_Add("Check", "OpenDNS Secondary", "208.67.220.220", "Ready", "", "", "", "")
LV_Add("Check", "AdGuard DNS Primary", "94.140.14.14", "Ready", "", "", "", "")
LV_Add("Check", "AdGuard DNS Secondary", "94.140.15.15", "Ready", "", "", "", "")

LV_ModifyCol(1, 50)
LV_ModifyCol(2, 150)
LV_ModifyCol(3, 120)
LV_ModifyCol(4, 80)
LV_ModifyCol(5, 70)
LV_ModifyCol(6, 70)
LV_ModifyCol(7, 70)
LV_ModifyCol(8, 90)

; Custom DNS input
Gui, Add, GroupBox, x10 y270 w680 h60, Add Custom DNS Server
Gui, Add, Text, x20 y295, Name:
Gui, Add, Edit, x80 y292 w180 vCustomName, Custom DNS
Gui, Add, Text, x270 y295, IP Address:
Gui, Add, Edit, x340 y292 w130 vCustomIP
Gui, Add, Button, x480 y291 w60 h23 gAddCustomDNS, Add
Gui, Add, Button, x550 y291 w130 h23 gGetSystemDNS, Get System DNS

; Test domain input
Gui, Add, GroupBox, x10 y340 w680 h60, Test Settings
Gui, Add, Text, x20 y365, Test Domain:
Gui, Add, Edit, x100 y362 w140 vTestDomain, google.com
Gui, Add, Text, x250 y365, Timeout (ms):
Gui, Add, Edit, x330 y362 w50 vTimeout, 5000
Gui, Add, Text, x390 y365, Tests per DNS:
Gui, Add, Edit, x480 y362 w30 vTestCount, 3
Gui, Add, CheckBox, x520 y364 vColorCode Checked, Color Code Results

; Progress bar
Gui, Add, Progress, x10 y410 w680 h20 vProgressBar

; Control buttons - Row 1
Gui, Add, Button, x10 y440 w130 h30 gStartTest Default, Start Speed Test
Gui, Add, Button, x150 y440 w130 h30 gClearResults, Clear Results
Gui, Add, Button, x290 y440 w90 h30 gSelectAll, Select All
Gui, Add, Button, x390 y440 w90 h30 gDeselectAll, Deselect All
Gui, Add, Button, x490 y440 w95 h30 gSelectFastest, Select Fastest
Gui, Add, Button, x595 y440 w95 h30 gViewHistory, View History

; Control buttons - Row 2
Gui, Add, Button, x10 y478 w130 h30 gExportResults, Export to CSV
Gui, Add, Button, x150 y478 w130 h30 gSaveDNSList, Save DNS List
Gui, Add, Button, x290 y478 w130 h30 gLoadDNSList, Load DNS List
Gui, Add, Button, x430 y478 w130 h30 gRemoveSelected, Remove Selected
Gui, Add, Button, x570 y478 w120 h30 gShowStats, Show Statistics

; Status text
Gui, Add, Text, x10 y518 w680 h20 vStatusText Center, Ready to test DNS servers

Gui, Show, w700 h550, DNS Speed Checker - Enhanced
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

    LV_Add("Check", CustomName, CustomIP, "Ready", "", "", "", "")
    GuiControl,, CustomName, Custom DNS
    GuiControl,, CustomIP,
    GuiControl, Text, StatusText, Custom DNS server added: %CustomIP%
return

; Get system DNS servers
GetSystemDNS:
    GuiControl, Text, StatusText, Detecting system DNS servers...

    ; Run ipconfig /all to get DNS servers
    tempFile := A_Temp . "\dns_system_" . A_TickCount . ".txt"
    RunWait, %ComSpec% /c "ipconfig /all > ""%tempFile%""", , Hide

    FileRead, output, %tempFile%
    FileDelete, %tempFile%

    ; Parse DNS servers from output
    dnsCount := 0
    Loop, Parse, output, `n, `r
    {
        if InStr(A_LoopField, "DNS Servers") {
            ; Extract IP from this line
            if RegExMatch(A_LoopField, "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", ip) {
                dnsCount++
                LV_Add("Check", "System DNS " . dnsCount, ip, "Ready", "", "", "", "")
            }
        }
        else if (dnsCount > 0 && RegExMatch(A_LoopField, "^\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})", ip)) {
            ; Additional DNS servers on following lines
            dnsCount++
            LV_Add("Check", "System DNS " . dnsCount, ip, "Ready", "", "", "", "")
        }
        else if (dnsCount > 0 && !RegExMatch(A_LoopField, "^\s")) {
            ; Break when we reach a new section
            break
        }
    }

    if (dnsCount > 0)
        GuiControl, Text, StatusText, Added %dnsCount% system DNS server(s)
    else
        GuiControl, Text, StatusText, No system DNS servers found
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
        LV_Modify(row, , , dnsName, dnsIP, "Testing...", "", "", "", "")
        GuiControl, Text, StatusText, Testing %dnsName% (%dnsIP%) - DNS %currentTest%/%totalTests%
        GuiControl,, ProgressBar, % (currentTest - 1) * 100 / totalTests

        ; Perform DNS speed test with progress updates and collect statistics
        stats := TestDNSSpeedAdvanced(dnsIP, dnsName, TestDomain, Timeout, TestCount, currentTest, totalTests)

        ; Update results with statistics
        if (stats.success = 0) {
            LV_Modify(row, , , dnsName, dnsIP, "Failed/Timeout", "N/A", "N/A", "N/A", "0%")
            if (ColorCode)
                LV_Modify(row, "BackgroundFFCCCC")  ; Light red
        } else {
            avgTime := Round(stats.avg, 2)
            minTime := Round(stats.min, 2)
            maxTime := Round(stats.max, 2)
            successRate := Round((stats.success / TestCount) * 100) . "%"

            LV_Modify(row, , , dnsName, dnsIP, "Success", avgTime, minTime, maxTime, successRate)

            ; Apply color coding based on average response time
            if (ColorCode) {
                if (avgTime < 30)
                    LV_Modify(row, "BackgroundCCFFCC")  ; Light green - Excellent
                else if (avgTime < 50)
                    LV_Modify(row, "BackgroundCCFFE5")  ; Very light green - Very Good
                else if (avgTime < 100)
                    LV_Modify(row, "BackgroundFFFFCC")  ; Light yellow - Good
                else if (avgTime < 200)
                    LV_Modify(row, "BackgroundFFDDCC")  ; Light orange - Fair
                else
                    LV_Modify(row, "BackgroundFFCCCC")  ; Light red - Slow
            }

            ; Store results for export
            TestResults[dnsIP] := stats
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
        if (status = "Success" && time < fastestTime && time != "" && time != "N/A") {
            fastestTime := time
            LV_GetText(fastestDNS, A_Index, 3)
        }
    }

    if (fastestDNS != "") {
        GuiControl, Text, StatusText, Testing complete! Fastest DNS: %fastestDNS% (%fastestTime% ms)

        ; Add to history
        FormatTime, timestamp, , yyyy-MM-dd HH:mm:ss
        TestHistory.Push({time: timestamp, fastest: fastestDNS, speed: fastestTime, total: totalTests})
    }
return

; Test DNS speed function with hidden CMD windows, detailed progress, and statistics
TestDNSSpeedAdvanced(dnsServer, dnsName, domain, timeout, testCount, currentDNS, totalDNS) {
    times := []
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
            times.Push(responseTime)
            successCount++
        }

        Sleep, 100  ; Small delay between tests
    }

    ; Calculate statistics
    stats := {}
    stats.success := successCount

    if (successCount = 0) {
        stats.avg := -1
        stats.min := -1
        stats.max := -1
        return stats
    }

    ; Calculate average
    total := 0
    minTime := 999999
    maxTime := 0

    for index, time in times {
        total += time
        if (time < minTime)
            minTime := time
        if (time > maxTime)
            maxTime := time
    }

    stats.avg := total / successCount
    stats.min := minTime
    stats.max := maxTime
    stats.times := times

    return stats
}

; Clear all results
ClearResults:
    Loop, % LV_GetCount() {
        LV_GetText(dnsName, A_Index, 2)
        LV_GetText(dnsIP, A_Index, 3)
        LV_Modify(A_Index, , , dnsName, dnsIP, "Ready", "", "", "", "")
        LV_Modify(A_Index, "BackgroundFFFFFF")  ; Reset to white background
    }
    GuiControl,, ProgressBar, 0
    GuiControl, Text, StatusText, Results cleared. Ready to test DNS servers.
    TestResults := {}
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

; Select fastest DNS servers (keep only fastest 3)
SelectFastest:
    ; First deselect all
    Loop, % LV_GetCount() {
        LV_Modify(A_Index, "-Check")
    }

    ; Find and select top 3 fastest
    selected := 0
    Loop, % LV_GetCount() {
        if (selected >= 3)
            break

        LV_GetText(status, A_Index, 4)
        LV_GetText(time, A_Index, 5)

        if (status = "Success" && time != "N/A" && time != "") {
            LV_Modify(A_Index, "Check")
            selected++
        }
    }

    if (selected > 0)
        GuiControl, Text, StatusText, Selected %selected% fastest DNS server(s)
    else
        GuiControl, Text, StatusText, No successful tests to select from
return

; Remove selected DNS servers from list
RemoveSelected:
    row := 0
    removed := 0
    Loop {
        row := LV_GetNext(row, "Checked")
        if !row
            break

        LV_Delete(row)
        removed++
        row := 0  ; Start over as indices shift
    }

    if (removed > 0)
        GuiControl, Text, StatusText, Removed %removed% DNS server(s)
    else
        GuiControl, Text, StatusText, No DNS servers selected for removal
return

; Export results to CSV
ExportResults:
    Gui, Submit, NoHide

    ; Check if there are any results
    hasResults := false
    Loop, % LV_GetCount() {
        LV_GetText(status, A_Index, 4)
        if (status = "Success" || status = "Failed/Timeout") {
            hasResults := true
            break
        }
    }

    if (!hasResults) {
        MsgBox, 48, No Results, Please run a speed test before exporting results.
        return
    }

    ; Prompt for file location
    FileSelectFile, outputFile, S16, DNS_Test_Results.csv, Export DNS Test Results, CSV Files (*.csv)
    if (ErrorLevel)
        return

    ; Ensure .csv extension
    if !InStr(outputFile, ".csv")
        outputFile .= ".csv"

    ; Build CSV content
    FormatTime, timestamp, , yyyy-MM-dd HH:mm:ss
    csvContent := "DNS Speed Test Results`n"
    csvContent .= "Generated: " . timestamp . "`n"
    csvContent .= "Test Domain: " . TestDomain . "`n`n"
    csvContent .= "DNS Name,IP Address,Status,Avg Response (ms),Min Response (ms),Max Response (ms),Success Rate`n"

    Loop, % LV_GetCount() {
        LV_GetText(name, A_Index, 2)
        LV_GetText(ip, A_Index, 3)
        LV_GetText(status, A_Index, 4)
        LV_GetText(avg, A_Index, 5)
        LV_GetText(min, A_Index, 6)
        LV_GetText(max, A_Index, 7)
        LV_GetText(rate, A_Index, 8)

        if (status != "Ready") {
            csvContent .= """" . name . """,""" . ip . """,""" . status . """," . avg . "," . min . "," . max . ",""" . rate . """`n"
        }
    }

    ; Write to file
    FileDelete, %outputFile%
    FileAppend, %csvContent%, %outputFile%

    if (ErrorLevel)
        GuiControl, Text, StatusText, Error exporting results
    else
        GuiControl, Text, StatusText, Results exported to: %outputFile%
return

; Save DNS list to file
SaveDNSList:
    ; Prompt for file location
    FileSelectFile, outputFile, S16, DNS_Servers.txt, Save DNS Server List, Text Files (*.txt)
    if (ErrorLevel)
        return

    ; Ensure .txt extension
    if !InStr(outputFile, ".txt")
        outputFile .= ".txt"

    ; Build content
    listContent := "; DNS Server List - Created " . A_Now . "`n"
    listContent .= "; Format: Name|IP Address`n`n"

    Loop, % LV_GetCount() {
        LV_GetText(name, A_Index, 2)
        LV_GetText(ip, A_Index, 3)
        listContent .= name . "|" . ip . "`n"
    }

    ; Write to file
    FileDelete, %outputFile%
    FileAppend, %listContent%, %outputFile%

    if (ErrorLevel)
        GuiControl, Text, StatusText, Error saving DNS list
    else
        GuiControl, Text, StatusText, DNS list saved to: %outputFile%
return

; Load DNS list from file
LoadDNSList:
    ; Prompt for file
    FileSelectFile, inputFile, 3, , Load DNS Server List, Text Files (*.txt)
    if (ErrorLevel)
        return

    FileRead, content, %inputFile%
    if (ErrorLevel) {
        MsgBox, 48, Error, Failed to read file: %inputFile%
        return
    }

    ; Parse and add DNS servers
    added := 0
    Loop, Parse, content, `n, `r
    {
        ; Skip comments and empty lines
        if (A_LoopField = "" || SubStr(A_LoopField, 1, 1) = ";")
            continue

        ; Parse Name|IP format
        if InStr(A_LoopField, "|") {
            parts := StrSplit(A_LoopField, "|")
            if (parts.Length() = 2) {
                name := Trim(parts[1])
                ip := Trim(parts[2])

                ; Validate IP
                if RegExMatch(ip, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
                    LV_Add("Check", name, ip, "Ready", "", "", "", "")
                    added++
                }
            }
        }
    }

    if (added > 0)
        GuiControl, Text, StatusText, Loaded %added% DNS server(s) from file
    else
        GuiControl, Text, StatusText, No valid DNS servers found in file
return

; View test history
ViewHistory:
    if (TestHistory.Length() = 0) {
        MsgBox, 48, No History, No test history available yet. Run a speed test first.
        return
    }

    ; Build history text
    historyText := "DNS Speed Test History`n"
    historyText .= "========================`n`n"

    for index, entry in TestHistory {
        historyText .= "Test #" . index . ": " . entry.time . "`n"
        historyText .= "  Fastest DNS: " . entry.fastest . "`n"
        historyText .= "  Speed: " . entry.speed . " ms`n"
        historyText .= "  Servers Tested: " . entry.total . "`n`n"
    }

    MsgBox, 64, Test History, %historyText%
return

; Show detailed statistics
ShowStats:
    Gui, Submit, NoHide

    if (TestResults.Count() = 0) {
        MsgBox, 48, No Data, Please run a speed test first to view statistics.
        return
    }

    ; Build statistics text
    statsText := "DNS Speed Test Statistics`n"
    statsText .= "==========================`n`n"

    ; Calculate overall statistics
    totalServers := 0
    totalSuccessful := 0
    allTimes := []

    Loop, % LV_GetCount() {
        LV_GetText(status, A_Index, 4)
        LV_GetText(ip, A_Index, 3)

        if (status = "Success" || status = "Failed/Timeout") {
            totalServers++
            if (status = "Success" && TestResults.HasKey(ip)) {
                totalSuccessful++
                for idx, time in TestResults[ip].times {
                    allTimes.Push(time)
                }
            }
        }
    }

    if (allTimes.Length() > 0) {
        ; Calculate overall average
        total := 0
        for idx, time in allTimes {
            total += time
        }
        overallAvg := Round(total / allTimes.Length(), 2)

        statsText .= "Total Tests Run: " . allTimes.Length() . "`n"
        statsText .= "Servers Tested: " . totalServers . "`n"
        statsText .= "Successful: " . totalSuccessful . "`n"
        statsText .= "Failed: " . (totalServers - totalSuccessful) . "`n"
        statsText .= "Overall Average: " . overallAvg . " ms`n`n"

        statsText .= "Performance Rating:`n"
        statsText .= "  < 30ms: Excellent`n"
        statsText .= "  30-50ms: Very Good`n"
        statsText .= "  50-100ms: Good`n"
        statsText .= "  100-200ms: Fair`n"
        statsText .= "  > 200ms: Slow`n"
    } else {
        statsText .= "No successful tests to analyze.`n"
    }

    MsgBox, 64, Statistics, %statsText%
return

GuiClose:
ExitApp
