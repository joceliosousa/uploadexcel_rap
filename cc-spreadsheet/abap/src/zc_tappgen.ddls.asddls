@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TAPPGEN'
define root view entity ZC_TAPPGEN
  provider contract transactional_query
  as projection on ZR_TAPPGEN
{
  key UuidRoot,
  SemantickeyRoot,
  Description,
  Locallastchangedat
  
}
