@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Buildings Interface View'
define root view entity zmn_i_buildings
  as select from zmn_buildings
{
      @EndUserText.label: 'Building ID'
  key building_id     as BuildingId,
      @EndUserText.label: 'Building Name'
      building_name   as BuildingName,
      @EndUserText.label: 'No of Rooms'
      n_rooms         as NRooms,

      @EndUserText.label: 'Address Line'
      address_line    as AddressLine,
      @EndUserText.label: 'City'
      city            as City,
      @EndUserText.label: 'State'
      state           as State,
      @EndUserText.label: 'Country'
      country         as Country,

      @Semantics.user.createdBy: true
      @EndUserText.label: 'Created By'
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @EndUserText.label: 'Created At'
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      @EndUserText.label: 'Last Changed By'
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @EndUserText.label: 'Last Changed At'
      last_changed_at as LastChangedAt,

      0               as ExcelRowNumber
}
