import { PrismaClient, SourceSystemType } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const roles = [
    'ADMIN',
    'ACHIZITII_IMPORT',
    'RECEPTIE_DEPOZIT',
    'QA_CONFORMITATE',
    'PRODUCTIE',
    'LOGISTICA_VANZARI',
    'MANAGEMENT',
    'AUDITOR_READONLY'
  ];

  for (const code of roles) {
    await prisma.role.upsert({
      where: { code },
      update: {},
      create: { code, name: code }
    });
  }

  await prisma.sourceSystem.upsert({
    where: { code: 'WME' },
    update: {},
    create: { code: 'WME', name: 'WME', systemType: SourceSystemType.ERP }
  });
  await prisma.sourceSystem.upsert({
    where: { code: 'WMS_TRACE' },
    update: {},
    create: { code: 'WMS_TRACE', name: 'WMS_TRACE', systemType: SourceSystemType.WMS }
  });
  await prisma.sourceSystem.upsert({
    where: { code: 'WMS_PRODUCTION' },
    update: {},
    create: { code: 'WMS_PRODUCTION', name: 'WMS_PRODUCTION', systemType: SourceSystemType.WMS }
  });
  await prisma.sourceSystem.upsert({
    where: { code: 'FAP' },
    update: {},
    create: { code: 'FAP', name: 'FAP', systemType: SourceSystemType.FAP }
  });
  await prisma.sourceSystem.upsert({
    where: { code: 'AI' },
    update: {},
    create: { code: 'AI', name: 'AI', systemType: SourceSystemType.AI }
  });
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
