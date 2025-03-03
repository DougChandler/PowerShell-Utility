# To use these functions
# Define and set:
# $logFile - the logging filename including path
# $script:Debug - if debug logging is enabled
# $script:Verbose - if verbose logging is enabled
#
# The functions will also attempt to:
# call send-email to send email

Function Log-Output([string]$text, [System.Collections.ArrayList]$exceptions, [bool]$includeTimestamp = $true, [string] $uid)
{
    try {
        $message = ""
        if ($includeTimestamp) {
            $message += (get-date -format("yyyy/MM/dd HH:mm:ss.fff")) + " "
        }
        if ($uid) {
            $message += $uid + " "
        }
        $message += $text

        $message | Out-File -FilePath $logfile -Append -Encoding unicode
        if ($exceptions -ne $null) {
            ("> " + $exceptions[0].Exception.Message) | Out-File -FilePath $logfile -Append -Encoding unicode
            if ($script:ErrorSummary -ne "") {$script:ErrorSummary += [System.Environment]::NewLine}
            $script:ErrorSummary += ($text + ": " + $exceptions[0].Exception.Message)
        }
    }
    catch {
        #if (![string]::IsNullOrEmpty($script:ScriptName) -and [System.Diagnostics.EventLog]::SourceExists($script:ScriptName)) {
        #    Write-EventLog -LogName Application -Source $script:ScriptName -EntryType Error -EventId 1 -Message "Error writing to log file: $($_.Exception.Message)"
        #} elseif (![string]::IsNullOrEmpty($script:statusemailaddress)) {
        if (![string]::IsNullOrEmpty($script:emailErrorTo)) {
            Send-Email -to $script:emailErrorTo -subject $script:emailSubject -message "Error writing to log file: $($_.Exception.Message)"
        }
    }
}

Function Log-Debug([string]$text, [bool]$includeTimestamp = $true, [bool]$LogOutput = $false, [string] $uid)
{
    if ($script:Debug) {
        $message = ""
        if ($includeTimestamp) {
            $message += (get-date -format("yyyy/MM/dd HH:mm:ss.fff")) + " "
        }
        if ($uid) {
            $message += $uid + " "
        }
        $message += $text

        Write-Debug -message $message
        if ($LogOutput) {
            Log-Output -text ("DEBUG: " + $message) -includeTimestamp $includeTimestamp
        }
    }
}

Function Log-Verbose([string]$text, [bool]$includeTimestamp = $true, [bool]$LogOutput = $false)
{
    if ($script:Verbose) {
        $message = ""
        if ($includeTimestamp) {
            $message += (get-date -format("yyyy/MM/dd HH:mm:ss.fff")) + " "
        }
        if ($uid) {
            $message += $uid + " "
        }
        $message += $text

        Write-Verbose -message $message
        if ($LogOutput) {
            Log-Output -text ("VERBOSE: " + $message) -includeTimestamp $includeTimestamp
        }
    }
}