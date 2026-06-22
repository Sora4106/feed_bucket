param(
  [int]$Port = 8000,
  [string]$Root = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
  $Root = Join-Path $PSScriptRoot "build\web"
}

$Root = [System.IO.Path]::GetFullPath($Root)

if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
  throw "Web root not found: $Root"
}

$mimeTypes = @{
  ".css"   = "text/css; charset=utf-8"
  ".gif"   = "image/gif"
  ".html"  = "text/html; charset=utf-8"
  ".ico"   = "image/x-icon"
  ".jpg"   = "image/jpeg"
  ".jpeg"  = "image/jpeg"
  ".js"    = "application/javascript; charset=utf-8"
  ".json"  = "application/json; charset=utf-8"
  ".mjs"   = "application/javascript; charset=utf-8"
  ".otf"   = "font/otf"
  ".png"   = "image/png"
  ".svg"   = "image/svg+xml"
  ".txt"   = "text/plain; charset=utf-8"
  ".wasm"  = "application/wasm"
  ".webp"  = "image/webp"
  ".woff"  = "font/woff"
  ".woff2" = "font/woff2"
  ".xml"   = "application/xml; charset=utf-8"
}

function Get-ContentType {
  param([string]$Path)

  $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()
  if ($mimeTypes.ContainsKey($extension)) {
    return $mimeTypes[$extension]
  }

  return "application/octet-stream"
}

function Resolve-RequestPath {
  param([string]$UrlPath)

  $relativePath = [System.Uri]::UnescapeDataString($UrlPath.TrimStart('/'))
  if ([string]::IsNullOrWhiteSpace($relativePath)) {
    return Join-Path $Root "index.html"
  }

  $candidate = Join-Path $Root $relativePath.Replace('/', '\')
  if (Test-Path -LiteralPath $candidate -PathType Leaf) {
    return $candidate
  }

  if (Test-Path -LiteralPath $candidate -PathType Container) {
    $indexCandidate = Join-Path $candidate "index.html"
    if (Test-Path -LiteralPath $indexCandidate -PathType Leaf) {
      return $indexCandidate
    }
  }

  # Flutter web routes like /controllerPage should fall back to index.html.
  if (-not [System.IO.Path]::HasExtension($relativePath)) {
    return Join-Path $Root "index.html"
  }

  return $null
}

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
$listener.Start()

Write-Host "Serving $Root at http://localhost:$Port/"
Write-Host "Press Ctrl+C to stop."

function Send-Response {
  param(
    [System.Net.Sockets.NetworkStream]$Stream,
    [int]$StatusCode,
    [string]$StatusText,
    [byte[]]$Body = [byte[]]::new(0),
    [string]$ContentType = "text/plain; charset=utf-8",
    [bool]$SendBody = $true
  )

  $headerText = @(
    "HTTP/1.1 $StatusCode $StatusText"
    "Content-Type: $ContentType"
    "Content-Length: $($Body.Length)"
    "Cache-Control: no-cache, no-store, must-revalidate"
    "Pragma: no-cache"
    "Expires: 0"
    "Connection: close"
    ""
    ""
  ) -join "`r`n"

  $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($headerText)
  $Stream.Write($headerBytes, 0, $headerBytes.Length)

  if ($SendBody -and $Body.Length -gt 0) {
    $Stream.Write($Body, 0, $Body.Length)
  }
}

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()

    try {
      $stream = $client.GetStream()
      $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII, $false, 4096, $true)

      $requestLine = $reader.ReadLine()
      if ([string]::IsNullOrWhiteSpace($requestLine)) {
        continue
      }

      while ($reader.ReadLine() -ne "") {
      }

      $parts = $requestLine.Split(' ')
      if ($parts.Length -lt 2) {
        Send-Response -Stream $stream -StatusCode 400 -StatusText "Bad Request"
        continue
      }

      $method = $parts[0].ToUpperInvariant()
      $rawTarget = $parts[1]

      if ($method -notin @("GET", "HEAD")) {
        Send-Response -Stream $stream -StatusCode 405 -StatusText "Method Not Allowed"
        continue
      }

      $pathOnly = $rawTarget.Split('?')[0]
      $targetFile = Resolve-RequestPath -UrlPath $pathOnly
      if (-not $targetFile) {
        Send-Response -Stream $stream -StatusCode 404 -StatusText "Not Found"
        continue
      }

      $bytes = [System.IO.File]::ReadAllBytes($targetFile)
      $contentType = Get-ContentType -Path $targetFile
      Send-Response `
        -Stream $stream `
        -StatusCode 200 `
        -StatusText "OK" `
        -Body $bytes `
        -ContentType $contentType `
        -SendBody ($method -eq "GET")
    } catch {
      if ($stream) {
        $body = [System.Text.Encoding]::UTF8.GetBytes("Internal Server Error")
        Send-Response -Stream $stream -StatusCode 500 -StatusText "Internal Server Error" -Body $body
      }
    } finally {
      if ($reader) {
        $reader.Dispose()
      }
      if ($stream) {
        $stream.Dispose()
      }
      $client.Close()
    }
  }
} finally {
  $listener.Stop()
}
