Describe "calccli" {
    $exe = Resolve-Path "$PSScriptRoot\..\calccli\bin\Debug\calccli.exe"
    
    $SupportedFunc = @(
        'Add'
        'Sub'
        'Max'
        'Min'
        'Mul'
    )
    
    It "Function was not specified" -Skip {
        $Output = Invoke-Expression $exe *>&1
        $Output.Exception.Message[0] | should -Be "Function was not specified."
    }

    It "Function was not specified" -Skip {
        (& {iex "$exe a"} *>&1) -split "\r?\n" | should -Be "`"a`" is not an integer."
    }
    
    $AlphaBet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".ToCharArray()
    $WrongFuncTestCases = 1..10 | ForEach-Object {
        $WrongFunc = (1..(1..10 | Get-Random) | ForEach-Object { $AlphaBet | Get-Random }) -join '' | Where-Object {$_ -notin $SupportedFunc }
        if($WrongFunc -notin $SupportedFunc){
            @{Func = $WrongFunc; ExpectedResult = "Unsupported function `"$WrongFunc`"."}
        }
    }
    $WrongFuncTestCases += @(
        @{Func = "Substruct"; ExpectedResult = "Unsupported function `"Substruct`"."}
        @{Func = "Multiply"; ExpectedResult = "Unsupported function `"Multiply`"."}
        @{Func = "Maximum"; ExpectedResult = "Unsupported function `"Maximum`"."}
        @{Func = "Minimum"; ExpectedResult = "Unsupported function `"Minimum`"."}
    )
    It "Wrong function name `"<Func>`" should return <ExpectedResult>" -TestCases $WrongFuncTestCases -Skip {
        param($Func, $ExpectedResult)
        (& $exe $Func *>&1) -split "\r?\n" | Select-Object -First 1 | should -Be $ExpectedResult
    }
    
    $MissingArgsTestCases = @(
        @{Func = 'Add';ExpectedResult = 'Not enough arguments.'}
        @{Func = 'Sub';ExpectedResult = 'Not enough arguments.'}
        @{Func = 'Max';ExpectedResult = 'Not enough arguments.'}
        @{Func = 'Min';ExpectedResult = 'Not enough arguments.'}
        @{Func = 'Mul';ExpectedResult = 'Not enough arguments.'}
    )
    
    It "[<Func>] with no arguments should return [<ExpectedResult>]" -TestCases $MissingArgsTestCases -Skip {
        param($Func, $ExpectedResult)
        (& $exe $Func *>&1) -split "\r?\n" | Select-Object -First 1 | should -Be $ExpectedResult
    }
    
    $FuncArgsTestCases = @(
        @{Func = 'Add';Arguments = 1,2,3,'asdasd';ExpectedResult = "`"asdasd`" is not an integer."}
        @{Func = 'Sub';Arguments = '4f4f';ExpectedResult = "`"4f4f`" is not an integer."}
        @{Func = 'Max';Arguments = '#ffffff';ExpectedResult = "`"#ffffff`" is not an integer."}
        @{Func = 'Min';Arguments = 'h1',4,'h2',8;ExpectedResult = "`"h1`" is not an integer."}
    )

    It "All arguments <Arguments> should throw <ExpectedResult>" -TestCases $FuncArgsTestCases -Skip {
        param($Func, $Arguments, $ExpectedResult)
        (& $exe $Func $Arguments *>&1) -split "\r?\n" | Select-Object -First 1 | should -Be $ExpectedResult
    }

    $AddTestCases = @(
        @{ Arguments = (1..100); ExpectedResult = 5050}
        @{ Arguments = (1..50); ExpectedResult = 1275}
        @{ Arguments = (51..100); ExpectedResult = 5050 - 1275}
        @{ Arguments = 1,2,3,4; ExpectedResult = 10}
        @{ Arguments = 1,-2,3,-4; ExpectedResult = -2}
        @{ Arguments = -4,3,-2,1; ExpectedResult = -2}
    )
    
    It "calccli add <Arguments> should result be <ExpectedResult>" -TestCases $AddTestCases {
        param($Arguments, $ExpectedResult)
        & $exe add $Arguments | Should -be $ExpectedResult
    }
}