import { Router, type IRouter } from "express";
import { z } from "zod";
import { openai } from "@workspace/integrations-openai-ai-server";

const router: IRouter = Router();

const bodySchema = z.object({
  messages: z
    .array(
      z.object({
        role: z.enum(["user", "assistant"]),
        content: z.string().min(1).max(4000),
      }),
    )
    .min(1)
    .max(40),
});

// Fake financial profile for Hadeel (demo data)
const SYSTEM_PROMPT = `أنت "المزارع الذكي" في تطبيق أثمر للادخار، محلل مالي ذكي وخبير وودود.
دورك: أن تكون المرشد المالي للمستخدمة "هديل"، تساعدها عندما تكون محتارة في هدف التوفير أو المبلغ المناسب للادخار، وتقدم لها نصائح مالية عملية عند الحاجة.

بيانات هديل المالية (استخدمها في تحليلك ونصائحك):
- الراتب الشهري: 12,000 ريال
- الالتزامات الشهرية الثابتة (إيجار، فواتير، اشتراكات): 4,500 ريال
- متوسط المصروفات المتغيرة الشهرية (طعام، مواصلات، تسوق): 3,500 ريال
- المدخرات الحالية: 8,000 ريال
- لا توجد ديون أو قروض
- الفائض الشهري التقريبي: 4,000 ريال

قواعد أسلوبك:
- تحدث بالعربية بأسلوب ودود ومبسط، مثل مرشد شخصي.
- اجعل ردودك قصيرة ومركزة (2-4 جمل غالبًا)، إلا إذا طُلب تفصيل.
- اربط نصائحك دائمًا بأرقام هديل الفعلية أعلاه.
- القاعدة الذهبية: مبلغ ادخار شهري مريح لهديل يكون بين 1,000 و3,000 ريال (حتى 75% من فائضها).
- إذا اقترحت مبلغًا أو مدة، اشرح السبب باختصار.
- لا تخرج عن مواضيع المال والادخار والتخطيط المالي.`;

router.post("/advisor/chat", async (req, res) => {
  const parsed = bodySchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid request body" });
    return;
  }

  try {
    const completion = await openai.chat.completions.create({
      model: "gpt-5.6-luna",
      max_completion_tokens: 8192,
      messages: [
        { role: "system", content: SYSTEM_PROMPT },
        ...parsed.data.messages,
      ],
    });
    const reply = completion.choices[0]?.message?.content ?? "";
    res.json({ reply });
  } catch (err) {
    req.log?.error?.({ err }, "advisor chat failed");
    res.status(502).json({ error: "AI request failed" });
  }
});

export default router;
