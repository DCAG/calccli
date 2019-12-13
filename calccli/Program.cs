using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace calccli
{
    class Program
    {
        static string helpMessage = @"
calccli <Function (add|sub|mul|max|min)> <int> [<int> [<int> [...]]]

Examples:

    calccli add 1 2 3 4 5
    calccli sub 10 6
    calccli mul 3 4
    calccli max 100 50 -3
";

        static void Main(string[] args)
        {
            RunCalcCli(args);
        }

        static void RunCalcCli(string[] args)
        {
            if (args.Length < 1)
            {
                Console.Error.WriteLine("{0}.\n{1}", "Function was not specified", helpMessage);             
                return;
            }

            var calcFunction = args[0].ToLower();
            if(!Regex.IsMatch(calcFunction, "^(add|sub|mul|max|min)$")){
                Console.Error.WriteLine("{0}.\n{1}", $"Unsupported function \"{calcFunction}\"", helpMessage);
                return;
            }

            if (args.Length < 2)
            {
                Console.Error.WriteLine("{0}.\n{1}", "Not enough arguments", helpMessage);                
                return;
            }

            try
            {
                var calcArgs = args.Skip(1).Take(args.Length - 1).ToArray();
                int result = ExecuteAction(calcFunction, calcArgs);
                Console.WriteLine(result);
            }
            catch(Exception e)
            {
                Console.Error.WriteLine(e.Message);
                return;
            }
        }

        static int ExecuteAction(string calcFunction, string[] calcArgs)
        {
            ArrayList validatedArgs = ValidatedArgs(calcArgs);
            int result = 0;
            switch (calcFunction)
            {
                case "add":
                    result = Add(validatedArgs);
                    break;
                case "sub":
                    result = Substruct(validatedArgs);
                    break;
                case "mul":
                    result = Multiply(validatedArgs);
                    break;
                case "max":
                    result = Max(validatedArgs);
                    break;
                case "min":
                    result = Min(validatedArgs);
                    break;
            }

            return result;
        }

        static ArrayList ValidatedArgs(params string[] list){
            ArrayList argumentList = new ArrayList();
            foreach(var item in list){
                int result;
                if (!int.TryParse(item, out result))
                {
                    throw new ArgumentException($"\"{item}\" is not an integer.");
                }

                argumentList.Add(result);
            }
            
            return argumentList;
        }

        static int Add(ArrayList argumentList)
        {
            var result = (int)argumentList[0];
            foreach(var item in argumentList.GetRange(1, argumentList.Count - 1))
            {
                result += (int)item;
            }

            return result;
        }

        static int Substruct(ArrayList argumentList)
        {
            var result = (int)argumentList[0];
            foreach (var item in argumentList.GetRange(1, argumentList.Count - 1))
            {
                result -= (int)item;
            }

            return result;
        }

        static int Multiply(ArrayList argumentList)
        {
            var result = (int)argumentList[0];
            foreach (var item in argumentList.GetRange(1, argumentList.Count - 1))
            {
                result *= (int)item;
            }

            return result;
        }

        static int Max(ArrayList argumentList)
        {
            var result = (int)argumentList[0];
            foreach (var item in argumentList.GetRange(1,argumentList.Count - 1))
            {
                if(result < (int)item)
                {
                    result = (int)item;
                }
            }

            return result;
        }

        static int Min(ArrayList argumentList)
        {
            var result = (int)argumentList[0];
            foreach (var item in argumentList.GetRange(1, argumentList.Count - 1))
            {
                if (result > (int)item)
                {
                    result = (int)item;
                }
            }

            return result;
        }
    }
}
