@ObjectModel.query.implementedBy: 'ABAP:ZMHL_CL_CUSTOM_ENTITY'
@EndUserText.label: 'Header'
define root custom entity ZMHL_C_Custom_Header
    with parameters
     p_param1 : char1
{

  key HeaderID   : abap.char( 5 );
      HeaderType : abap.char( 2 );
      status     : abap.char( 1 );

      _Item      : composition [1..*] of ZMHL_C_Custom_Item;
      _Msg       : composition [1..*] of ZMHL_C_CUSTOM_MSG;
}
