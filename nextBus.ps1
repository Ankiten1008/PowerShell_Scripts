# PowerShell Program : To determine next bus departure time (Scheduled or Real-Time)
# Author: Ankit Jaiswal (ankiten1008@gmail.com)


#Getting Mandatory Parameters :
 
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True)]$Route,
  [Parameter(Mandatory=$True)]$Stop_Name,
  [Parameter(Mandatory=$True)]$Direction

)

# Determing Route ID using MetroTransit API/Web services :

$RouteID=((Invoke-RestMethod -Method Get -Uri " http://svc.metrotransit.org/NexTrip/Routes?format=json") | Where{$_.Description -match "$Route"}).Route
if ($RouteID.Length -eq 0)
    {
        Write-Host "Invalid Route Name Passed. Kindly check and try again with Valid route"
        exit
    }


# Determining Direction ID using API :

$url_direction="http://svc.metrotransit.org/NexTrip/Directions/$RouteID"+"?format=json"

$All_Directions=Invoke-RestMethod -Method Get -Uri "$url_direction"
$Direction_ID=$All_Directions.GetEnumerator() | Where-Object {$_.Text -match "$Direction"} | Select-Object -ExpandProperty Value 
if ($Direction_ID.Length -eq 0)
    {
        Write-Host "Invalid Direction Passed for the given Route. Kindly check and try again"
        exit
    }


# Determining Bus/Train Stop code using API :

$url_stop="http://svc.metrotransit.org/NexTrip/Stops/$RouteID/$Direction_ID"+"?format=json"

$all_stops=Invoke-RestMethod -Method Get -Uri "$url_stop"
$StopID=$all_stops.GetEnumerator() | Where-Object {$_.Text -match "$Stop_Name"} | Select-Object -ExpandProperty Value             
if ($StopID.Length -eq 0)
    {
        Write-Host "Invalid Stop Name Passed for the given route and direction. Kindly check and try again"
        exit
    }


# Function to get current CST time :

function CST_Time()
{

$cstzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Central Standard Time")
$csttime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date).ToUniversalTime(), $cstzone)
$cst=Get-Date $csttime -DisplayHint Time
$cst
}



# Now since we got Route ID, Direction ID and Bus/Metro Stop Code, We can find Next/Upcoming buses timings :

 $url_upcoming_buses="http://svc.metrotransit.org/NexTrip/$RouteID/$Direction_ID/$StopID"+"?format=json"

 $all_buses=Invoke-RestMethod -Method Get -Uri "$url_upcoming_buses"

    ######## Checking If any upcoming trip is available or Last bus for the day already left #########

if ($all_buses.Length -eq 0)
    {
        Write-Host "No upcoming trips available for the day"
        exit
    }

else
    {
        $DepartureText=$all_buses[0].Actual
        if($DepartureText -eq "True")              # Real-Time Tracking (Live Running bus)
            {
                $NextBusTime=$all_buses[0].DepartureText
                "Next Bus Departs in: "+$NextBusTime+" (Real-Time)`n"
                
                "Current Time (CST)"
                CST_Time
            }
        else                                       # Scheduled Bus Information
            {
                $NextBusTime=$all_buses[0].DepartureText
                "Next Bus Departs at: "+$NextBusTime+" (Scheduled Time)`n"
                
                "Current Time (CST)"
                CST_Time
            }
    }

