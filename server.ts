import serve from "koa-static";
import koaBody from "koa-body";
import Router from "@koa/router";
import Koa from "koa";
const PocketBase = require("pocketbase/cjs");

const pb = new PocketBase("http://127.0.0.1:8090");

const app = new Koa();

app.use(koaBody());
app.use(serve("./cc"));

const router = new Router();

router.get("/", (ctx, next) => {
	console.log("HERE");
	console.log(ctx.request.body);
	// ctx.body = "Hello World";
});

router.post("/items", async (ctx, next) => {
	const body = ctx.request.body;
	console.log(body.data);

	const { x, y, z } = body.coords;
	console.log({ x, y, z });

	for (let side of ["left", "right"]) {
		if (!body.data[side]) continue;
		let chest;
		try {
			chest = await pb.collection("chest").getFirstListItem(`side="${side}"`, {
				filter: `x = ${x} && y = ${y} && z = ${z} && side="${side}"`,
			});
			console.log({ chest });
			if (!chest) throw new Error("No chest found");
		} catch (error) {
			// if (!chest)
			chest = await pb.collection("chest").create({ x, y, z, side });
		}
		console.log(side);
		for (let i = 0; i < body.data[side].length; i++) {
			const item = body.data[side][i];
			if (!item) continue;
			const data = {
				name: item?.name ?? null,
				displayName: item?.displayName ?? null,
				count: item?.count ?? null,
				maxCount: item?.maxCount ?? null,
				enchantments: item?.enchantments ?? null,
				index: i + 1,
				chest: chest.id,
			};
			console.log({ item });
			let record;
			try {
				record = await pb
					.collection("items")
					.getFirstListItem(`chest=${chest.id}`, {
						filter: `index = ${i}`,
					});
				if (!record || record.index != i + 1)
					throw new Error("No record found");
				record = await pb.collection("items").update(record.id, data);
			} catch (error) {
				// if (!chest)
				record = await pb.collection("items").create(data);
			}
			console.log(i, record);
		}
	}
	// console.log(Object.keys(body));
	ctx.body = true;
	return;
});

app.use(router.routes()).use(router.allowedMethods());

app.listen(5500, () => {
	console.log("Server running on port 5500");
});
