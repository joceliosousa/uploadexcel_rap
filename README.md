# Upload Excel em massa

Não apenas uma, mas três dicas para implementar chamada de arquivo do Excel para cadastro ou edição em massa em um App desenvolvido em RAP - oData, no OnPremise.
Neste tutorial, pretendo listar meus favoritos, não limitando-os a utilizar outras implementações que estão disponíveis e muita gente utiliza. 

O primeiro, para mim foi o primeiro, usando RAP + custom action UI5 - XLXS.js

## Módulo XLSX

Este, reconhecidamente funciona. Já uso há vários anos em alguns dos apps que desenvolvi. Como está diponível a mais tempo, tenho mais base para falar bastante dele, e recomendar.

O desenvolvimento segue uma receita de bolo, que é encontrada no seguinte link: https://community.sap.com/t5/technology-blog-posts-by-members/excel-upload-using-rap-part-1/ba-p/13545399

A primeira parte fala como criar os objetos RAP e disponibilizar o APP, Creating an OData Service using SAP RAP Model. Siga os passos e crie todos os objetos necessários, que nada mais são dos que objetos necessários para gerar o APP RAP como Fiori elments.
Lembrem-se de ajustar o BDEF, como mostrado abaixo, para poder disponibilizar o método Adjust_numbes e implementar a geração automática do código ID; lembrem-se também de criar a SNRO relativa a esta numeração.

![image](https://github.com/user-attachments/assets/2b98a11d-0693-49f8-b930-e5b232abbcdd)

![image](https://github.com/user-attachments/assets/9fa8bf69-6c32-459d-8b7b-3263d26f2dc3)


A segunda parte fala como Extender o app Fiori elements com a funcionanlidade do upload.
Para isso, siga os passos e utilize o Guided Development para implementar o botão e customize o fragment (diálogo que mostrará quando clicar no botão upload excel). Para que já está acostumado utilizar o Guided development, é bem simples. Para que não está, siga os passos e veja qual simples é.
Ao final da parte 2, já temos como abrir o diálogo do upload excel através do custom button criado.

![image](https://github.com/user-attachments/assets/8e02a705-4bee-48cf-9a21-0ec2f1cab71a)


O passo três fala de como instalar o módulo e configurar para subir junto no deploy. 

Dica: Pode utilizar o XLSX.js dentro da pasta ext, com isso você elimina a parte de precisar configurar os arquivos .yaml.

![image](https://github.com/user-attachments/assets/8f90ecd2-24ac-4817-b14c-521d12eb067e)

Arquivo disponível no link:

Resultado:


![upload excel 1](https://github.com/user-attachments/assets/ff3a922e-a40c-4a4f-9c4a-43e8bc64337a)


Upload Excel com UI5 Custom Spreadsheet Upload

Este atualmente é o mais documentado e simples de utilzar. Tem seus prós e contras, mas atende bem.
A documentação está disponível em: https://docs.spreadsheet-importer.com/pages/GettingStarted/

Lá você vai encontrar um passo a passo completo para aplicar em diversas plataformas, seja no BTP ou OnPremise.

Basicamente teremos, da mesma forma que no anterior, que extender e criar um custom button - pelo Grided Development, copiar e coloar um arquivo ListReport.controller.js (acho mais fácil copiar e colar) e depois ajustar alguns trechos no manifest.

Utilize como parâmetro para o cenário odata v2, este exemplo disponibilizado em https://github.com/spreadsheetimporter/ui5-cc-spreadsheetimporter/tree/main/examples/packages/ordersv2fe

Copie os arquivos da pasta ext, e altere onde necessitar para o cenário pretendido. Normalmente não se altera muita coisa a não ser que tenha que converter algum tipo de dado...

Alguns detalhes: para fazer o deploy corretamente não esqueça de instalar o módulo: **npm install ui5-cc-spreadsheetimporter**

Este trechos do manifest:

...
```
      "mainService": {
        "uri": "/sap/opu/odata/sap/ZUI_SD_CARTONIZA_P_O2/",
        "type": "OData",
        "settings": {
          "annotations": [
            "ZUI_SD_CARBONIZA_P_O2_VAN",
            "annotation"
          ],
          "localUri": "localService/mainService/metadata.xml",
          "odataVersion": "2.0"
        }
      }
    },

    "embeds": [
      "thirdparty/customcontrol/spreadsheetimporter/v2_1_0"
    ]

  },
  "sap.ui": {
    "technology": "UI5",


...
   "extends": {
      "extensions": {
        "sap.ui.controllerExtensions": {
          "sap.suite.ui.generic.template.ListReport.view.ListReport": {
            "controllerName": "br.paramcartonizacao.ext.controller.ListReportExt",
            "sap.ui.generic.app": {
              "ZUI_SD_CARTONIZA_P": {
                "EntitySet": "CartonizacaoParam",
                "Actions": {
                  "spreadsheetUploadButton": {
                    "id": "spreadsheetUploadButtonButton",
                    "text": "Upload Excel",
                    "press": "openSpreadsheetUpload",
                    "requiresSelection": false
                  }
                }
              }
            }
          }
        }
      }
    },

    "resourceRoots": {
      "cc.spreadsheetimporter.v2_1_0": "./thirdparty/customcontrol/spreadsheetimporter/v2_1_0"
    },
    "componentUsages": {
      "spreadsheetImporter": {
        "name": "cc.spreadsheetimporter.v2_1_0"
      }
    }
  },

  "sap.ui.generic.app": {
    "_version": "1.3.0",
    "settings": {
      "forceGlobalRefresh": false,
      "objectPageHeaderType": "Dynamic",
      "considerAnalyticalParameters": true,
      "showDraftToggle": false
    },
```
...


> Importante: Ao fazer deploy mais de uma vez ele vai dar erro:
Duplicate Id: Id cc.spreadsheetimporter.v2_1_0 already contained in SAPUI5 Repository ZUI5_CAD_RESTRI
AP Note: See SAP Note 2177717 for more details (https://launchpad.support.sap.com/#/notes/2177717
pois está levando o mesmo ID do componente e isso não é possível... Ele indica a nota https://me.sap.com/notes/2177717, inviável. uma alterativa que achei foi alterar o nome dentro da pasta node_modules -> ui5-cc-spreadsheetimporter
no manifest, alterar algo no ID. no meu caso coloquei um _1 ou até o id do app (mesmo do manifest do app).

![image](https://github.com/user-attachments/assets/93b07e54-ea3d-4b8f-8c8e-929d582b57a3)

Resultado:
![cc-spreadsheet](https://github.com/user-attachments/assets/3004f01f-9165-49e0-b599-f3b2e124811f)

## RAP + Upload file Stream

Esta útima opção que trago é totalmente Clean Core, feito com RAP e Fiori elements.

Mais uma vez, obrigado aos colegas do Heroes.
https://software-heroes.com/en/blog/abap-rap-upload-of-files-stream

Ele é indcado para quando, de dentro de um app onde você tem uma object page com várias children (tabelas), você faz o upload na object page principal e então com os dados do Excel, as filhas são preenchidas, evitando retrabalho de digitar.


![mimeType](https://github.com/user-attachments/assets/bce7c7af-8f99-4b01-b36f-63ee317ac811)

Neste mesmo repositório disponibilizo as três opções, com exemplos dos objetos ABAP e o os arquivos do APP.








