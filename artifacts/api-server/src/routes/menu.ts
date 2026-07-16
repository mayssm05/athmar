import { Router, type IRouter } from "express";
import { and, avg, count, eq } from "drizzle-orm";
import {
  db,
  menuItemsTable,
  menuItemReviewsTable,
  type MenuItemRow,
} from "@workspace/db";
import {
  ListMenuItemsQueryParams,
  ListMenuItemsResponse,
  GetMenuItemParams,
  GetMenuItemResponse,
  ListMenuCategoriesResponse,
  ListMenuItemReviewsParams,
  ListMenuItemReviewsResponse,
  CreateMenuItemReviewParams,
  CreateMenuItemReviewBody,
  CreateMenuItemReviewResponse,
} from "@workspace/api-zod";

const router: IRouter = Router();

function serializeMenuItem(
  row: MenuItemRow,
  averageRating: number | null,
  reviewCount: number,
) {
  return {
    id: row.id,
    name: row.name,
    description: row.description,
    price: Number(row.price),
    category: row.category,
    imageUrl: row.imageUrl,
    isFeatured: row.isFeatured,
    averageRating,
    reviewCount,
    createdAt: row.createdAt,
  };
}

router.get("/menu-categories", async (_req, res): Promise<void> => {
  const rows = await db
    .select({
      name: menuItemsTable.category,
      itemCount: count(menuItemsTable.id),
    })
    .from(menuItemsTable)
    .groupBy(menuItemsTable.category)
    .orderBy(menuItemsTable.category);

  res.json(
    ListMenuCategoriesResponse.parse(
      rows.map((row) => ({ name: row.name, itemCount: Number(row.itemCount) })),
    ),
  );
});

router.get("/menu-items", async (req, res): Promise<void> => {
  const query = ListMenuItemsQueryParams.safeParse(req.query);
  if (!query.success) {
    res.status(400).json({ error: query.error.message });
    return;
  }

  const conditions = [];
  if (query.data.category) {
    conditions.push(eq(menuItemsTable.category, query.data.category));
  }
  if (query.data.featured !== undefined) {
    conditions.push(eq(menuItemsTable.isFeatured, query.data.featured));
  }

  const rows = await db
    .select({
      item: menuItemsTable,
      averageRating: avg(menuItemReviewsTable.rating),
      reviewCount: count(menuItemReviewsTable.id),
    })
    .from(menuItemsTable)
    .leftJoin(
      menuItemReviewsTable,
      eq(menuItemReviewsTable.menuItemId, menuItemsTable.id),
    )
    .where(conditions.length > 0 ? and(...conditions) : undefined)
    .groupBy(menuItemsTable.id)
    .orderBy(menuItemsTable.category, menuItemsTable.name);

  res.json(
    ListMenuItemsResponse.parse(
      rows.map((row) =>
        serializeMenuItem(
          row.item,
          row.averageRating !== null ? Number(row.averageRating) : null,
          Number(row.reviewCount),
        ),
      ),
    ),
  );
});

router.get("/menu-items/:id", async (req, res): Promise<void> => {
  const params = GetMenuItemParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }

  const rows = await db
    .select({
      item: menuItemsTable,
      averageRating: avg(menuItemReviewsTable.rating),
      reviewCount: count(menuItemReviewsTable.id),
    })
    .from(menuItemsTable)
    .leftJoin(
      menuItemReviewsTable,
      eq(menuItemReviewsTable.menuItemId, menuItemsTable.id),
    )
    .where(eq(menuItemsTable.id, params.data.id))
    .groupBy(menuItemsTable.id);

  const row = rows[0];
  if (!row) {
    res.status(404).json({ error: "Menu item not found" });
    return;
  }

  res.json(
    GetMenuItemResponse.parse(
      serializeMenuItem(
        row.item,
        row.averageRating !== null ? Number(row.averageRating) : null,
        Number(row.reviewCount),
      ),
    ),
  );
});

router.get("/menu-items/:id/reviews", async (req, res): Promise<void> => {
  const params = ListMenuItemReviewsParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }

  const [item] = await db
    .select({ id: menuItemsTable.id })
    .from(menuItemsTable)
    .where(eq(menuItemsTable.id, params.data.id));

  if (!item) {
    res.status(404).json({ error: "Menu item not found" });
    return;
  }

  const reviews = await db
    .select()
    .from(menuItemReviewsTable)
    .where(eq(menuItemReviewsTable.menuItemId, params.data.id))
    .orderBy(menuItemReviewsTable.createdAt);

  res.json(
    ListMenuItemReviewsResponse.parse(
      reviews.map((review) => ({
        id: review.id,
        menuItemId: review.menuItemId,
        authorName: review.authorName,
        rating: review.rating,
        comment: review.comment,
        createdAt: review.createdAt,
      })),
    ),
  );
});

router.post("/menu-items/:id/reviews", async (req, res): Promise<void> => {
  const params = CreateMenuItemReviewParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }

  const body = CreateMenuItemReviewBody.safeParse(req.body);
  if (!body.success) {
    res.status(400).json({ error: body.error.message });
    return;
  }

  const [item] = await db
    .select({ id: menuItemsTable.id })
    .from(menuItemsTable)
    .where(eq(menuItemsTable.id, params.data.id));

  if (!item) {
    res.status(404).json({ error: "Menu item not found" });
    return;
  }

  const [review] = await db
    .insert(menuItemReviewsTable)
    .values({
      menuItemId: params.data.id,
      authorName: body.data.authorName,
      rating: body.data.rating,
      comment: body.data.comment ?? null,
    })
    .returning();

  res.status(201).json(CreateMenuItemReviewResponse.parse(review));
});

export default router;
