# Source Field Analysis - Sprint 1

## Status

Document de analiza pentru Sprint 1 pe baza fisierelor reale incarcate local.

Scop: stabilirea surselor reale, a campurilor disponibile, a cheilor de matching si a riscurilor inainte de implementarea Import Engine, ProductMapping si FAPLot.

## Fisiere analizate

- `nomenclator.xlsx`
- `Fisa de magazie wme.XLSX`
- `trasabilitate wms.CSV`
- `raport productie wms.CSV`
- `Anexa_Control_Proiect_FAP_WME_WMS.xlsx`

## Principiu arhitectural confirmat

- WinMentor / WME ramane sursa scriptica si comerciala.
- Axes / xTrack WMS ramane sursa fizica si operationala pe loturi.
- Aplicatia FAP ramane stratul separat pentru conformitate, QA, audit, trasabilitate, recall si exporturi.
- WME si WMS nu se suprascriu unul pe altul.
- Aplicatia FAP trebuie sa pastreze separat cantitatile scriptice WME, cantitatile fizice WMS, sursa fiecarei date si diferentele de reconciliere.

## 1. Nomenclator produse

Fisier: `nomenclator.xlsx`

### Structura detectata

Sheet principal: `Sheet`

Randuri produse: 1764

Coloane:

- `Cod articol`
- `Denumire`
- `Greutate:`
- `U.M.`
- `Bucati in Bax`

### Observatii

- Majoritatea codurilor sunt coduri operationale de tip `DS...`.
- Au fost identificate 1649 coduri cu prefix `DS`.
- Nomenclatorul se potriveste foarte bine cu codurile WMS.
- Nomenclatorul trebuie folosit ca baza pentru entitatea `Product`.

### Decizie Sprint 1

Se creeaza modelul `Product` pornind de la nomenclator, cu campurile minime:

- `productCode`
- `name`
- `baseUom`
- `weight`
- `unitsPerBox`
- `isFapRelevant`
- `active`

Campurile FAP avansate, cum ar fi specie, cod vamal, stare produs, captura/acvacultura sau GTIN, raman pentru completare ulterioara daca nu exista in nomenclatorul primit.

## 2. Fisa de magazie WME

Fisier: `Fisa de magazie wme.XLSX`

### Structura detectata

Sheet: `Sheet1`

Randuri totale sheet: 137554

Randuri de miscari detectate: 136676

Sectiuni articol detectate: 865

### Campuri observate operational

Fisierul nu are un rand header tabular standard in zona de date, dar structura randurilor este stabila.

Campuri observate pe randurile de miscare:

- numar linie
- tip document
- numar document
- data document
- cantitate intrare
- cantitate iesire
- sold
- pret / valoare unitara aparenta
- cod gestiune / identificator intern
- gestiune / partener / destinatie
- denumire articol
- camp lot / referinta partiala, in multe randuri gol
- cod intern WME numeric
- gestiune denumire
- unitate masura
- utilizator / referinta proces
- identificator linie / referinta interna

### Tipuri document detectate

- `NT`: 43154 linii
- `AE`: 41090 linii
- `BC`: 33919 linii
- `NP`: 7781 linii
- `F`: 6775 linii
- `PV`: 1437 linii
- `StocInitial`: 1346 linii
- `FE`: 1174 linii

### Unitati de masura detectate

- `KG`: 79090 linii
- `BUC`: 53901 linii
- `M3`: 3265 linii
- `PG`: 418 linii
- `BAX`: 2 linii

### Observatii critice

- WME nu foloseste direct codurile `DS...` din WMS/nomenclator.
- WME foloseste un cod intern numeric pentru articol.
- Potrivirea directa cod WME numeric -> cod nomenclator este practic inexistenta.
- Potrivirea dupa denumire WME -> denumire nomenclator este foarte buna: 853 din 865 denumiri WME au potrivire exacta normalizata in nomenclator.
- Potrivirea dupa denumire WME -> denumire WMS este buna: 754 din 865 denumiri WME au potrivire exacta normalizata in WMS trace.

### Risc

Nu se poate construi import FAP sigur folosind doar codurile WME si WMS ca si cum ar fi aceeasi cheie.

### Decizie Sprint 1

`ProductMapping` este obligatoriu inainte de creare automata FAPLot.

Maparea trebuie sa permita:

- cod intern WME numeric
- denumire WME
- cod articol FAP/nomenclator
- cod articol WMS
- denumire WMS
- status mapare: `needs_review`, `active`, `blocked`
- audit aprobare mapare

## 3. Trasabilitate WMS

Fisier: `trasabilitate wms.CSV`

### Structura detectata

Randuri: 182184

Coloane: 20

Coloane:

- `Data`
- `Cod articol`
- `Denumire articol`
- `Locatie sursa`
- `Locatie destinatie`
- `Palet sursa`
- `Palet destinatie`
- `Numar comanda`
- `Depozit`
- `Partener`
- `Tip operatiune`
- `Cantitate`
- `Persoana`
- `Cod-motiv`
- `Document intrare`
- `Document comanda`
- `Lot`
- `UM`
- `Proprietar`
- `Detalii`

### Tipuri operatiune detectate

- `Mutare`: 72464 linii
- `Livrare`: 40129 linii
- `Ajustare negativa`: 33739 linii
- `Mutare intre gestiuni`: 17864 linii
- `Receptie`: 9190 linii
- `Ajustare pozitiva`: 8779 linii
- `Incarcare Camion`: 18 linii

### Unitati de masura detectate

- `Kilogram`: 102504 linii
- `BUCATA`: 75488 linii
- `M3`: 3210 linii
- `PG`: 962 linii
- `BAX`: 1 linie

### Observatii coduri

- Coduri articol unice in WMS trace: 760
- Coduri WMS trace prezente in nomenclator: 757
- Coduri WMS trace neidentificate in nomenclator: `10006`, `20009`, `50006`

### Observatii loturi

- Campul `Lot` este prezent si aproape complet.
- Au fost observate 19 randuri fara lot.

### Decizie Sprint 1

Se creeaza modelul `WmsTraceMovement` cu campurile minime:

- `importBatchId`
- `sourceRowHash`
- `movementDate`
- `wmsProductCode`
- `productName`
- `sourceLocation`
- `destinationLocation`
- `sourcePallet`
- `destinationPallet`
- `orderNo`
- `warehouse`
- `partnerName`
- `operationTypeRaw`
- `operationTypeNormalized`
- `quantity`
- `uom`
- `documentInNo`
- `documentOrderNo`
- `wmsLotNo`
- `owner`
- `details`

Tipurile operatie trebuie normalizate intern, dar valoarea originala trebuie pastrata.

Mapare initiala propusa:

- `Receptie` -> `receipt`
- `Mutare` -> `move`
- `Mutare intre gestiuni` -> `transfer`
- `Livrare` -> `dispatch`
- `Incarcare Camion` -> `truck_loading`
- `Ajustare pozitiva` -> `positive_adjustment`
- `Ajustare negativa` -> `negative_adjustment`

## 4. Raport productie WMS

Fisier: `raport productie wms.CSV`

### Structura detectata

Randuri: 31765

Coloane: 35

Coloane principale:

- `id`
- `idOrderMaster`
- `Numar Comanda`
- `Serie`
- `Serie/Numar`
- `Client`
- `Data Start`
- `Data Finalizare`
- `Persoana Adaugare`
- `Stare`
- `PRE_ID Articol`
- `PRE_Cod Articol`
- `PRE_Denumire Articol`
- `PRE_Cantitate Reteta`
- `PRE_Cantitate Predare`
- `Greutate PRE_Articol_Totala(KG)`
- `PRE_U.M.`
- `PRE_LOT`
- `PRE_DataExpirare`
- `PRE_DataProdutie`
- `PRE_Pierdere`
- `PRE_Pierdere_Procente`
- `Furnizor`
- `CON_Id Articol`
- `CON_Cod Articol`
- `CON_Denumire Articol`
- `CON_Cantitate Reteta`
- `CON_Cantitate Consumata`
- `CON_U.M.`
- `CON_LOT`
- `CON_DataExpirare`
- `CON_DataProductie`
- `Utilaj Productie`
- `Greutate CON_Articol(KG)`
- `Greutate CON_Articol_Totala(KG)`

### Interpretare campuri

- `PRE_*` reprezinta produsul predat / output / lot rezultat.
- `CON_*` reprezinta consumul / input.
- `Numar Comanda` si `Serie/Numar` sunt candidati pentru identificarea comenzii de productie.
- `PRE_LOT` este candidatul principal pentru lot finit sau lot rezultat.
- `CON_LOT` este candidatul principal pentru lot input.

### Observatii

- Toate liniile au starea `Inchisa`.
- Coduri PRE unice: 130.
- Toate codurile PRE au fost gasite in nomenclator.
- Coduri CON unice: 224.
- 222 coduri CON au fost gasite in nomenclator.
- Coduri CON neidentificate in nomenclator: `20009`, `50006`.
- Exista consumuri de ambalaje si materiale auxiliare, nu doar materie prima FAP.

### Decizie Sprint 1

Se creeaza modelele:

- `WmsProductionOrder`
- `WmsProductionInput`
- `WmsProductionOutput`

Importul productie trebuie sa pastreze separat inputurile si outputurile.

Nu este permisa agregarea inputurilor intr-un text liber de tip `diverse loturi`.

## 5. Anexa control proiect

Fisier: `Anexa_Control_Proiect_FAP_WME_WMS.xlsx`

Sheet-uri detectate:

- `00_Dashboard`
- `01_Surse_Date`
- `02_Campuri_Import`
- `03_Mapari_Produse`
- `04_Loturi_Pilot`
- `05_Reconciliere`
- `06_Intrebari_Ofertant`
- `07_Scor_Oferta`
- `08_Glosar`

Observatii:

- Anexa confirma cele 3 surse principale: WME fisa magazie, WMS trasabilitate, WMS raport productie.
- Anexa include matrice de campuri, mapare produse, loturi pilot si reconciliere.
- Acest fisier trebuie folosit ca document de control QA/proiect, nu ca sursa operationala de import.

## 6. Matching preliminar intre surse

### Product matching

Regula propusa:

1. WMS `Cod articol` se potriveste cu nomenclator `Cod articol`.
2. WME se potriveste initial prin denumire normalizata si cod intern WME.
3. Maparea finala trebuie aprobata in `ProductMapping`.

Statusuri:

- `active`: mapare aprobata si folosita automat.
- `needs_review`: mapare propusa, necesita verificare.
- `blocked`: mapare respinsa sau produs exclus din flux FAP.

### Receipt matching WME - WMS

Candidati matching:

- produs mapat
- document intrare WME / document intrare WMS
- data apropiata
- cantitate apropiata
- partener / furnizor
- lot, daca exista in ambele surse

Statusuri propuse:

- `matched_exact`
- `matched_with_warning`
- `unmatched_wme`
- `unmatched_wms`
- `quantity_difference`
- `conflict`

### Production matching

Regula:

- `CON_LOT` trebuie sa fie legat de un FAPLot input existent.
- `PRE_LOT` genereaza sau identifica FAPLot de tip finished/intermediate.
- Daca inputul lipseste, productia devine `incomplete`.
- Daca produsul input/output nu este mapat, productia ramane blocata pentru procesare automata.

## 7. Modele DB propuse pentru urmatorul pas

### Product

- `id`
- `productCode`
- `name`
- `baseUom`
- `weight`
- `unitsPerBox`
- `isFapRelevant`
- `active`
- `createdAt`
- `updatedAt`

### ProductMapping

- `id`
- `wmeProductCode`
- `wmeProductName`
- `wmsProductCode`
- `wmsProductName`
- `productId`
- `mappingStatus`
- `confidence`
- `approvedBy`
- `approvedAt`
- `createdAt`

### ImportBatch

- `id`
- `sourceSystemId`
- `importType`
- `fileName`
- `fileHash`
- `totalRows`
- `acceptedRows`
- `rejectedRows`
- `warningRows`
- `status`
- `importedAt`

### ImportLine

- `id`
- `importBatchId`
- `rowNumber`
- `rawData`
- `normalizedData`
- `entityTypeCreated`
- `entityIdCreated`
- `status`
- `errorCode`
- `errorMessage`
- `createdAt`

### WmeMovement

- `id`
- `importBatchId`
- `sourceRowHash`
- `documentType`
- `documentNo`
- `movementDate`
- `wmeProductCode`
- `productName`
- `quantityIn`
- `quantityOut`
- `balanceQuantity`
- `uom`
- `warehouseCode`
- `warehouseName`
- `partnerName`
- `referenceNo`

### WmsTraceMovement

- `id`
- `importBatchId`
- `sourceRowHash`
- `movementDate`
- `wmsProductCode`
- `productName`
- `operationTypeRaw`
- `operationTypeNormalized`
- `quantity`
- `uom`
- `wmsLotNo`
- `sourceLocation`
- `destinationLocation`
- `sourcePallet`
- `destinationPallet`
- `documentInNo`
- `documentOrderNo`
- `partnerName`

### WmsProductionOrder

- `id`
- `importBatchId`
- `wmsProductionNo`
- `serie`
- `serieNo`
- `clientName`
- `startedAt`
- `completedAt`
- `statusRaw`
- `createdByName`
- `machineName`

### WmsProductionInput

- `id`
- `wmsProductionOrderId`
- `inputProductCode`
- `inputProductName`
- `inputLotNo`
- `recipeQuantity`
- `consumedQuantity`
- `uom`
- `expiryDate`
- `productionDate`
- `unitWeightKg`
- `totalWeightKg`

### WmsProductionOutput

- `id`
- `wmsProductionOrderId`
- `outputProductCode`
- `outputProductName`
- `outputLotNo`
- `recipeQuantity`
- `producedQuantity`
- `uom`
- `expiryDate`
- `productionDate`
- `lossQuantity`
- `lossPercent`
- `totalWeightKg`

## 8. Gap-uri si riscuri

### GAP-001: WME nu foloseste codurile DS

Impact: mare.

Masura: ProductMapping obligatoriu. Matching automat doar dupa aprobarea maparii.

### GAP-002: WME nu are header tabular standard

Impact: mediu.

Masura: parser dedicat pentru structura fisei de magazie, nu import generic simplu.

### GAP-003: Lotul in WME pare incomplet sau absent pe multe randuri

Impact: mare pentru matching direct receptie-lot.

Masura: WMS devine sursa principala pentru lot fizic; WME ramane sursa scriptica/documentara.

### GAP-004: WMS include ambalaje si materiale auxiliare

Impact: mediu.

Masura: Product trebuie sa aiba clasificare produs: FAP / ambalaj / material auxiliar / non-FAP.

### GAP-005: Docker local indisponibil pe statia testata

Impact: scazut pentru analiza; mediu pentru dezvoltare locala.

Masura: flux PostgreSQL local acceptat temporar si documentat.

## 9. Decizie Sprint 1

Nu se implementeaza direct FAPLot pana cand nu exista cel putin:

1. `Product`
2. `ProductMapping`
3. `ImportBatch`
4. `ImportLine`
5. `WmeMovement`
6. `WmsTraceMovement`
7. `WmsProductionOrder`
8. `WmsProductionInput`
9. `WmsProductionOutput`

Dupa aceste modele, se poate implementa prima versiune de creare FAPLot si reconciliere WME/WMS.

## 10. Urmatorul pas tehnic

Urmatorul PR tehnic recomandat:

`feat(api): add import source data models`

Scope permis:

- extindere Prisma schema cu modelele de import si produse;
- migrare DB;
- seed optional pentru tipuri source/import;
- fara parsere reale inca;
- fara UI nou;
- fara creare FAPLot inca.

Definition of Done pentru urmatorul PR:

- `pnpm db:generate` trece;
- `pnpm --filter api build` trece;
- `pnpm --filter web build` nu este afectat;
- migrarea este verificata local pe PostgreSQL;
- nu se introduc date reale sau fisiere sursa in repository.
