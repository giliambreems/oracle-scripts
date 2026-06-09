
////////////
// Version 1
////////////
var grid  = apex.region("ig_voorschotten").widget().interactiveGrid("getViews", "grid");
var model = grid.model;

//let coa_id = $v('P700_COA_ID');
let year    = $v('P700_TOEVOEGEN_VOORSCHOTTEN_JAAR');
let bedrag  = $v('P700_TOEVOEGEN_VOORSCHOTTEN_BEDRAG');
let bereken = $v('P700_TOEVOEGEN_VOORSCHOTTEN_BEREKENEN');

// Calculate the amount per month when
let bedragPerMaand
if (bereken == 'periode') {
    bedragPerMaand = (bedrag / 12).toFixed(0);
} else {
    bedragPerMaand = bedrag;
}


for (let month = 1; month <= 12; month++) {
    let recordId = model.insertNewRecord();

    // Format month and year correctly for begindatum
    let begindatum = new Date(year, month - 1, 1); // first day of the current month
    let einddatum  = new Date(year, month, 1); // first day of the next month

    // Manually format the dates as DD-MM-YYYY
    let formatDate = (date) => {
      let day = String(date.getDate()).padStart(2, '0');
      let month = String(date.getMonth() + 1).padStart(2, '0'); // Months are zero-based
      let year = date.getFullYear();
      return `${day}-${month}-${year}`;
    };

    let begindatumStr = formatDate(begindatum);
    let einddatumStr = formatDate(einddatum);

    // Set values in the record
    // model.setRecordValue(recordId, 'FVT_COA_ID', coa_id);

    model.setRecordValue(recordId, 'FVT_BEGINDATUM', begindatumStr);
    model.setRecordValue(recordId, 'FVT_EINDDATUM', einddatumStr);
    model.setRecordValue(recordId, "FVT_BEDRAG_EX_BTW", Number( bedragPerMaand).toLocaleString("nl-NL"));
}




////////////
// Version 2
////////////
var grid  = apex.region("ig_voorschotten").widget().interactiveGrid("getViews", "grid");
var model = grid.model;

//let coa_id = $v('P700_COA_ID');
let year    = $v('P700_TOEVOEGEN_VOORSCHOTTEN_JAAR');
let bedrag  = $v('P700_TOEVOEGEN_VOORSCHOTTEN_BEDRAG');
let bereken = $v('P700_TOEVOEGEN_VOORSCHOTTEN_BEREKENEN');

// Calculate the amount per month when
let bedragPerMaand = (bereken == 'periode') ? (bedrag / 12).toFixed(0) : bedrag;

for (let month = 1; month <= 12; month++) {
    let recordId = model.insertNewRecord();

    // Format month and year correctly for begindatum
    let begindatum = new Date(year, month - 1, 1); // first day of the current month
    let einddatum  = new Date(year, month, 1); // first day of the next month

    // Manually format the dates as DD-MM-YYYY
    let dateFormatMask = apex.locale.getDateFormat();  // Returns database defined formatMask
    model.setRecordValue(recordId, "FVT_BEGINDATUM", apex.date.format( begindatum, dateFormatMask));
    model.setRecordValue(recordId, "FVT_EINDDATUM", apex.date.format( einddatum, dateFormatMask));

    let cellFormatMask = grid.modelColumns["FVT_BEDRAG_EX_BTW"].formatMask // get formatMask definition from the column properties in the grid
    model.setRecordValue(recordId, "FVT_BEDRAG_EX_BTW", apex.locale.formatNumber( bedragPerMaand, cellFormatMask ));
}




////////////
// Version 3
////////////
var grid  = apex.region("ig_voorschotten").widget().interactiveGrid("getViews", "grid");
var model = grid.model;

let year    = $v('P700_TOEVOEGEN_VOORSCHOTTEN_JAAR');
let bedrag  = $v('P700_TOEVOEGEN_VOORSCHOTTEN_BEDRAG');
let bereken = $v('P700_TOEVOEGEN_VOORSCHOTTEN_BEREKENEN');

// Calculate the amount per month when
let bedragPerMaand = (bereken == 'periode') ? (bedrag / 12).toFixed(0) : bedrag;


for (let month = 1; month <= 12; month++) {
    let recordId = model.insertNewRecord();

    // Format month and year correctly for begindatum
    let begindatum = new Date(year, month - 1, 1); // first day of the current month
    let einddatum  = new Date(year, month, 1); // first day of the next month

    // Format the dates as DD-MM-YYYY, defined in grid column properties and/or APP_NLS_DATE_FORMAT
    let cellFormatMask;

    cellFormatMask = grid.modelColumns["FVT_BEGINDATUM"].formatMask  // get formatMask definition from the column properties in the grid, this attribute contains apex.locale.getDateFormat() value or definition overruled by IG column settings
    model.setRecordValue(recordId, "FVT_BEGINDATUM", apex.date.format( begindatum, cellFormatMask));

    cellFormatMask = grid.modelColumns["FVT_EINDDATUM"].formatMask  // get formatMask definition from the column properties in the grid, this attribute contains apex.locale.getDateFormat() value or is overruled by IG column settings
    model.setRecordValue(recordId, "FVT_EINDDATUM", apex.date.format( einddatum, cellFormatMask));

    cellFormatMask = grid.modelColumns["FVT_BEDRAG_EX_BTW"].formatMask  // get formatMask definition from the column properties in the grid, there is no global formatMask setting for numbers
    model.setRecordValue(recordId, "FVT_BEDRAG_EX_BTW", apex.locale.formatNumber( bedragPerMaand, cellFormatMask ));
}
