@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZTAPPGEN'
define root view entity ZR_TAPPGEN
  as select from ztappgen as appGen
{
  key uuid_root as UuidRoot,
  semantickey_root as SemantickeyRoot,
  description as Description,
  @Semantics.user.createdBy: true
  createdby as Createdby,
  @Semantics.systemDateTime.createdAt: true
  createdat as Createdat,
  @Semantics.user.localInstanceLastChangedBy: true
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchangedat as Lastchangedat,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchangedat as Locallastchangedat
  
}
