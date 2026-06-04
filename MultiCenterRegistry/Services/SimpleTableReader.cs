using System.IO.Compression;
using System.Text;
using System.Xml.Linq;

namespace MultiCenterRegistry.Services;

public static class SimpleTableReader
{
    public static async Task<List<Dictionary<string, string>>> ReadAsync(Stream stream, string fileName)
    {
        var extension = Path.GetExtension(fileName).ToLowerInvariant();
        var rows = extension == ".xlsx"
            ? ReadXlsx(stream)
            : await ReadCsvAsync(stream);

        if (rows.Count == 0)
        {
            return [];
        }

        var headers = rows[0].Select(x => x.Trim()).ToList();
        var result = new List<Dictionary<string, string>>();
        foreach (var row in rows.Skip(1))
        {
            if (row.All(string.IsNullOrWhiteSpace))
            {
                continue;
            }

            var item = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            for (var i = 0; i < headers.Count; i++)
            {
                if (string.IsNullOrWhiteSpace(headers[i]))
                {
                    continue;
                }

                item[headers[i]] = i < row.Count ? row[i].Trim() : "";
            }

            result.Add(item);
        }

        return result;
    }

    private static async Task<List<List<string>>> ReadCsvAsync(Stream stream)
    {
        using var reader = new StreamReader(stream, Encoding.UTF8, true);
        var text = await reader.ReadToEndAsync();
        var rows = new List<List<string>>();
        var row = new List<string>();
        var field = new StringBuilder();
        var inQuote = false;

        for (var i = 0; i < text.Length; i++)
        {
            var current = text[i];
            if (current == '"')
            {
                if (inQuote && i + 1 < text.Length && text[i + 1] == '"')
                {
                    field.Append('"');
                    i++;
                    continue;
                }

                inQuote = !inQuote;
                continue;
            }

            if (!inQuote && current == ',')
            {
                row.Add(field.ToString());
                field.Clear();
                continue;
            }

            if (!inQuote && (current == '\r' || current == '\n'))
            {
                if (current == '\r' && i + 1 < text.Length && text[i + 1] == '\n')
                {
                    i++;
                }

                row.Add(field.ToString());
                field.Clear();
                rows.Add(row);
                row = [];
                continue;
            }

            field.Append(current);
        }

        row.Add(field.ToString());
        rows.Add(row);
        return rows;
    }

    private static List<List<string>> ReadXlsx(Stream stream)
    {
        using var archive = new ZipArchive(stream, ZipArchiveMode.Read);
        var sharedStrings = ReadSharedStrings(archive);
        var sheet = archive.GetEntry("xl/worksheets/sheet1.xml") ?? throw new InvalidOperationException("未找到第一张工作表。");
        using var sheetStream = sheet.Open();
        var document = XDocument.Load(sheetStream);
        XNamespace ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
        var rows = new List<List<string>>();

        foreach (var rowElement in document.Descendants(ns + "row"))
        {
            var values = new SortedDictionary<int, string>();
            foreach (var cell in rowElement.Elements(ns + "c"))
            {
                var reference = cell.Attribute("r")?.Value ?? "";
                var column = GetColumnIndex(reference);
                if (column < 0)
                {
                    continue;
                }

                values[column] = GetCellValue(cell, ns, sharedStrings);
            }

            var row = new List<string>();
            var max = values.Count == 0 ? -1 : values.Keys.Max();
            for (var i = 0; i <= max; i++)
            {
                row.Add(values.TryGetValue(i, out var value) ? value : "");
            }

            rows.Add(row);
        }

        return rows;
    }

    private static List<string> ReadSharedStrings(ZipArchive archive)
    {
        var entry = archive.GetEntry("xl/sharedStrings.xml");
        if (entry == null)
        {
            return [];
        }

        using var stream = entry.Open();
        var document = XDocument.Load(stream);
        XNamespace ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
        return document.Descendants(ns + "si")
            .Select(x => string.Concat(x.Descendants(ns + "t").Select(t => t.Value)))
            .ToList();
    }

    private static string GetCellValue(XElement cell, XNamespace ns, IReadOnlyList<string> sharedStrings)
    {
        var type = cell.Attribute("t")?.Value;
        if (type == "inlineStr")
        {
            return string.Concat(cell.Descendants(ns + "t").Select(x => x.Value));
        }

        var raw = cell.Element(ns + "v")?.Value ?? "";
        if (type == "s" && int.TryParse(raw, out var index) && index >= 0 && index < sharedStrings.Count)
        {
            return sharedStrings[index];
        }

        return raw;
    }

    private static int GetColumnIndex(string reference)
    {
        var result = 0;
        var found = false;
        foreach (var current in reference)
        {
            if (!char.IsLetter(current))
            {
                break;
            }

            found = true;
            result = result * 26 + (char.ToUpperInvariant(current) - 'A' + 1);
        }

        return found ? result - 1 : -1;
    }
}
