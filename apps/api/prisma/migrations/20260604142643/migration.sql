-- CreateEnum
CREATE TYPE "ProductMappingStatus" AS ENUM ('active', 'needs_review', 'blocked');

-- CreateEnum
CREATE TYPE "ImportBatchStatus" AS ENUM ('success', 'partial', 'failed', 'processing');

-- CreateEnum
CREATE TYPE "ImportLineStatus" AS ENUM ('imported', 'warning', 'rejected', 'duplicate');

-- CreateEnum
CREATE TYPE "WmsOperationType" AS ENUM ('receipt', 'move', 'transfer', 'dispatch', 'truck_loading', 'positive_adjustment', 'negative_adjustment', 'unknown');

-- AlterTable
ALTER TABLE "AuditLog" ALTER COLUMN "id" DROP DEFAULT;

-- AlterTable
ALTER TABLE "Role" ALTER COLUMN "id" DROP DEFAULT;

-- AlterTable
ALTER TABLE "SourceSystem" ALTER COLUMN "id" DROP DEFAULT;

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "id" DROP DEFAULT;

-- AlterTable
ALTER TABLE "UserRole" ALTER COLUMN "id" DROP DEFAULT;

-- CreateTable
CREATE TABLE "Product" (
    "id" UUID NOT NULL,
    "productCode" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "baseUom" TEXT NOT NULL,
    "weight" DECIMAL(14,3),
    "unitsPerBox" DECIMAL(14,3),
    "isFapRelevant" BOOLEAN NOT NULL DEFAULT false,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductMapping" (
    "id" UUID NOT NULL,
    "wmeProductCode" TEXT,
    "wmeProductName" TEXT NOT NULL,
    "wmsProductCode" TEXT NOT NULL,
    "wmsProductName" TEXT NOT NULL,
    "productId" UUID NOT NULL,
    "mappingStatus" "ProductMappingStatus" NOT NULL DEFAULT 'needs_review',
    "confidence" DECIMAL(5,2),
    "approvedBy" UUID,
    "approvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductMapping_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ImportBatch" (
    "id" UUID NOT NULL,
    "sourceSystemId" UUID NOT NULL,
    "importType" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "fileHash" TEXT,
    "totalRows" INTEGER NOT NULL DEFAULT 0,
    "acceptedRows" INTEGER NOT NULL DEFAULT 0,
    "rejectedRows" INTEGER NOT NULL DEFAULT 0,
    "warningRows" INTEGER NOT NULL DEFAULT 0,
    "status" "ImportBatchStatus" NOT NULL DEFAULT 'processing',
    "errorSummary" JSONB,
    "importedBy" UUID,
    "importedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ImportBatch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ImportLine" (
    "id" UUID NOT NULL,
    "importBatchId" UUID NOT NULL,
    "rowNumber" INTEGER NOT NULL,
    "rawData" JSONB NOT NULL,
    "normalizedData" JSONB,
    "entityTypeCreated" TEXT,
    "entityIdCreated" UUID,
    "status" "ImportLineStatus" NOT NULL,
    "errorCode" TEXT,
    "errorMessage" TEXT,
    "severity" TEXT,
    "resolutionStatus" TEXT NOT NULL DEFAULT 'open',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ImportLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WmeMovement" (
    "id" UUID NOT NULL,
    "importBatchId" UUID NOT NULL,
    "sourceRowHash" TEXT NOT NULL,
    "documentType" TEXT NOT NULL,
    "documentNo" TEXT,
    "movementDate" TIMESTAMP(3) NOT NULL,
    "wmeProductCode" TEXT,
    "productId" UUID,
    "productName" TEXT NOT NULL,
    "quantityIn" DECIMAL(14,3),
    "quantityOut" DECIMAL(14,3),
    "balanceQuantity" DECIMAL(14,3),
    "uom" TEXT NOT NULL,
    "warehouseCode" TEXT,
    "warehouseName" TEXT,
    "partnerName" TEXT,
    "referenceNo" TEXT,
    "rawData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WmeMovement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WmsTraceMovement" (
    "id" UUID NOT NULL,
    "importBatchId" UUID NOT NULL,
    "sourceRowHash" TEXT NOT NULL,
    "movementDate" TIMESTAMP(3) NOT NULL,
    "wmsProductCode" TEXT NOT NULL,
    "productId" UUID,
    "productName" TEXT NOT NULL,
    "operationTypeRaw" TEXT NOT NULL,
    "operationTypeNormalized" "WmsOperationType" NOT NULL DEFAULT 'unknown',
    "quantity" DECIMAL(14,3) NOT NULL,
    "uom" TEXT NOT NULL,
    "wmsLotNo" TEXT,
    "sourceLocation" TEXT,
    "destinationLocation" TEXT,
    "sourcePallet" TEXT,
    "destinationPallet" TEXT,
    "orderNo" TEXT,
    "warehouse" TEXT,
    "partnerName" TEXT,
    "documentInNo" TEXT,
    "documentOrderNo" TEXT,
    "owner" TEXT,
    "details" TEXT,
    "rawData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WmsTraceMovement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WmsProductionOrder" (
    "id" UUID NOT NULL,
    "importBatchId" UUID NOT NULL,
    "wmsProductionNo" TEXT NOT NULL,
    "serie" TEXT,
    "serieNo" TEXT,
    "clientName" TEXT,
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "statusRaw" TEXT,
    "createdByName" TEXT,
    "machineName" TEXT,
    "rawData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WmsProductionOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WmsProductionInput" (
    "id" UUID NOT NULL,
    "wmsProductionOrderId" UUID NOT NULL,
    "inputProductCode" TEXT NOT NULL,
    "inputProductId" UUID,
    "inputProductName" TEXT NOT NULL,
    "inputLotNo" TEXT,
    "recipeQuantity" DECIMAL(14,3),
    "consumedQuantity" DECIMAL(14,3) NOT NULL,
    "uom" TEXT NOT NULL,
    "expiryDate" TIMESTAMP(3),
    "productionDate" TIMESTAMP(3),
    "unitWeightKg" DECIMAL(14,3),
    "totalWeightKg" DECIMAL(14,3),
    "sourceRowHash" TEXT NOT NULL,
    "rawData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WmsProductionInput_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WmsProductionOutput" (
    "id" UUID NOT NULL,
    "wmsProductionOrderId" UUID NOT NULL,
    "outputProductCode" TEXT NOT NULL,
    "outputProductId" UUID,
    "outputProductName" TEXT NOT NULL,
    "outputLotNo" TEXT,
    "recipeQuantity" DECIMAL(14,3),
    "producedQuantity" DECIMAL(14,3) NOT NULL,
    "uom" TEXT NOT NULL,
    "expiryDate" TIMESTAMP(3),
    "productionDate" TIMESTAMP(3),
    "lossQuantity" DECIMAL(14,3),
    "lossPercent" DECIMAL(8,3),
    "totalWeightKg" DECIMAL(14,3),
    "sourceRowHash" TEXT NOT NULL,
    "rawData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WmsProductionOutput_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Product_productCode_key" ON "Product"("productCode");

-- CreateIndex
CREATE INDEX "ProductMapping_wmeProductCode_idx" ON "ProductMapping"("wmeProductCode");

-- CreateIndex
CREATE INDEX "ProductMapping_wmsProductCode_idx" ON "ProductMapping"("wmsProductCode");

-- CreateIndex
CREATE INDEX "ProductMapping_mappingStatus_idx" ON "ProductMapping"("mappingStatus");

-- CreateIndex
CREATE UNIQUE INDEX "ProductMapping_wmeProductName_wmsProductCode_key" ON "ProductMapping"("wmeProductName", "wmsProductCode");

-- CreateIndex
CREATE INDEX "ImportBatch_sourceSystemId_idx" ON "ImportBatch"("sourceSystemId");

-- CreateIndex
CREATE INDEX "ImportBatch_importType_idx" ON "ImportBatch"("importType");

-- CreateIndex
CREATE INDEX "ImportBatch_status_idx" ON "ImportBatch"("status");

-- CreateIndex
CREATE INDEX "ImportBatch_fileHash_idx" ON "ImportBatch"("fileHash");

-- CreateIndex
CREATE INDEX "ImportLine_status_idx" ON "ImportLine"("status");

-- CreateIndex
CREATE INDEX "ImportLine_errorCode_idx" ON "ImportLine"("errorCode");

-- CreateIndex
CREATE UNIQUE INDEX "ImportLine_importBatchId_rowNumber_key" ON "ImportLine"("importBatchId", "rowNumber");

-- CreateIndex
CREATE UNIQUE INDEX "WmeMovement_sourceRowHash_key" ON "WmeMovement"("sourceRowHash");

-- CreateIndex
CREATE INDEX "WmeMovement_importBatchId_idx" ON "WmeMovement"("importBatchId");

-- CreateIndex
CREATE INDEX "WmeMovement_movementDate_idx" ON "WmeMovement"("movementDate");

-- CreateIndex
CREATE INDEX "WmeMovement_wmeProductCode_idx" ON "WmeMovement"("wmeProductCode");

-- CreateIndex
CREATE INDEX "WmeMovement_documentType_idx" ON "WmeMovement"("documentType");

-- CreateIndex
CREATE INDEX "WmeMovement_documentNo_idx" ON "WmeMovement"("documentNo");

-- CreateIndex
CREATE UNIQUE INDEX "WmsTraceMovement_sourceRowHash_key" ON "WmsTraceMovement"("sourceRowHash");

-- CreateIndex
CREATE INDEX "WmsTraceMovement_importBatchId_idx" ON "WmsTraceMovement"("importBatchId");

-- CreateIndex
CREATE INDEX "WmsTraceMovement_movementDate_idx" ON "WmsTraceMovement"("movementDate");

-- CreateIndex
CREATE INDEX "WmsTraceMovement_wmsProductCode_idx" ON "WmsTraceMovement"("wmsProductCode");

-- CreateIndex
CREATE INDEX "WmsTraceMovement_wmsLotNo_idx" ON "WmsTraceMovement"("wmsLotNo");

-- CreateIndex
CREATE INDEX "WmsTraceMovement_operationTypeNormalized_idx" ON "WmsTraceMovement"("operationTypeNormalized");

-- CreateIndex
CREATE INDEX "WmsTraceMovement_documentInNo_idx" ON "WmsTraceMovement"("documentInNo");

-- CreateIndex
CREATE INDEX "WmsTraceMovement_documentOrderNo_idx" ON "WmsTraceMovement"("documentOrderNo");

-- CreateIndex
CREATE INDEX "WmsProductionOrder_importBatchId_idx" ON "WmsProductionOrder"("importBatchId");

-- CreateIndex
CREATE INDEX "WmsProductionOrder_startedAt_idx" ON "WmsProductionOrder"("startedAt");

-- CreateIndex
CREATE INDEX "WmsProductionOrder_completedAt_idx" ON "WmsProductionOrder"("completedAt");

-- CreateIndex
CREATE UNIQUE INDEX "WmsProductionOrder_wmsProductionNo_key" ON "WmsProductionOrder"("wmsProductionNo");

-- CreateIndex
CREATE UNIQUE INDEX "WmsProductionInput_sourceRowHash_key" ON "WmsProductionInput"("sourceRowHash");

-- CreateIndex
CREATE INDEX "WmsProductionInput_wmsProductionOrderId_idx" ON "WmsProductionInput"("wmsProductionOrderId");

-- CreateIndex
CREATE INDEX "WmsProductionInput_inputProductCode_idx" ON "WmsProductionInput"("inputProductCode");

-- CreateIndex
CREATE INDEX "WmsProductionInput_inputLotNo_idx" ON "WmsProductionInput"("inputLotNo");

-- CreateIndex
CREATE UNIQUE INDEX "WmsProductionOutput_sourceRowHash_key" ON "WmsProductionOutput"("sourceRowHash");

-- CreateIndex
CREATE INDEX "WmsProductionOutput_wmsProductionOrderId_idx" ON "WmsProductionOutput"("wmsProductionOrderId");

-- CreateIndex
CREATE INDEX "WmsProductionOutput_outputProductCode_idx" ON "WmsProductionOutput"("outputProductCode");

-- CreateIndex
CREATE INDEX "WmsProductionOutput_outputLotNo_idx" ON "WmsProductionOutput"("outputLotNo");

-- AddForeignKey
ALTER TABLE "ProductMapping" ADD CONSTRAINT "ProductMapping_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductMapping" ADD CONSTRAINT "ProductMapping_approvedBy_fkey" FOREIGN KEY ("approvedBy") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ImportBatch" ADD CONSTRAINT "ImportBatch_sourceSystemId_fkey" FOREIGN KEY ("sourceSystemId") REFERENCES "SourceSystem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ImportBatch" ADD CONSTRAINT "ImportBatch_importedBy_fkey" FOREIGN KEY ("importedBy") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ImportLine" ADD CONSTRAINT "ImportLine_importBatchId_fkey" FOREIGN KEY ("importBatchId") REFERENCES "ImportBatch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmeMovement" ADD CONSTRAINT "WmeMovement_importBatchId_fkey" FOREIGN KEY ("importBatchId") REFERENCES "ImportBatch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmeMovement" ADD CONSTRAINT "WmeMovement_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmsTraceMovement" ADD CONSTRAINT "WmsTraceMovement_importBatchId_fkey" FOREIGN KEY ("importBatchId") REFERENCES "ImportBatch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmsTraceMovement" ADD CONSTRAINT "WmsTraceMovement_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmsProductionOrder" ADD CONSTRAINT "WmsProductionOrder_importBatchId_fkey" FOREIGN KEY ("importBatchId") REFERENCES "ImportBatch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmsProductionInput" ADD CONSTRAINT "WmsProductionInput_wmsProductionOrderId_fkey" FOREIGN KEY ("wmsProductionOrderId") REFERENCES "WmsProductionOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmsProductionInput" ADD CONSTRAINT "WmsProductionInput_inputProductId_fkey" FOREIGN KEY ("inputProductId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmsProductionOutput" ADD CONSTRAINT "WmsProductionOutput_wmsProductionOrderId_fkey" FOREIGN KEY ("wmsProductionOrderId") REFERENCES "WmsProductionOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WmsProductionOutput" ADD CONSTRAINT "WmsProductionOutput_outputProductId_fkey" FOREIGN KEY ("outputProductId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;
