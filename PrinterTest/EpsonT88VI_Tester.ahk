; ====================================================================================================
; Epson T88VI Printer Test Application
; Description: GUI application to test and verify Epson T88VI thermal receipt printer functionality
; ====================================================================================================

#NoEnv
#SingleInstance Force
SetBatchLines, -1
SendMode Input

; Global variables
global PrinterName := "Epson T88VI"
global StatusText := ""
global ResultsText := ""

; Create the GUI
CreateGUI()
return

CreateGUI() {
    Gui, +AlwaysOnTop
    Gui, Color, 0xF0F0F0
    Gui, Font, s10 Bold, Segoe UI
    Gui, Add, Text, x20 y10 w560 Center, Epson T88VI Printer Test Utility

    ; Printer selection section
    Gui, Font, s9 Normal
    Gui, Add, GroupBox, x20 y40 w560 h80, Printer Configuration
    Gui, Add, Text, x40 y60 w100, Printer Name:
    Gui, Add, Edit, x140 y57 w280 vPrinterNameEdit, %PrinterName%
    Gui, Add, Button, x430 y56 w130 h25 gRefreshPrinters, Refresh Printers
    Gui, Add, ComboBox, x140 y85 w420 vPrinterCombo, ||

    ; Test buttons section
    Gui, Add, GroupBox, x20 y130 w560 h100, Printer Tests
    Gui, Add, Button, x40 y155 w160 h30 gCheckStatus, Check Printer Status
    Gui, Add, Button, x220 y155 w160 h30 gTestPrint, Test Print
    Gui, Add, Button, x400 y155 w160 h30 gPrintSample, Print Sample Receipt
    Gui, Add, Button, x40 y195 w160 h30 gCheckConnection, Check Connection
    Gui, Add, Button, x220 y195 w160 h30 gGetPrinterInfo, Get Printer Info
    Gui, Add, Button, x400 y195 w160 h30 gClearResults, Clear Results

    ; Status display section
    Gui, Add, GroupBox, x20 y240 w560 h80, Current Status
    Gui, Add, Edit, x40 y260 w520 h45 vStatusDisplay ReadOnly Multi +BackgroundWhite, Ready to test printer...

    ; Results display section
    Gui, Add, GroupBox, x20 y330 w560 h220, Test Results
    Gui, Add, Edit, x40 y350 w520 h185 vResultsDisplay ReadOnly Multi +VScroll +BackgroundWhite,

    ; Control buttons
    Gui, Add, Button, x400 y560 w80 h30 gExportResults, Export Log
    Gui, Add, Button, x490 y560 w90 h30 gGuiClose, Exit

    ; Show the GUI
    Gui, Show, w600 h605, Epson T88VI Printer Test Utility

    ; Load printers on startup
    RefreshPrinters()
}

RefreshPrinters:
    GuiControl,, StatusDisplay, Refreshing printer list...

    ; Get all installed printers
    printerList := GetInstalledPrinters()

    ; Clear and populate combo box
    GuiControl,, PrinterCombo, |

    if (printerList != "") {
        Loop, Parse, printerList, `n
        {
            if (A_LoopField != "") {
                GuiControl,, PrinterCombo, %A_LoopField%

                ; Auto-select if it contains "T88" or "Epson"
                if (InStr(A_LoopField, "T88") || InStr(A_LoopField, "Epson")) {
                    GuiControl, ChooseString, PrinterCombo, %A_LoopField%
                }
            }
        }
        GuiControl,, StatusDisplay, Found printers. Select one from the dropdown.
        AddToResults("Printers refreshed. Found " . CountLines(printerList) . " printer(s).")
    } else {
        GuiControl,, StatusDisplay, No printers found! Please check printer installation.
        AddToResults("ERROR: No printers found in the system.")
    }
return

CheckStatus:
    Gui, Submit, NoHide

    if (PrinterCombo = "") {
        GuiControl,, StatusDisplay, ERROR: Please select a printer first!
        return
    }

    GuiControl,, StatusDisplay, Checking printer status...
    AddToResults("========================================")
    AddToResults("Checking status for: " . PrinterCombo)

    status := GetPrinterStatus(PrinterCombo)

    GuiControl,, StatusDisplay, %status%
    AddToResults("Status: " . status)
return

CheckConnection:
    Gui, Submit, NoHide

    if (PrinterCombo = "") {
        GuiControl,, StatusDisplay, ERROR: Please select a printer first!
        return
    }

    GuiControl,, StatusDisplay, Checking printer connection...
    AddToResults("========================================")
    AddToResults("Checking connection for: " . PrinterCombo)

    connectionStatus := CheckPrinterConnection(PrinterCombo)

    GuiControl,, StatusDisplay, %connectionStatus%
    AddToResults("Connection: " . connectionStatus)
return

GetPrinterInfo:
    Gui, Submit, NoHide

    if (PrinterCombo = "") {
        GuiControl,, StatusDisplay, ERROR: Please select a printer first!
        return
    }

    GuiControl,, StatusDisplay, Getting printer information...
    AddToResults("========================================")
    AddToResults("Printer Information for: " . PrinterCombo)

    info := GetDetailedPrinterInfo(PrinterCombo)

    GuiControl,, StatusDisplay, Printer information retrieved
    AddToResults(info)
return

TestPrint:
    Gui, Submit, NoHide

    if (PrinterCombo = "") {
        GuiControl,, StatusDisplay, ERROR: Please select a printer first!
        return
    }

    GuiControl,, StatusDisplay, Sending test print...
    AddToResults("========================================")
    AddToResults("Test Print for: " . PrinterCombo)

    result := SendTestPrint(PrinterCombo)

    if (InStr(result, "SUCCESS")) {
        GuiControl,, StatusDisplay, Test print sent successfully!
        AddToResults("✓ Test print completed successfully")
    } else {
        GuiControl,, StatusDisplay, Test print failed!
        AddToResults("✗ Test print failed: " . result)
    }
return

PrintSample:
    Gui, Submit, NoHide

    if (PrinterCombo = "") {
        GuiControl,, StatusDisplay, ERROR: Please select a printer first!
        return
    }

    GuiControl,, StatusDisplay, Printing sample receipt...
    AddToResults("========================================")
    AddToResults("Sample Receipt Print for: " . PrinterCombo)

    result := PrintSampleReceipt(PrinterCombo)

    if (InStr(result, "SUCCESS")) {
        GuiControl,, StatusDisplay, Sample receipt printed successfully!
        AddToResults("✓ Sample receipt printed successfully")
    } else {
        GuiControl,, StatusDisplay, Sample receipt print failed!
        AddToResults("✗ Sample receipt print failed: " . result)
    }
return

ClearResults:
    GuiControl,, ResultsDisplay,
    GuiControl,, StatusDisplay, Results cleared. Ready for new tests.
return

ExportResults:
    Gui, Submit, NoHide

    if (ResultsDisplay = "") {
        MsgBox, 48, No Data, No results to export!
        return
    }

    ; Create filename with timestamp
    FormatTime, TimeStamp, , yyyy-MM-dd_HHmmss
    fileName := "PrinterTest_" . TimeStamp . ".log"

    FileDelete, %fileName%
    FileAppend, %ResultsDisplay%, %fileName%

    if (ErrorLevel) {
        MsgBox, 16, Error, Failed to export results!
    } else {
        MsgBox, 64, Success, Results exported to:%fileName%
        AddToResults("Results exported to: " . fileName)
    }
return

GuiClose:
    ExitApp
return

; ====================================================================================================
; Helper Functions
; ====================================================================================================

GetInstalledPrinters() {
    ; Query WMI for installed printers
    printers := ""

    ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Printer")._NewEnum()
    For printer in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Printer")
        printers .= printer.Name . "`n"

    return printers
}

GetPrinterStatus(printerName) {
    try {
        For printer in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Printer WHERE Name='" . printerName . "'") {
            status := printer.PrinterStatus

            ; Decode printer status
            if (status = 1)
                return "Printer Status: Other"
            else if (status = 2)
                return "Printer Status: Unknown"
            else if (status = 3)
                return "Printer Status: IDLE - Ready to print"
            else if (status = 4)
                return "Printer Status: PRINTING"
            else if (status = 5)
                return "Printer Status: WARMUP"
            else if (status = 6)
                return "Printer Status: Stopped Printing"
            else if (status = 7)
                return "Printer Status: OFFLINE"
            else
                return "Printer Status: Online and Ready (Status: " . status . ")"
        }
    } catch e {
        return "ERROR: Unable to get printer status - " . e.message
    }

    return "ERROR: Printer not found"
}

CheckPrinterConnection(printerName) {
    try {
        For printer in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Printer WHERE Name='" . printerName . "'") {
            portName := printer.PortName
            isOnline := printer.WorkOffline ? "Offline" : "Online"

            return "Connection OK - Port: " . portName . " | Status: " . isOnline
        }
    } catch e {
        return "ERROR: Connection check failed - " . e.message
    }

    return "ERROR: Printer not found"
}

GetDetailedPrinterInfo(printerName) {
    info := ""

    try {
        For printer in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Printer WHERE Name='" . printerName . "'") {
            info .= "  Driver: " . printer.DriverName . "`n"
            info .= "  Port: " . printer.PortName . "`n"
            info .= "  Location: " . printer.Location . "`n"
            info .= "  Share Name: " . (printer.ShareName ? printer.ShareName : "Not Shared") . "`n"
            info .= "  Network: " . (printer.Network ? "Yes" : "No") . "`n"
            info .= "  Work Offline: " . (printer.WorkOffline ? "Yes" : "No") . "`n"
            info .= "  Default: " . (printer.Default ? "Yes" : "No") . "`n"
            info .= "  Jobs Queued: " . printer.JobCountSinceLastReset . "`n"
        }
    } catch e {
        return "ERROR: Unable to get printer info - " . e.message
    }

    if (info = "")
        return "ERROR: Printer not found"

    return info
}

SendTestPrint(printerName) {
    ; Create a test file
    testFile := A_Temp . "\epson_test_print.txt"

    testContent := "
    (
    ================================
      EPSON T88VI PRINTER TEST
    ================================

    Date/Time: " . A_Now . "
    Printer: " . printerName . "

    This is a test print to verify
    printer functionality.

    Test Lines:
    1. Line One
    2. Line Two
    3. Line Three
    4. Line Four
    5. Line Five

    Special Characters Test:
    ! @ # $ % ^ & * ( ) - _ = +
    [ ] { } | \ : ; " ' < > , . ? /

    ================================
         TEST COMPLETED
    ================================



    )"

    FileDelete, %testFile%
    FileAppend, %testContent%, %testFile%

    if (ErrorLevel) {
        return "ERROR: Failed to create test file"
    }

    ; Print the file
    RunWait, notepad.exe /p "%testFile%",, Hide

    Sleep, 500
    FileDelete, %testFile%

    return "SUCCESS: Test print sent to printer"
}

PrintSampleReceipt(printerName) {
    ; Create a sample receipt
    receiptFile := A_Temp . "\epson_sample_receipt.txt"

    FormatTime, CurrentDate, , yyyy-MM-dd
    FormatTime, CurrentTime, , HH:mm:ss

    receiptContent := "
    (
    ================================
           SAMPLE RECEIPT
    ================================

    Store: Tech Solutions Inc.
    Address: 123 Main Street
    Phone: (555) 123-4567

    Date: " . CurrentDate . "
    Time: " . CurrentTime . "
    Receipt #: RCP-" . A_TickCount . "

    --------------------------------
    ITEMS:
    --------------------------------

    1x Widget A         $19.99
    2x Gadget B         $29.98
    1x Service Fee      $5.00

    --------------------------------
    Subtotal:           $54.97
    Tax (8.5%):         $4.67
    --------------------------------
    TOTAL:              $59.64
    ================================

    Payment Method: CASH
    Amount Paid:        $60.00
    Change:             $0.36

    ================================
    Thank you for your business!
    ================================

    Printer Test: PASSED
    Epson T88VI



    )"

    FileDelete, %receiptFile%
    FileAppend, %receiptContent%, %receiptFile%

    if (ErrorLevel) {
        return "ERROR: Failed to create receipt file"
    }

    ; Print the receipt
    RunWait, notepad.exe /p "%receiptFile%",, Hide

    Sleep, 500
    FileDelete, %receiptFile%

    return "SUCCESS: Sample receipt sent to printer"
}

AddToResults(text) {
    FormatTime, TimeStamp, , yyyy-MM-dd HH:mm:ss
    GuiControlGet, currentResults,, ResultsDisplay

    newText := "[" . TimeStamp . "] " . text . "`n"

    if (currentResults = "") {
        GuiControl,, ResultsDisplay, %newText%
    } else {
        GuiControl,, ResultsDisplay, %currentResults%%newText%
    }

    ; Auto-scroll to bottom
    GuiControl, Focus, ResultsDisplay
    Send, ^{End}
}

CountLines(text) {
    count := 0
    Loop, Parse, text, `n
    {
        if (A_LoopField != "")
            count++
    }
    return count
}
