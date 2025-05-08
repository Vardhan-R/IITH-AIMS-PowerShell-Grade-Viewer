# IITH AIMS PowerShell Grade Viewer

Gets the user's grades from the [AIMS website for IITH](https://aims.iith.ac.in/aims/).

## Requirements

- [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.5)

## Installation

1. Download this repository (or just the [`get_all_grades.ps1`](https://github.com/Vardhan-R/IITH-AIMS-PowerShell-Grade-Viewer/blob/main/get_all_grades.ps1) file will suffice). [[1]](https://github.com/Vardhan-R/IITH-AIMS-PowerShell-Grade-Viewer/tree/main?tab=readme-ov-file#notes)

## Usage

### Obtaining Your Cookie

1. Log in to [the AIMS website](https://aims.iith.ac.in/aims/).

2. Follow the steps in the image below to obtain your `JSESSIONID` cookie.
![cookie instructions](https://github.com/Vardhan-R/IITH-AIMS-PowerShell-Grade-Viewer/blob/main/images/JSESSIONID_cookie.png)

3. Make sure that your cookie doesn't expire (don't log out, nor get logged out of the AIMS website).

### Running the Script (may differ on OSs other than Windows)

1. Open PowerShell (run as administrator).

2. Navigate to the folder containing the file `get_all_grades.ps1`.

3. Run `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force`. (This needs to be run only once per user, and PowerShell need not be run as administrator during future uses.) [[2]](https://github.com/Vardhan-R/IITH-AIMS-PowerShell-Grade-Viewer/tree/main?tab=readme-ov-file#notes)

4. Run `.\get_all_grades.ps1 [YOUR COOKIE]`. For example, `.\get_all_grades.ps1 1D713515E379202AD3BD5E55C967076A`.

## Expected Output

1. The list of your courses which have not been graded (course code, course name and academic period name).

2. Your graded courses (grade-wise).

## Notes

1. [`get_all_grades.ps1`](https://github.com/Vardhan-R/IITH-AIMS-PowerShell-Grade-Viewer/blob/main/get_all_grades.ps1) renders the coloured text on all versions of PowerShell, whereas [`get_all_grades_7.ps1`](https://github.com/Vardhan-R/IITH-AIMS-PowerShell-Grade-Viewer/blob/main/get_all_grades_7.ps1) does the same on versions 7 or newer of PowerShell.

2. You can read more about the execution policies [here](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.5).
