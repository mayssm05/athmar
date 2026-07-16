import { date, integer, pgTable, serial, text, timestamp } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod/v4";

export const cateringRequestsTable = pgTable("catering_requests", {
  id: serial("id").primaryKey(),
  fullName: text("full_name").notNull(),
  email: text("email").notNull(),
  phone: text("phone").notNull(),
  eventType: text("event_type").notNull(),
  eventDate: date("event_date", { mode: "string" }).notNull(),
  guestCount: integer("guest_count").notNull(),
  itemsRequested: text("items_requested").notNull(),
  budgetRange: text("budget_range"),
  specialRequests: text("special_requests"),
  status: text("status").notNull().default("new"),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const insertCateringRequestSchema = createInsertSchema(
  cateringRequestsTable,
).omit({ id: true, createdAt: true, status: true });
export type InsertCateringRequest = z.infer<
  typeof insertCateringRequestSchema
>;
export type CateringRequestRow = typeof cateringRequestsTable.$inferSelect;
