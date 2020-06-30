<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,400'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$ip                              = New-Object system.Windows.Forms.TextBox
$ip.multiline                    = $false
$ip.width                        = 157
$ip.height                       = 20
$ip.location                     = New-Object System.Drawing.Point(24,56)
$ip.Font                         = 'Microsoft Sans Serif,10'

$connect                         = New-Object system.Windows.Forms.Button
$connect.text                    = "Connect"
$connect.width                   = 100
$connect.height                  = 30
$connect.location                = New-Object System.Drawing.Point(24,114)
$connect.Font                    = 'Microsoft Sans Serif,10'

$ip_text                         = New-Object system.Windows.Forms.Label
$ip_text.text                    = "IP Adresse eingeben"
$ip_text.AutoSize                = $true
$ip_text.width                   = 25
$ip_text.height                  = 10
$ip_text.location                = New-Object System.Drawing.Point(35,21)
$ip_text.Font                    = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($ip,$connect,$ip_text))

$connect.Add_Click({ connect })






function connect { 

    $ip = $ip.Text

    if ([string]::IsNullOrEmpty($ip))
    {
        Write-Warning "Please enter a IP Address."
    }
    
    if (-Not [string]::IsNullOrEmpty($ip) -AND $ip -notmatch "^\\\\")
    {
        $ip = $ip.Insert(0, "\\")
    }

    $drive_check = Get-PSDrive | Where-Object {$_.DisplayRoot -eq "$ip"}

    if (-Not $drive_check -AND -Not [string]::IsNullOrEmpty($ip))
    {
        
        $drive_letter = (68..90 | %{$L=[char]$_; if ((gdr).Name -notContains $L) {$L}})[0]
        $cred = Get-Credential -Message "Credentials"
        New-PSDrive -Persist -Name $drive_letter -Root $ip -PSProvider "FileSystem" -Credential $cred -Scope Global

        if ($? -eq $true)
        {
            Write-Host "Connected `nIP: $ip `nDrive: $drive_letter "

            $explorer_letter = $drive_letter + ":"
            Invoke-Item "$explorer_letter"
        }
    }

    if ($drive_check)
    {
        Write-Warning "Network Drive already connected."
    }

    
}


#Write your logic code here


[void]$Form.ShowDialog()