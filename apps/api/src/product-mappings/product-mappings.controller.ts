import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ProductMappingsService } from './product-mappings.service';

@ApiTags('product-mappings')
@Controller('product-mappings')
export class ProductMappingsController {
  constructor(private readonly productMappingsService: ProductMappingsService) {}

  @Get()
  @ApiOkResponse({ description: 'List product mappings, limited to the first 100 records.' })
  findAll() {
    return this.productMappingsService.findAll();
  }
}
