// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

tableextension 50143 GLEExt extends "G/L Entry"
{
    fields
    {
        field(50100; "Vendor Name"; Text[250])
        {
            Caption = 'Vendor Name';
            Editable = true;
        }
    }
}
pageextension 50144 GLEExt extends "General Ledger Entries"
{
    layout
    {
        addafter("Global Dimension 2 Code")
        {
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = all;
                Visible = true;
                Editable = true;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Codeunit.Run(Codeunit::ModifyGLEnt);
    end;
}


codeunit 50145 ModifyGLEnt
{
    Permissions = tabledata "G/L Entry" = rmd;
    trigger OnRun()
    var
        GLEnt: Record "G/L Entry";
        DimEntry: Record "Dimension Set Entry";
        DimVal: Record "Dimension Value";
        DimVendor: Text;
    begin
        GLEnt.SetFilter("Dimension Set ID", '>0');
        GLEnt.setfilter("Vendor Name", '=%1', '');
        if GLEnt.FindSet() then
            repeat
                DimVendor := '';
                DimEntry.SetFilter("Dimension Set ID", '%1', GLEnt."Dimension Set ID");
                if DimEntry.FindSet() then
                    repeat
                        if DimEntry."Dimension Code" = 'VENDOR' then begin

                            dimval.SetFilter(dimval.Code, '%1', DimEntry."Dimension Value Code");
                            if DimVal.FindFirst() then begin
                                DimVendor := dimval.Name;
                            end;
                        end
                    until DimEntry.Next() = 0;
                if DimVendor <> '' then begin
                    GLEnt."Vendor Name" := DimVendor;
                    GLEnt.Modify();
                end;
            until GLEnt.Next() = 0;
    end;
}