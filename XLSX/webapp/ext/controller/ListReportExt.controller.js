sap.ui.define(["sap/ui/core/Fragment", "sap/m/MessageToast","./xlsx"],
function (Fragment, MessageToast, XLSX){
    "use strict";
    return {
        // this variable will hold the data of excel file
        excelSheetsData: [],
        pDialog: null,

        openExcelUploadDialog: function(oEvent) {
            console.log(XLSX.version)
            this.excelSheetsData = [];
            var oView = this.getView();
            if (!this.pDialog) {
                Fragment.load({
                    id: "excel_upload",
                    name: "fiori.numen.uploadexcel.ext.fragments.ExcelUpload",
                    type: "XML",
                    controller: this
                }).then((oDialog) => {
                    var oFileUploader = Fragment.byId("excel_upload", "uploadSet");
                    oFileUploader.removeAllItems();
                    this.pDialog = oDialog;
                    this.pDialog.open();
                })
                    .catch(error => alert(error.message));
            } else {
                var oFileUploader = Fragment.byId("excel_upload", "uploadSet");
                oFileUploader.removeAllItems();
                this.pDialog.open();
            }
        },
        onUploadSet: function(oEvent) {
            // checking if excel file contains data or not
            if (!this.excelSheetsData.length) {
                MessageToast.show("Select file to Upload");
                return;
            }

            var that = this;
            var oSource = oEvent.getSource();

            // creating a promise as the extension api accepts odata call in form of promise only
            var fnAddMessage = function () {
                return new Promise((fnResolve, fnReject) => {
                    that.callOdata(fnResolve, fnReject);
                });
            };

            var mParameters = {
                sActionLabel: oSource.getText() // or "Your custom text" 
            };
            // calling the oData service using extension api
            this.extensionAPI.securedExecution(fnAddMessage, mParameters);

            this.pDialog.close();
        },
        onTempDownload: function (oEvent) {
            // get the odata model binded to this application
            var oModel = this.getView().getModel();
            // get the property list of the entity for which we need to download the template
            var oBuilding = oModel.getServiceMetadata().dataServices.schema[0].entityType.find(x => x.name === 'BuildingsType');
            var oBuilding2 = oModel.getServiceMetadata().dataServices.schema[0].entityType.find(x => x.name === 'BuildingsType');
            // set the list of entity property, that has to be present in excel file template
            var propertyList = ['BuildingId', 'BuildingName', 'NRooms', 'AddressLine',
                'City', 'State', 'Country'];

            var propertyList2 = [ 'City', 'State', 'Country'];

            var excelColumnList = [];
            var colList = {};
            var excelColumnList2 = [];
            var colList2 = {};

            // finding the property description corresponding to the property id
            propertyList.forEach((value, index) => {
                let property = oBuilding.property.find(x => x.name === value);
                colList[property.extensions.find(x => x.name === 'label').value] = '';
            });
            excelColumnList.push(colList);
            propertyList2.forEach((value, index) => {
                let property2 = oBuilding2.property.find(x => x.name === value);
                colList2[property2.extensions.find(x => x.name === 'label').value] = '';
            });
            excelColumnList2.push(colList2);
            // initialising the excel work sheet
            const ws = XLSX.utils.json_to_sheet(excelColumnList);
            const ws2 = XLSX.utils.json_to_sheet(excelColumnList2);
            // creating the new excel work book
            const wb = XLSX.utils.book_new();
            // set the file value
            XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
            XLSX.utils.book_append_sheet(wb, ws2, 'Sheet2');
            // download the created excel file
            XLSX.writeFile(wb, 'RAP - Buildings.xlsx');

            MessageToast.show("Template File Downloading...");
        },
        onCloseDialog: function (oEvent) {
            this.pDialog.close();
        },
        onBeforeUploadStart: function (oEvent) {
            
        },
        onUploadSetComplete: function (oEvent) {

            // getting the UploadSet Control reference
            var oFileUploader = Fragment.byId("excel_upload", "uploadSet");
            // since we will be uploading only 1 file so reading the first file object
            var oFile = oFileUploader.getItems()[0].getFileObject();

            var reader = new FileReader();
            var that = this;

            reader.onload = (e) => {
                // getting the binary excel file content
                let xlsx_content = e.currentTarget.result;

                let workbook = XLSX.read(xlsx_content, { type: 'binary' });
                // here reading only the excel file sheet- Sheet1
                var excelData = XLSX.utils.sheet_to_row_object_array(workbook.Sheets["Sheet1"]);
                
                workbook.SheetNames.forEach(function (sheetName) {
                    // appending the excel file data to the global variable
                    that.excelSheetsData.push(XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]));
                });
                console.log("Excel Data", excelData);
                console.log("Excel Sheets Data", this.excelSheetsData);
            };
            reader.readAsBinaryString(oFile);

            MessageToast.show("Upload Successful");
        },
        onItemRemoved:function (oEvent) {
            this.excelSheetsData = [];            
        },
        // helper method to call OData
        callOdata: function (fnResolve, fnReject) {
            //  intializing the message manager for displaying the odata response messages
            var oModel = this.getView().getModel();

            // creating odata payload object for Building entity
            var payload = {};

            this.excelSheetsData[0].forEach((value, index) => {
                // setting the payload data
                payload = {
                    "BuildingName": value["Building Name"],
                    "NRooms": value["No of Rooms"],
                    "AddressLine": value["Address Line"],
                    "City": value["City"],
                    "State": value["State"],
                    "Country": value["Country"]
                };
                // setting excel file row number for identifying the exact row in case of error or success
                payload.ExcelRowNumber = (index + 1);
                // calling the odata service
                oModel.create("/Buildings", payload, {
                    success: (result) => {
                        console.log(result);
                        var oMessageManager = sap.ui.getCore().getMessageManager();
                        var oMessage = new sap.ui.core.message.Message({
                            message: "Building Created with ID: " + result.BuildingId,
                            persistent: true, // create message as transition message
                            type: sap.ui.core.MessageType.Success
                        });
                        oMessageManager.addMessages(oMessage);
                        fnResolve();
                    },
                    error: fnReject
                });
            });
        }            
    };
});