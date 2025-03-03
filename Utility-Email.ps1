# Email settings
$script:smtpServer = "<email-server>"

Function Send-Email([string[]] $to = $script:emailTo, [string[]]$cc = $script:emailCC, [string[]]$bcc = $script:emailBCC, [string] $subject = $script:emailSubject, [string] $message, [System.Net.Mail.MailPriority] $Priority=[System.Net.Mail.MailPriority]::Normal, [switch] $AsHtml, [System.Text.Encoding] $Encoding = [System.Text.Encoding]::UTF8, [string] $smtpServer = $script:smtpServer, [string] $from = $script:emailFrom) {
    
    if (![string]::IsNullOrEmpty($from) -and ![string]::IsNullOrEmpty($to) -and ![string]::IsNullOrEmpty($message) -and ![string]::IsNullOrEmpty($smtpServer)) {
        $props = @{
            From = $from
            To= $to
            Subject = $subject
            Body = $message
            SmtpServer = $smtpServer
            Priority = $Priority
            Encoding = $Encoding
        }

        If(![string]::IsNullOrEmpty($cc)){$props.Add("CC",$cc)}
        If(![string]::IsNullOrEmpty($bcc)){$props.Add("BCC",$bcc)}

        $null = Send-MailMessage @props -BodyAsHtml:$AsHtml
    }
}