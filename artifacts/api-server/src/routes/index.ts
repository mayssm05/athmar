import { Router, type IRouter } from "express";
import healthRouter from "./health";
import menuRouter from "./menu";
import cateringRouter from "./catering";
import advisorRouter from "./advisor";

const router: IRouter = Router();

router.use(healthRouter);
router.use(menuRouter);
router.use(cateringRouter);
router.use(advisorRouter);

export default router;
