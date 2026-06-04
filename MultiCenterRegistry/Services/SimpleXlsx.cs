using System.IO.Compression;
using System.Globalization;
using System.Security;
using System.Text;

namespace MultiCenterRegistry.Services;

public static class SimpleXlsx
{
    public static byte[] Build(string sheetName, IReadOnlyList<string> headers, IReadOnlyList<IReadOnlyList<string?>> rows)
    {
        using var stream = new MemoryStream();
        using (var archive = new ZipArchive(stream, ZipArchiveMode.Create, true))
        {
            AddText(archive, "[Content_Types].xml", """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
</Types>
""");
            AddText(archive, "_rels/.rels", """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>
""");
            AddText(archive, "xl/_rels/workbook.xml.rels", """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
</Relationships>
""");
            AddText(archive, "xl/workbook.xml", $$"""
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>
    <sheet name="{{Escape(sheetName)}}" sheetId="1" r:id="rId1"/>
  </sheets>
</workbook>
""");
            AddText(archive, "xl/worksheets/sheet1.xml", BuildWorksheet(headers, rows));
        }

        return stream.ToArray();
    }

    private static string BuildWorksheet(IReadOnlyList<string> headers, IReadOnlyList<IReadOnlyList<string?>> rows)
    {
        var builder = new StringBuilder();
        builder.AppendLine("""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>""");
        builder.AppendLine("""<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">""");
        builder.AppendLine("<sheetData>");
        AppendRow(builder, 1, headers);
        for (var i = 0; i < rows.Count; i++)
        {
            AppendRow(builder, i + 2, rows[i]);
        }

        builder.AppendLine("</sheetData>");
        builder.AppendLine("</worksheet>");
        return builder.ToString();
    }

    private static void AppendRow(StringBuilder builder, int rowIndex, IReadOnlyList<string?> values)
    {
        builder.Append("<row r=\"").Append(rowIndex).AppendLine("\">");
        for (var i = 0; i < values.Count; i++)
        {
            builder.Append("<c r=\"")
                .Append(GetCellName(i, rowIndex))
                .AppendLine("\" t=\"inlineStr\">");
            builder.Append("<is><t>")
                .Append(Escape(values[i] ?? ""))
                .AppendLine("</t></is></c>");
        }

        builder.AppendLine("</row>");
    }

    private static string GetCellName(int columnIndex, int rowIndex)
    {
        var dividend = columnIndex + 1;
        var columnName = "";
        while (dividend > 0)
        {
            var modulo = (dividend - 1) % 26;
            columnName = Convert.ToChar('A' + modulo) + columnName;
            dividend = (dividend - modulo) / 26;
        }

        return columnName + rowIndex.ToString(CultureInfo.InvariantCulture);
    }

    private static void AddText(ZipArchive archive, string path, string content)
    {
        var entry = archive.CreateEntry(path, CompressionLevel.Fastest);
        using var writer = new StreamWriter(entry.Open(), Encoding.UTF8);
        writer.Write(content);
    }

    private static string Escape(string value)
        => SecurityElement.Escape(value) ?? "";
}
