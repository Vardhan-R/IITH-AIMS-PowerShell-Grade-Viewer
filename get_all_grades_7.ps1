# Requirement: PowerShell
# Recommended: PowerShell 7 or newer (to render the coloured text)

$cookie = $args[0]

$gid_grd = @{
    1  = "A+"
    2  = "A"
    3  = "A-"
    4  = "B"
    5  = "B-"
    6  = "C"
    7  = "C-"
    8  = "D"
    9  = "FS"
    10 = "FR"
    11 = "I"
    12 = "S"
    13 = "U"
    14 = "AU"
    15 = "F"
    16 = "P"
}

function Display-Content {
    param (
        [Parameter(Mandatory = $false)]
        $content,

        [Parameter(Mandatory = $true)]
        [string]$heading
    )

    for ($i = 0; $i -lt $content.Length; $i++) {
        if ($i -eq 0) {
            Write-Output "`e[94m$heading`e[0m"
        }

        $course = $content[$i]
        $courseCd = $course.courseCd
        $courseName = $course.courseName
        $periodName = $course.periodName

        Write-Output "`e[92m$courseCd`e[0m | `e[95m$courseName`e[0m | `e[96m$periodName`e[0m"

        if ($i -eq $content.Count - 1) {
            Write-Output ""
        }
    }
}

function Get-Json {
    param (
        [Parameter(Mandatory = $true)]
        $session,

        [Parameter(Mandatory = $true)]
        [string]$uri
    )

    $ProgressPreference = "SilentlyContinue"
    $res = Invoke-WebRequest -UseBasicParsing -Uri $uri `
    -WebSession $session `
    -Headers @{
        "Accept" = "*/*"
        "Accept-Encoding" = "gzip, deflate, br, zstd"
        "Accept-Language" = "en-US,en;q=0.9"
        "Referer" = "https://aims.iith.ac.in/aims/courseReg/myCrsHistoryPage?dbTbNm=mn&isMnDb=false"
        "Sec-Fetch-Dest" = "empty"
        "Sec-Fetch-Mode" = "cors"
        "Sec-Fetch-Site" = "same-origin"
        "X-Requested-With" = "XMLHttpRequest"
        "sec-ch-ua" = '"Google Chrome";v="135", "Not-A.Brand";v="8", "Chromium";v="135"'
        "sec-ch-ua-mobile" = "?0"
        "sec-ch-ua-platform" = '"Windows"'
    } `
    -ContentType "application/x-www-form-urlencoded; charset=UTF-8"
    $ProgressPreference = "Continue"

    $statusCode = $res.StatusCode
    if ($statusCode -ne 200) {
        Write-Output "Something went wrong (HTTP status code $statusCode)."
        Write-Output "Exiting..."
        exit
    }

    try {
        return ConvertFrom-Json($res.Content)
    }
    catch {
        Write-Output "Something went wrong. Could not convert the response content to JSON."
        Write-Output "Exiting..."
        exit
    }
}

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36"
$session.Cookies.Add((New-Object System.Net.Cookie("JSESSIONID", $cookie, "/", "aims.iith.ac.in")))

# Courses which have not been graded
# resultIds==1 <==> passed the course, isGradeIds==2 <==> failed the course
$uri = "https://aims.iith.ac.in/aims/courseReg/loadMyCoursesHistroy?studentId=&courseCd=&courseName=&orderBy=1&degreeIds=&acadPeriodIds=&regTypeIds=&gradeIds=&resultIds=[1]&isGradeIds="
$passed_courses = Get-Json -session $session -uri $uri
$uri = "https://aims.iith.ac.in/aims/courseReg/loadMyCoursesHistroy?studentId=&courseCd=&courseName=&orderBy=1&degreeIds=&acadPeriodIds=&regTypeIds=&gradeIds=&resultIds=[2]&isGradeIds="
$failed_courses = Get-Json -session $session -uri $uri
$graded_courses = $passed_courses + $failed_courses
$graded_ids = $graded_courses | ForEach-Object { "$($_.courseCd)|$($_.periodName)" }

$uri = "https://aims.iith.ac.in/aims/courseReg/loadMyCoursesHistroy?studentId=&courseCd=&courseName=&orderBy=1&degreeIds=&acadPeriodIds=&regTypeIds=&gradeIds=&resultIds=&isGradeIds="
$all_courses = Get-Json -session $session -uri $uri
$not_graded_courses = $all_courses | Where-Object { $graded_ids -notcontains "$($_.courseCd)|$($_.periodName)" }
Display-Content -content $not_graded_courses -heading "Not graded:"

# Grade-wise
for ($gradeId = 1; $gradeId -le 16; $gradeId++) {
    $grade = $gid_grd[$gradeId]

    $uri = "https://aims.iith.ac.in/aims/courseReg/loadMyCoursesHistroy?studentId=&courseCd=&courseName=&orderBy=1&degreeIds=&acadPeriodIds=&regTypeIds=&gradeIds=[$gradeId]&resultIds=&isGradeIds="
    $content = Get-Json -session $session -uri $uri
    Display-Content -content $content -heading "$grade in:"
}
