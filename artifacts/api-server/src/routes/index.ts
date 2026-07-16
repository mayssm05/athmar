import { Router, type IRouter } from "express";
import healthRouter from "./health";
import menuRouter from "./menu";
import cateringRouter from "./catering";

const router: IRouter = Router();

router.use(healthRouter);
router.use(menuRouter);
router.use(cateringRouter);

export default router;
