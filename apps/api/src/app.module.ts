import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DatabaseModule } from './database/database.module';
import { HealthModule } from './health/health.module';
import { ProductMappingsModule } from './product-mappings/product-mappings.module';
import { ProductsModule } from './products/products.module';
import { ImportsModule } from './imports/imports.module';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    DatabaseModule,
    HealthModule,
    ProductsModule,
    ProductMappingsModule,
    ImportsModule,
  ],
})
export class AppModule {}
