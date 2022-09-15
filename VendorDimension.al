// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!


tableextension 50144 vendorTableExt extends Vendor
{

    // trigger OnAfterRename()
    // var
    //     dimval: Record "Dimension Value";
    // begin
    //     dimval.SetFilter("Dimension Code", 'VENDOR');
    //     if dimval.FindSet() then
    //         repeat
    //             if rec.Name = dimval.Name
    //             then begin
    //                 dimval.Code := rec."No.";
    //                 dimval.Modify();

    //             end;
    //         until (dimval.Next() = 0);
    // end;

    //trigger OnAfterInsert()
    //var
    //  dimVal: Record "Dimension Value";
    //begin
    //        Message('On after insert');
    //if rec.Name <> '' then begin
    //dimval.init();
    // dimval."Dimension Code" := 'VENDOR';
    //  dimval.Code := rec."No.";
    //    dimval.Name := rec.Name;
    //  dimval."Dimension Value Type" := dimval."Dimension Value Type"::Standard;
    //    dimval.Totaling := '';
    //      dimval.Blocked := false;
    //        dimval."Map-to IC Dimension Value Code" := '';
    //        dimval."Consolidation Code" := '';

    //       DimVal.Insert(true);
    //   end;
    //end;

    trigger OnAfterModify()
    var
        dimval: Record "Dimension Value";
    begin
        // Message('On after modify');
        if rec.Name <> '' then begin
            dimval.SetFilter("Dimension Code", 'VENDOR');
            dimval.SetFilter(Code, rec."No.");
            if dimval.FindFirst() then begin
                dimval.Name := rec.Name;
                dimval.Modify();
            end
            else begin
                dimval.init();
                dimval."Dimension Code" := 'VENDOR';
                dimval.Code := rec."No.";
                dimval.Name := rec.Name;
                dimval."Dimension Value Type" := dimval."Dimension Value Type"::Standard;
                dimval.Totaling := '';
                dimval.Blocked := false;
                dimval."Map-to IC Dimension Value Code" := '';
                dimval."Consolidation Code" := '';

                DimVal.Insert(true);
            end;
        end;
    end;
}
/*pageextension 50102 VendPage extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(ApplyTemplate)
        {
            action("Update Dimensions")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    DimVal: Record "Dimension Value";
                    Vendor: Record Vendor;
                begin
                    //Message('1');
                    DimVal.Reset();
                    DimVal.Init();
                    //Message('2');
                    DimVal.SetFilter("Dimension Code", '%1', 'VENDOR');
                    //Message('3');
                    if DimVal.Find() then
                        repeat
                            //Message('4');

                            Vendor.SetFilter("No.", DimVal.Code);
                            if Vendor.FindFirst() then begin
                                if not Vendor.Name.Contains(DimVal.Name) then begin
                                    DimVal.Name := Vendor.Name;
                                    DimVal.Modify();
                                end;
                            end;
                        Until DimVal.Next() = 0;
                    /*                    Vendor.Reset();
                                        Vendor.Init();

                                        Vendor.SetFilter(Vendor.Name, '<>''');
                                        if Vendor.Find() then
                                            repeat
                                                DimVal.Init();
                                                DimVal.SetFilter(DimVal.Code, Vendor."No.");
                                                DimVal.SetFilter(DimVal."Dimension Code", 'VENDOR');
                                                if DimVal.Find() then
                                                    repeat
                                                        if not Vendor.Name.Contains(DimVal.Name) then begin
                                                            DimVal.Name := Vendor.Name;
                                                            dimval.Modify();
                                                        end;
                                                    until DimVal.Next() = 0;
                                            until Vendor.Next() = 0;*/
/*                   message('Dimensions updated successfully.');
               end;

           }
       }
       // Add changes to page actions here
   }

   var
       myInt: Integer;
}*/
