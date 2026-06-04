import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';

@Injectable()
export class ProductMappingsService {
  constructor(private readonly prisma: PrismaService) {}

  findAll() {
    return this.prisma.productMapping.findMany({
      include: {
        product: true,
      },
      orderBy: [{ mappingStatus: 'asc' }, { wmeProductName: 'asc' }],
      take: 100,
    });
  }
}
