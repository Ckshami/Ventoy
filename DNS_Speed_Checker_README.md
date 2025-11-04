# DNS Speed Checker

An AutoHotkey GUI application for testing and comparing DNS server response times.

## Features

- **Pre-configured DNS Servers**: Includes popular DNS servers (Google, Cloudflare, Quad9, OpenDNS, AdGuard)
- **Custom DNS Support**: Add your own DNS servers to test
- **Multiple Tests**: Run multiple tests per DNS server for accurate average response times
- **Visual Results**: Clear display of response times with automatic sorting by speed
- **Detailed Progress Tracking**: Real-time progress bar and status updates showing current DNS being tested and test iteration
- **Hidden CMD Windows**: Tests run silently in the background without showing command prompt windows
- **Smart Selection**: Only tests DNS servers you have selected (checkboxes work correctly)
- **Flexible Configuration**: Customize test domain, timeout, and number of tests

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
3. **View Results**: Response times are displayed in milliseconds; faster is better

### Adding Custom DNS Servers

1. Enter a descriptive name in the "Name" field
2. Enter the DNS server IP address in the "IP Address" field
3. Click "Add" to add it to the list
4. Check the new entry and run the test

### Test Settings

- **Test Domain**: The domain name used for DNS lookup tests (default: google.com)
- **Timeout (ms)**: Maximum time to wait for a DNS response (default: 5000ms)
- **Tests per DNS**: Number of tests to run per server for averaging (default: 3)

### Button Functions

- **Start Speed Test**: Begin testing all selected DNS servers
- **Clear Results**: Reset all test results to "Ready" status
- **Select All**: Check all DNS servers in the list
- **Deselect All**: Uncheck all DNS servers in the list

## Understanding Results

- **Status Column**: Shows test status (Ready, Testing..., Success, Failed/Timeout)
- **Response Time**: Average time in milliseconds for DNS resolution
  - **< 50ms**: Excellent
  - **50-100ms**: Good
  - **100-200ms**: Fair
  - **> 200ms**: Slow
  - **N/A**: DNS server failed to respond or timed out

## Pre-configured DNS Servers

| Provider | Type | IP Address |
|----------|------|------------|
| Google DNS | Primary | 8.8.8.8 |
| Google DNS | Secondary | 8.8.4.4 |
| Cloudflare | Primary | 1.1.1.1 |
| Cloudflare | Secondary | 1.0.0.1 |
| Quad9 | Primary | 9.9.9.9 |
| Quad9 | Secondary | 149.112.112.112 |
| OpenDNS | Primary | 208.67.222.222 |
| OpenDNS | Secondary | 208.67.220.220 |
| AdGuard DNS | Primary | 94.140.14.14 |
| AdGuard DNS | Secondary | 94.140.15.15 |

## Tips

- Run tests multiple times for more accurate results
- Network conditions can affect results; test during different times
- Geographic location affects DNS speed; closer servers are typically faster
- Some DNS providers offer additional features like ad-blocking or security filtering
- Consider using the fastest DNS servers in your system's network settings

## Troubleshooting

**Issue**: All tests show "Failed/Timeout"
- Check your internet connection
- Ensure firewall allows DNS queries (UDP port 53)
- Try increasing the timeout value

**Issue**: Script won't run
- Verify AutoHotkey is installed correctly
- Right-click the script and select "Run as Administrator"

**Issue**: Inconsistent results
- Network conditions vary; run multiple tests
- Increase "Tests per DNS" for better averaging
- Close bandwidth-intensive applications during testing

## How It Works

The script uses Windows' `nslookup` command to perform DNS lookups against each selected DNS server. It measures the time taken for each lookup and calculates the average response time across multiple tests.

The tests run in hidden mode (no visible CMD windows) and provide detailed real-time progress updates showing:
- Which DNS server is currently being tested
- Current DNS number out of total selected
- Current test iteration (e.g., "Test 2/3")

## Recent Improvements

### Version 1.1
- **Fixed Selection Bug**: Checkbox selection now works correctly - only selected DNS servers are tested
- **Hidden CMD Windows**: Command prompt windows no longer appear during testing
- **Enhanced Progress Display**: Status bar now shows detailed progress including:
  - Current DNS server being tested
  - DNS count (e.g., "DNS 2/5")
  - Current test iteration (e.g., "Test 1/3")
- **Better User Experience**: Cleaner testing process with no distracting windows

## License

This script is provided as-is for use with the Ventoy project.

## Notes

- Results are sorted automatically by response time (fastest first)
- The fastest DNS server is displayed in the status bar after testing completes
- Custom DNS servers are remembered during the current session only
