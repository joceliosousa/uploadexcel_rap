@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Buildings Consumption View'

@UI.headerInfo:{
  typeName: 'Building',
  typeNamePlural: 'Buildings',
  typeImageUrl: 'sap-icon://building',
  title: {
    type: #STANDARD,
    value: 'BuildingName'
  },
  description.value: 'BuildingId'
}

define root view entity zmn_c_buildings
  provider contract transactional_query
  as projection on zmn_i_buildings
{
      @UI.facet: [{ id: 'Building',
        purpose: #STANDARD,
        type: #IDENTIFICATION_REFERENCE,
        label: 'Building',
        position: 10
      }, {
        id: 'addr',position:20,
        type: #FIELDGROUP_REFERENCE,
        targetQualifier: 'Address',
        label:'Address'
      }, {
        id:'log',position:30,
        type: #FIELDGROUP_REFERENCE,
        targetQualifier: 'ChangeLog',
        label:'Change Log'
      }]

      @UI: { lineItem: [{ position: 10 }],
      identification: [{ position: 10 }],
      selectionField: [{ position: 10 }] }
  key BuildingId,
      @UI: { lineItem: [{ position: 20 }],
      identification: [{ position: 20 }],
      selectionField: [{ position: 20 }] }
      BuildingName,
      @UI: { lineItem: [{ position: 30 }],
      identification: [{ position: 30 }] }
      NRooms,

      @UI.fieldGroup: [{ qualifier: 'Address', position: 10 }]
      AddressLine,
      @UI.fieldGroup: [{ qualifier: 'Address', position: 20 }]
      City,
      @UI.fieldGroup: [{ qualifier: 'Address', position: 30 }]
      State,
      @UI.fieldGroup: [{ qualifier: 'Address', position: 40 }]
      Country,

      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 10 }]
      CreatedBy,
      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 20 }]
      CreatedAt,
      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 30 }]
      LastChangedBy,
      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 40 }]
      LastChangedAt,

      @UI.hidden: true
      ExcelRowNumber
}
