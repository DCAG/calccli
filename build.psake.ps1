Framework 4.6.1

Properties {
    $Workspace = $PSScriptRoot
    $PesterTests = Join-Path $Workspace 'calccli.pester.tests'
}

task default -depends test

task test -depends build {
    import-module pester -MinimumVersion 4.9.0
    $TestResults = invoke-pester $PesterTests -OutputFormat NUnitXml -OutputFile 'TestResult.xml' -PassThru
    if($TestResults.FailedCount -gt 0){
        throw "$($TestResults.FailedCount) failed tests"
    }
}

task build -depends clean {
    msbuild .\calccli.sln /t:build
}

task clean -depends init {
    msbuild .\calccli.sln /t:clean
}

task init {
    Add-Type -Name 'CalcClass' -Namespace 'MyCalc' @"
public static int Add(int a, int b){
    return a + b;
}
"@

    '*'*10 | Write-Host 
    Write-Host "I Just ran 1 + 3 = $([MyCalc.CalcClass]::Add(1,3)) via compiled C# from PowerShell!"
    '*'*10 | Write-Host 

}