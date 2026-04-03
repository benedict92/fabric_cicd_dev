[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared SourceWorkspace = Variable.ValueOrDefault("$(/**/CICD_Variables/SourceWorkspace)", "0b4eb21e-21ad-401e-a8ab-37188e3a5dff");
shared SourceLakehouse = Variable.ValueOrDefault("$(/**/CICD_Variables/SourceLakehouse)", "244d69d8-73c7-4411-b3de-96ce9b146b8d");
shared TargetWorkspace = Variable.ValueOrDefault("$(/**/CICD_Variables/TargetWorkspace)", "0b4eb21e-21ad-401e-a8ab-37188e3a5dff");
shared TargetLakehouse = Variable.ValueOrDefault("$(/**/CICD_Variables/TargetLakehouse)", "244d69d8-73c7-4411-b3de-96ce9b146b8d");
shared DevEnvironment = Variable.ValueOrDefault("$(/**/CICD_Variables/DevEnvironment)", true);
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "fact_sale_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "SaleKey", DestinationColumnName = "SaleKey"], [SourceColumnName = "CityKey", DestinationColumnName = "CityKey"], [SourceColumnName = "CustomerKey", DestinationColumnName = "CustomerKey"], [SourceColumnName = "BillToCustomerKey", DestinationColumnName = "BillToCustomerKey"], [SourceColumnName = "StockItemKey", DestinationColumnName = "StockItemKey"], [SourceColumnName = "InvoiceDateKey", DestinationColumnName = "InvoiceDateKey"], [SourceColumnName = "DeliveryDateKey", DestinationColumnName = "DeliveryDateKey"], [SourceColumnName = "SalespersonKey", DestinationColumnName = "SalespersonKey"], [SourceColumnName = "WWIInvoiceID", DestinationColumnName = "WWIInvoiceID"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Package", DestinationColumnName = "Package"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "UnitPrice", DestinationColumnName = "UnitPrice"], [SourceColumnName = "TaxRate", DestinationColumnName = "TaxRate"], [SourceColumnName = "TotalExcludingTax", DestinationColumnName = "TotalExcludingTax"], [SourceColumnName = "TaxAmount", DestinationColumnName = "TaxAmount"], [SourceColumnName = "Profit", DestinationColumnName = "Profit"], [SourceColumnName = "TotalIncludingTax", DestinationColumnName = "TotalIncludingTax"], [SourceColumnName = "TotalDryItems", DestinationColumnName = "TotalDryItems"], [SourceColumnName = "TotalChillerItems", DestinationColumnName = "TotalChillerItems"], [SourceColumnName = "LineageKey", DestinationColumnName = "LineageKey"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared fact_sale = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = SourceWorkspace]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = SourceLakehouse]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "fact_sale", ItemKind = "Table"]}[Data],
  SelectDemoData = if DevEnvironment = true then Table.FirstN(#"Navigation 2", 10000) else #"Navigation 2"
in
  SelectDemoData;
shared fact_sale_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = TargetWorkspace]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = TargetLakehouse]}[Data],
  Navigation_3 = Navigation_2{[Id = "silver", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "fact_sale", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
