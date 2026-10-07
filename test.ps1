if (Test-Path "index.html") {
    Write-Host "TEST PASSED: index.html exists"
    exit 0
}
else {
    Write-Host "TEST FAILED: index.html not found"
    exit 1
}