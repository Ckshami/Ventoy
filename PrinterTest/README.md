# Epson T88VI Printer Test Utility

A comprehensive AutoHotkey GUI application for testing and verifying Epson T88VI thermal receipt printer functionality.

## Features

### Printer Management
- **Auto-detect installed printers** - Automatically scans and lists all printers installed on the system
- **Printer selection** - Easy dropdown selection of the target printer
- **Manual refresh** - Update printer list on demand

### Testing Capabilities

1. **Check Printer Status**
   - Reports current printer state (Idle, Printing, Offline, etc.)
   - Real-time status monitoring
   - Detailed status codes

2. **Check Connection**
   - Verifies printer connectivity
   - Shows port information
   - Displays online/offline status

3. **Get Printer Info**
   - Driver name and version
   - Port configuration
   - Network status
   - Queue information
   - Location details

4. **Test Print**
   - Sends a simple test page
   - Verifies basic printing functionality
   - Tests special characters

5. **Print Sample Receipt**
   - Generates a complete sample receipt
   - Includes itemized list
   - Shows date, time, and transaction details
   - Tests receipt formatting

### Additional Features
- **Clear Results** - Clear the results log
- **Export Log** - Save test results to a timestamped log file
- **Real-time logging** - All operations are logged with timestamps
- **User-friendly interface** - Clean, organized GUI layout

## Requirements

- **Windows OS** (Windows 7 or later)
- **AutoHotkey v1.1+** (Download from https://www.autohotkey.com/)
- **Epson T88VI printer** installed and configured on the system
- **Printer drivers** properly installed

## Installation

1. Install AutoHotkey if not already installed
2. Copy `EpsonT88VI_Tester.ahk` to your desired location
3. Ensure the Epson T88VI printer is installed and connected

## Usage

### Running the Application

**Option 1: Double-click the .ahk file**
- Simply double-click `EpsonT88VI_Tester.ahk` to run

**Option 2: Compile to .exe (optional)**
```bash
# Right-click on the .ahk file
# Select "Compile Script" from the context menu
# Run the generated .exe file
```

### Step-by-Step Testing

1. **Launch the application**
   - The application will automatically scan for installed printers

2. **Select your printer**
   - Choose the Epson T88VI from the dropdown list
   - If not auto-selected, manually select it from the combo box

3. **Check Printer Status**
   - Click "Check Printer Status" to verify the printer is ready
   - Status will be displayed in the "Current Status" section

4. **Check Connection**
   - Click "Check Connection" to verify connectivity
   - View port and network information

5. **Get Printer Info**
   - Click "Get Printer Info" for detailed printer information
   - Review driver, port, and configuration details

6. **Run Test Print**
   - Click "Test Print" to send a basic test page
   - Verify the printer responds and prints correctly

7. **Print Sample Receipt**
   - Click "Print Sample Receipt" to test receipt formatting
   - Check alignment, fonts, and overall print quality

8. **Review Results**
   - All test results are logged in the "Test Results" section
   - Each entry is timestamped for tracking

9. **Export Results**
   - Click "Export Log" to save results to a file
   - Log files are saved as `PrinterTest_YYYY-MM-DD_HHMMSS.log`

## Troubleshooting

### Printer Not Found
- Ensure the printer is properly installed in Windows
- Check printer drivers are up to date
- Click "Refresh Printers" to rescan

### Print Jobs Not Executing
- Verify printer is powered on
- Check cable connections (USB/Network)
- Ensure printer is not in error state
- Check paper is loaded

### Status Shows "Offline"
- Check printer power
- Verify cable connections
- Right-click printer in Windows and uncheck "Use Printer Offline"

### Test Print Fails
- Ensure Windows print spooler service is running
- Check printer queue for stuck jobs
- Clear print queue and try again

## Test Results Interpretation

### Status Messages

| Status | Meaning |
|--------|---------|
| IDLE - Ready to print | Printer is online and ready |
| PRINTING | Currently processing a print job |
| OFFLINE | Printer is not connected or powered off |
| WARMUP | Printer is warming up (uncommon for thermal) |
| Stopped Printing | Print job was cancelled or paused |

### Connection Check
- **Connection OK** - Printer is properly connected
- **Port info** - Shows USB, network, or other port type
- **Online/Offline** - Current connectivity status

## Technical Details

### Printer Status Query
The application uses Windows Management Instrumentation (WMI) to query printer status:
- `Win32_Printer` class for printer enumeration
- Real-time status codes
- Port and driver information

### Print Methods
- Uses Windows notepad print command for reliable output
- Temporary files created in system temp directory
- Automatic cleanup after printing

### Logging
- Timestamps in `YYYY-MM-DD HH:mm:ss` format
- All operations logged
- Export to `.log` files for record keeping

## Compatibility

### Tested With
- Epson T88VI thermal receipt printer
- Windows 10/11
- AutoHotkey v1.1.36+

### Should Work With
- Other Epson TM-series printers (T88V, T20, etc.)
- Any thermal receipt printer with Windows drivers
- Most standard printers (may need adjustments for specific features)

## Modifications

To adapt for other printer models:
1. Change `PrinterName` variable at the top of the script
2. Adjust receipt format in `PrintSampleReceipt()` function
3. Modify test content in `SendTestPrint()` function

## Support

For issues with:
- **The script**: Check AutoHotkey documentation
- **The printer**: Consult Epson support documentation
- **Windows printing**: Check Windows print spooler settings

## License

This utility is provided as-is for testing purposes.

## Version History

- **v1.0** - Initial release
  - Printer detection and selection
  - Status checking
  - Test printing
  - Sample receipt generation
  - Export functionality
