import { Router, type IRouter } from "express";
import { db, cateringRequestsTable } from "@workspace/db";
import {
  CreateCateringRequestBody,
  CreateCateringRequestResponse,
} from "@workspace/api-zod";

const router: IRouter = Router();

router.post("/catering-requests", async (req, res): Promise<void> => {
  const body = CreateCateringRequestBody.safeParse(req.body);
  if (!body.success) {
    res.status(400).json({ error: body.error.message });
    return;
  }

  const eventDate = body.data.eventDate.toISOString().slice(0, 10);

  const [request] = await db
    .insert(cateringRequestsTable)
    .values({
      fullName: body.data.fullName,
      email: body.data.email,
      phone: body.data.phone,
      eventType: body.data.eventType,
      eventDate,
      guestCount: body.data.guestCount,
      itemsRequested: body.data.itemsRequested,
      budgetRange: body.data.budgetRange ?? null,
      specialRequests: body.data.specialRequests ?? null,
    })
    .returning();

  res.status(201).json(CreateCateringRequestResponse.parse(request));
});

export default router;
