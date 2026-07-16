import {
  boolean,
  integer,
  numeric,
  pgTable,
  serial,
  text,
  timestamp,
} from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod/v4";

export const menuItemsTable = pgTable("menu_items", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  description: text("description").notNull(),
  price: numeric("price", { precision: 10, scale: 2 }).notNull(),
  category: text("category").notNull(),
  imageUrl: text("image_url"),
  isFeatured: boolean("is_featured").notNull().default(false),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const insertMenuItemSchema = createInsertSchema(menuItemsTable).omit({
  id: true,
  createdAt: true,
});
export type InsertMenuItem = z.infer<typeof insertMenuItemSchema>;
export type MenuItemRow = typeof menuItemsTable.$inferSelect;

export const menuItemReviewsTable = pgTable("menu_item_reviews", {
  id: serial("id").primaryKey(),
  menuItemId: integer("menu_item_id")
    .notNull()
    .references(() => menuItemsTable.id, { onDelete: "cascade" }),
  authorName: text("author_name").notNull(),
  rating: integer("rating").notNull(),
  comment: text("comment"),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const insertMenuItemReviewSchema = createInsertSchema(
  menuItemReviewsTable,
).omit({ id: true, createdAt: true });
export type InsertMenuItemReview = z.infer<typeof insertMenuItemReviewSchema>;
export type MenuItemReviewRow = typeof menuItemReviewsTable.$inferSelect;
