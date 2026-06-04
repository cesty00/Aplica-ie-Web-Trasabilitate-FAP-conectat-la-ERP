import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';

@Injectable()
export class ProductsService {
  constructor(private readonly prisma: PrismaService) {}

  findAll() {
    return this.prisma.product.findMany({
      orderBy: [{ name: 'asc' }, { productCode: 'asc' }],
      take: 100,
    });
  }
}
