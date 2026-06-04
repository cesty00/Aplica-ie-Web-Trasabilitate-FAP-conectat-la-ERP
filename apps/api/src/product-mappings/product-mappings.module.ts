import { Module } from '@nestjs/common';
import { ProductMappingsController } from './product-mappings.controller';
import { ProductMappingsService } from './product-mappings.service';

@Module({
  controllers: [ProductMappingsController],
  providers: [ProductMappingsService],
})
export class ProductMappingsModule {}
