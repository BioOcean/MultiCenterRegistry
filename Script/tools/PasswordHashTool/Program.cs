using Bio.Core.Authentication.Extension;

if (args.Length != 1 || string.IsNullOrWhiteSpace(args[0]))
{
    Console.Error.WriteLine("请提供一个临时密码。");
    return 1;
}

var hasher = new PasswordHasher();
Console.WriteLine(hasher.Hash(args[0]));
return 0;
