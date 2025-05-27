@ObjectModel.query.implementedBy: 'ABAP:ZMHL_CL_CUSTOM_ENTITY'
@EndUserText.label: 'Item'
define custom entity ZMHL_C_Custom_Item
{

  key HeaderID    : abap.char( 5 );
  key Item        : abap.numc( 2 );
      Description : abap.char( 40 );

      _Header     : association to parent ZMHL_C_Custom_Header on  _Header.HeaderID   = $projection.HeaderID;

}
