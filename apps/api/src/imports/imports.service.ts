import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';

@Injectable()
export class ImportsService {
  constructor(private readonly prisma: PrismaService) {}

  findAll() {
    return this.prisma.importBatch.findMany({
      include: {
        sourceSystem: true,
      },
      orderBy: [{ importedAt: 'desc' }, { createdAt: 'desc' }],
      take: 100,
    });
  }
}
