# Extending Instance https://developer.servicenow.com/app.do#!/instance #

 

$IE = New-Object -ComObject "InternetExplorer.Application"

$IE.Visible = $true

$Url = "https://developer.servicenow.com/app.do#!/instance"

$iE.Navigate2($Url)

Start-Sleep -s 180  

$Element = $IE.Document.getElementById("username")

$Element.value = "ankit.jaiswal@xyz.com"

$Element = $IE.Document.getElementById("password")

$Element.value = "xxxxxxxx"

$Element = $IE.Document.getElementById("submitButton")

$Element.click()

Start-Sleep -s 60

$Element = $IE.Document.getElementById("extend_instance")

$Element.click()

Start-Sleep -s 60

$Element = $IE.Document.getElementsByTagName('a') | Where-Object {$_.id -match "a_loggedInUserName"}

$Element.click()

Start-Sleep -s 10

$Element = $IE.Document.getElementById("a_logout")

$Element.click()

Start-Sleep -s 25

$ie.Quit()

Start-Sleep -s 10

 

 

# login to https://dev22056.service-now.com #

 

$IE = New-Object -ComObject "InternetExplorer.Application"

$IE.Visible = $true

$Url = "https://dev22056.service-now.com/"

$iE.Navigate2($Url)

While ($IE.ReadyState -ne 4)

{

   

    Start-Sleep -Milliseconds 100

}

"Session State:"+" "+$ie.ReadyState

Start-Sleep -s 20 # extra buffer

$ie.Document.getElementById("gsft_main").contentWindow.document.getElementByID("user_name").value = "admin"

$ie.Document.getElementById("gsft_main").contentWindow.document.getElementByID("user_password").value = "xxxxxxxxxx"

$ie.Document.getElementById("gsft_main").contentWindow.document.getElementByID("sysverb_login").click()

Start-Sleep -s 60

$submitButton=$ie.Document.getElementsByTagName("button") | Where-Object {$_.innerhtml -eq 'Logout'}

$submitButton.click();

Start-Sleep -s 20

$ie.Quit()
