import { PrismaClient } from "@prisma/client";

const setClient = (value: string) => `set local "app.client" = '${value}';`;

const setWarehouse = (value: string) =>
  `set local "app.warehouse" = '${value}';`;

const main = async () => {
  const prisma = new PrismaClient();

  await prisma.$transaction(async (prisma) => {
    await prisma.$executeRawUnsafe(setClient("NPS"));
    await prisma.$executeRawUnsafe(setWarehouse("01"));

    return await prisma.shipment.create({
      data: { notes: "My super awesome notes!" },
    });
  });
};

main();
