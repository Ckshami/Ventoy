# DNS Speed Checker - Enhanced Edition

An advanced AutoHotkey GUI application for testing and comparing DNS server response times with comprehensive features for analysis, export, and management.

## Features

### Core Testing Features
- **Pre-configured DNS Servers**: Includes popular DNS servers (Google, Cloudflare, Quad9, OpenDNS, AdGuard)
- **Custom DNS Support**: Add your own DNS servers to test
- **System DNS Detection**: Automatically detect and add your current system DNS servers
- **Multiple Tests**: Run multiple tests per DNS server for accurate average response times
- **Detailed Statistics**: Displays Average, Minimum, Maximum response times and Success Rate
- **Hidden CMD Windows**: Tests run silently in the background without showing command prompt windows
- **Smart Selection**: Only tests DNS servers you have selected (checkboxes work correctly)
- **Detailed Progress Tracking**: Real-time progress bar and status updates showing current DNS being tested and test iteration

### Visual Features
- **Color-Coded Results**: Automatic color coding based on performance
  - **Green** (< 30ms): Excellent
  - **Light Green** (30-50ms): Very Good
  - **Yellow** (50-100ms): Good
  - **Orange** (100-200ms): Fair
  - **Red** (> 200ms): Slow
- **Enhanced ListView**: Shows comprehensive statistics at a glance
- **Sortable Columns**: Automatically sorts by speed (fastest first)

### Management Features
- **Export to CSV**: Export test results to CSV format for analysis in Excel or other tools
- **Save/Load DNS Lists**: Save your custom DNS server lists and load them later
- **Remove Selected**: Remove unwanted DNS servers from the list
- **Select Fastest**: Automatically select the top 3 fastest DNS servers
- **Test History**: View history of all tests with timestamps and fastest DNS for each test
- **Statistics Dashboard**: View overall testing statistics including success rates and averages

### Configuration
- **Flexible Test Settings**: Customize test domain, timeout, and number of tests per DNS
- **Toggle Color Coding**: Enable or disable color-coded results

## Requirements

- Windows OS (Vista or later)
- AutoHotkey v1.1+ installed (download from https://www.autohotkey.com/)
- Internet connection

## Installation

1. Install AutoHotkey from https://www.autohotkey.com/
2. Download the `DNS_Speed_Checker.ahk` script
3. Double-click the script to run it, or right-click and select "Run Script"

## Usage

### Basic Usage

1. **Select DNS Servers**: Check the DNS servers you want to test (all are selected by default)
2. **Click "Start Speed Test"**: The application will test each selected DNS server
3. **View Results**: Response times are displayed with detailed statistics and color coding

### Advanced Features

#### Get System DNS
Click "Get System DNS" to automatically detect and add your computer's current DNS servers to the list.

#### Export Results
1. Run a speed test
2. Click "Export to CSV"
3. Choose a location to save the file
4. Open in Excel or any spreadsheet application

#### Save/Load DNS Lists
- **Save**: Click "Save DNS List" to save your current DNS server list for later use
- **Load**: Click "Load DNS List" to load a previously saved list
- Format: `Name|IP Address` (one per line)

#### Select Fastest DNS
After running tests, click "Select Fastest" to automatically select the top 3 fastest DNS servers.

#### View History
Click "View History" to see a log of all tests you've run, including:
- Test timestamp
- Fastest DNS from each test
- Response time
- Number of servers tested

#### Show Statistics
Click "Show Statistics" to view:
- Total tests run
- Servers tested
- Success/failure counts
- Overall average response time
- Performance rating guide

### Test Settings

- **Test Domain**: The domain name used for DNS lookup tests (default: google.com)
- **Timeout (ms)**: Maximum time to wait for a DNS response (default: 5000ms)
- **Tests per DNS**: Number of tests to run per server for averaging (default: 3, max: 10)
- **Color Code Results**: Enable/disable automatic color coding of results

### Button Functions

**Row 1:**
- **Start Speed Test**: Begin testing all selected DNS servers
- **Clear Results**: Reset all test results to "Ready" status
- **Select All**: Check all DNS servers in the list
- **Deselect All**: Uncheck all DNS servers in the list
- **Select Fastest**: Automatically select the 3 fastest DNS servers
- **View History**: Display test history with timestamps

**Row 2:**
- **Export to CSV**: Export test results to a CSV file
- **Save DNS List**: Save current DNS server list to a file
- **Load DNS List**: Load DNS server list from a file
- **Remove Selected**: Delete selected DNS servers from the list
- **Show Statistics**: Display detailed testing statistics

## Understanding Results

### Columns Explained
- **Select**: Checkbox to select DNS for testing
- **DNS Name**: Descriptive name of the DNS server
- **IP Address**: DNS server IP address
- **Status**: Current status (Ready, Testing..., Success, Failed/Timeout)
- **Avg (ms)**: Average response time across all tests
- **Min (ms)**: Fastest response time recorded
- **Max (ms)**: Slowest response time recorded
- **Success Rate**: Percentage of successful tests

### Performance Ratings
- **< 30ms**: Excellent - Best performance
- **30-50ms**: Very Good - Great performance
- **50-100ms**: Good - Acceptable performance
- **100-200ms**: Fair - Adequate but slow
- **> 200ms**: Slow - Consider using a different DNS
- **N/A**: DNS server failed to respond or timed out

## Pre-configured DNS Servers

| Provider | Type | IP Address | Features |
|----------|------|------------|----------|
| Google DNS | Primary | 8.8.8.8 | Fast, reliable |
| Google DNS | Secondary | 8.8.4.4 | Fast, reliable |
| Cloudflare | Primary | 1.1.1.1 | Very fast, privacy-focused |
| Cloudflare | Secondary | 1.0.0.1 | Very fast, privacy-focused |
| Quad9 | Primary | 9.9.9.9 | Security filtering |
| Quad9 | Secondary | 149.112.112.112 | Security filtering |
| OpenDNS | Primary | 208.67.222.222 | Content filtering options |
| OpenDNS | Secondary | 208.67.220.220 | Content filtering options |
| AdGuard DNS | Primary | 94.140.14.14 | Ad blocking |
| AdGuard DNS | Secondary | 94.140.15.15 | Ad blocking |

## Tips for Best Results

- Run tests multiple times for more accurate results
- Test during different times of day as network conditions vary
- Use "Tests per DNS: 5-10" for more accurate averages
- Geographic location affects DNS speed; closer servers are typically faster
- Consider using the fastest DNS servers in your system's network settings
- Export results to CSV for long-term tracking and comparison
- Use "Get System DNS" to benchmark your current DNS against alternatives

## Troubleshooting

**Issue**: All tests show "Failed/Timeout"
- Check your internet connection
- Ensure firewall allows DNS queries (UDP port 53)
- Try increasing the timeout value
- Disable VPN temporarily

**Issue**: Script won't run
- Verify AutoHotkey is installed correctly
- Right-click the script and select "Run as Administrator"

**Issue**: Inconsistent results
- Network conditions vary; run multiple tests
- Increase "Tests per DNS" to 5-10 for better averaging
- Close bandwidth-intensive applications during testing

**Issue**: Colors not showing
- Ensure "Color Code Results" checkbox is enabled
- Colors only appear after running a successful test

**Issue**: Export to CSV fails
- Ensure you have write permissions to the selected folder
- Try saving to a different location (e.g., Desktop)

**Issue**: Can't load DNS list
- Ensure file format is correct: `Name|IP Address`
- Check that IP addresses are valid (xxx.xxx.xxx.xxx format)
- Remove any special characters from the file

## File Formats

### DNS Server List Format (.txt)
```
; DNS Server List
; Format: Name|IP Address

Google DNS Primary|8.8.8.8
Google DNS Secondary|8.8.4.4
Cloudflare Primary|1.1.1.1
Custom DNS Server|192.168.1.1
```

### CSV Export Format
```
DNS Speed Test Results
Generated: 2025-11-04 10:30:00
Test Domain: google.com

DNS Name,IP Address,Status,Avg Response (ms),Min Response (ms),Max Response (ms),Success Rate
Google DNS Primary,8.8.8.8,Success,25.5,23,28,100%
Cloudflare Primary,1.1.1.1,Success,18.2,15,21,100%
```

## How It Works

The script uses Windows' `nslookup` command to perform DNS lookups against each selected DNS server. It measures the time taken for each lookup and calculates comprehensive statistics including average, minimum, and maximum response times.

The tests run in hidden mode (no visible CMD windows) and provide detailed real-time progress updates showing:
- Which DNS server is currently being tested
- Current DNS number out of total selected
- Current test iteration (e.g., "Test 2/3")

All results are color-coded based on performance and can be exported for further analysis.

## Version History

### Version 2.0 - Enhanced Edition (Current)
- **New Features:**
  - Export results to CSV
  - Save/Load DNS server lists
  - Color-coded results based on performance
  - Detailed statistics (min/max/avg)
  - Test history with timestamps
  - Auto-select fastest DNS servers
  - Get system DNS servers automatically
  - Remove selected DNS servers
  - Statistics dashboard
  - Enhanced ListView with 7 columns
  - Success rate tracking

### Version 1.1
- Fixed checkbox selection bug
- Hidden CMD windows
- Enhanced progress display with test iteration tracking
- Better user experience with cleaner interface

### Version 1.0
- Initial release
- Basic DNS speed testing
- Pre-configured DNS servers
- Custom DNS support

## License

This script is provided as-is for use with the Ventoy project.

## Notes

- Results are sorted automatically by average response time (fastest first)
- The fastest DNS server is displayed in the status bar after testing completes
- Custom DNS servers are remembered during the current session only (use Save/Load for persistence)
- Test history is session-based and resets when you close the application
- Color coding can be toggled on/off via the checkbox in Test Settings
- All exported files include timestamps for easy tracking
