<#
.SYNOPSIS
  Time-base One-Time Password Algorithm (RFC 6238)

.DESCRIPTION
  This is an implementation of the RFC 6238 Time-Based One-Time Password Algorithm draft based upon the HMAC-based One-Time Password (HOTP) algorithm (RFC 4226). This is a time based variant of the HOTP algorithm providing short-lived OTP values.

.LINK
	https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-Otp.md

.EXAMPLE
	Get-Otp MySecretTotpKey

.NOTES
  Version:        1.0
  Author:         Jon Friesen
  Creation Date:  May 7, 2015
  Purpose/Change: Provide an easy way of generating OTPs

#>

function Get-Otp(){
	[Alias("otp")]
    param(
        [Parameter(Mandatory=$true)]$SECRET,
        $LENGTH = 6,
        $WINDOW = 30
    )
    #$enc = [System.Text.Encoding]::UTF8
    $hmac = New-Object -TypeName System.Security.Cryptography.HMACSHA1
    $hmac.key = Convert-HexToByteArray(Convert-Base32ToHex(($SECRET.ToUpper())))
    $timeBytes = Get-TimeByteArray $WINDOW
    $randHash = $hmac.ComputeHash($timeBytes)

    $offset = $randhash[($randHash.Length-1)] -band 0xf
    $fullOTP = ($randhash[$offset] -band 0x7f) * [math]::pow(2, 24)
    $fullOTP += ($randHash[$offset + 1] -band 0xff) * [math]::pow(2, 16)
    $fullOTP += ($randHash[$offset + 2] -band 0xff) * [math]::pow(2, 8)
    $fullOTP += ($randHash[$offset + 3] -band 0xff)

    $modNumber = [math]::pow(10, $LENGTH)
    $otp = $fullOTP % $modNumber
    $otp = $otp.ToString("0" * $LENGTH)
    return $otp
}

# Get-OTPRemainingSeconds returns how many seconds are left in the current TOTP window. In a script that needs to wait until the next code is generated, use like $RetryDelayInSeconds = Get-OTPRemainingSeconds; Start-Sleep -Seconds $RetryDelayInSeconds
function Get-OTPRemainingSeconds ([int32]$WINDOW = 30) {
    $EPOCH = Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0

    $span = New-TimeSpan -Start $EPOCH -End (Get-Date).ToUniversalTime()
    $seconds = [math]::floor($span.TotalSeconds)
    $counter = [math]::floor($seconds / $WINDOW)

    $nextTimeStep = ($counter + 1)*$WINDOW
    $difference = $nextTimeStep - $seconds

    return $difference
}

function Get-TimeByteArray($WINDOW) {
    $span = (New-TimeSpan -Start (Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0) -End (Get-Date).ToUniversalTime()).TotalSeconds
    $unixTime = [Convert]::ToInt64([Math]::Floor($span/$WINDOW))
    $byteArray = [BitConverter]::GetBytes($unixTime)
    [array]::Reverse($byteArray)
    return $byteArray
}

function Convert-HexToByteArray($hexString) {
    $byteArray = $hexString -replace '^0x', '' -split "(?<=\G\w{2})(?=\w{2})" | %{ [Convert]::ToByte( $_, 16 ) }
    return $byteArray
}

function Convert-Base32ToHex($base32) {
    $base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    $bits = "";
    $hex = "";

    for ($i = 0; $i -lt $base32.Length; $i++) {
        $val = $base32chars.IndexOf($base32.Chars($i));
        $binary = [Convert]::ToString($val, 2)
        $staticLen = 5
        $padder = '0'
            # Write-Host $binary
        $bits += Add-LeftPad $binary.ToString()  $staticLen  $padder
    }


    for ($i = 0; $i+4 -le $bits.Length; $i+=4) {
        $chunk = $bits.Substring($i, 4)
        # Write-Host $chunk
        $intChunk = [Convert]::ToInt32($chunk, 2)
        $hexChunk = Convert-IntToHex($intChunk)
        # Write-Host $hexChunk
        $hex = $hex + $hexChunk
    }
    return $hex;

}

function Convert-IntToHex([int]$num) {
    return ('{0:x}' -f $num)
}

function Add-LeftPad($str, $len, $pad) {
    if(($len + 1) -ge $str.Length) {
        while (($len - 1) -ge $str.Length) {
            $str = ($pad + $str)
        }
    }
    return $str;
}
