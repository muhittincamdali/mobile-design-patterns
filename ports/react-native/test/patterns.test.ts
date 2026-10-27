import { describe, expect, it } from "vitest";

import {
    type EditCommand,
    fail,
    idle,
    type Loadable,
    startLoading,
    StateMachine,
    succeed,
    UndoStack,
    valueOf,
} from "../src";

type Checkout = "cart" | "paying" | "paid" | "failed";
type Action = "pay" | "succeed" | "fail" | "retry";

function checkout(): StateMachine<Checkout, Action> {
    return new StateMachine<Checkout, Action>("cart", (state, action) => {
        if (
            (state === "cart" && action === "pay") ||
            (state === "failed" && action === "retry")
        )
            return "paying";
        if (state === "paying" && action === "succeed") return "paid";
        if (state === "paying" && action === "fail") return "failed";
        return undefined;
    });
}

const addTag = (tag: string): EditCommand<readonly string[]> => ({
    name: `Add ${tag}`,
    apply: (tags) => [...tags, tag],
    revert: (tags) => tags.slice(0, -1),
});

describe("Loadable", () => {
    it("keeps the value on screen through a reload and a failure", () => {
        let state: Loadable<number> = idle;
        state = startLoading(state);
        expect(state).toEqual({ status: "loading" });
        state = succeed(1);
        state = startLoading(state);
        expect(state).toEqual({ status: "loading", previous: 1 });
        state = fail(state, "offline");
        expect(state).toEqual({
            status: "failed",
            error: "offline",
            previous: 1,
        });
        expect(valueOf(state)).toBe(1);
    });

    it("returns the same state when a load is already running", () => {
        const state: Loadable<number> = { status: "loading", previous: 7 };
        expect(startLoading(state)).toBe(state);
    });

    it("keeps falsy values such as 0 and the empty string", () => {
        expect(startLoading(succeed(0))).toEqual({
            status: "loading",
            previous: 0,
        });
        expect(fail(succeed(""), "x")).toEqual({
            status: "failed",
            error: "x",
            previous: "",
        });
    });

    it("has no value after a failed first load", () => {
        const state = fail(startLoading<number>(idle), new Error("offline"));
        expect(valueOf(state)).toBeUndefined();
        expect(state).not.toHaveProperty("previous");
    });
});

describe("StateMachine", () => {
    it("refuses events that are not allowed and keeps the state", () => {
        const machine = checkout();
        expect(machine.send("pay")).toEqual({
            from: "cart",
            event: "pay",
            to: "paying",
        });
        expect(machine.send("pay")).toBeUndefined();
        expect(machine.state).toBe("paying");
    });

    it("retries after a failure and accepts nothing once paid", () => {
        const machine = checkout();
        machine.send("pay");
        machine.send("fail");
        expect(machine.canSend("retry")).toBe(true);
        machine.send("retry");
        machine.send("succeed");
        expect(machine.state).toBe("paid");
        expect(
            (["pay", "succeed", "fail", "retry"] as const).filter((action) =>
                machine.canSend(action),
            ),
        ).toEqual([]);
    });
});

describe("UndoStack", () => {
    it("undoes, redoes and clears redo on a new command", () => {
        const editor = new UndoStack<readonly string[]>([]);
        editor.perform(addTag("a"));
        editor.perform(addTag("b"));
        expect(editor.undoName).toBe("Add b");
        expect(editor.undo()).toBe(true);
        expect(editor.document).toEqual(["a"]);
        expect(editor.redoName).toBe("Add b");
        expect(editor.redo()).toBe(true);
        editor.undo();
        editor.perform(addTag("c"));
        expect(editor.canRedo).toBe(false);
        expect(editor.document).toEqual(["a", "c"]);
    });

    it("caps the history at the limit", () => {
        const editor = new UndoStack<readonly string[]>([], 2);
        for (const tag of ["a", "b", "c"]) editor.perform(addTag(tag));
        expect([editor.undo(), editor.undo(), editor.undo()]).toEqual([
            true,
            true,
            false,
        ]);
        expect(editor.document).toEqual(["a"]);
    });

    it.each([0, -3, Number.NaN, Number.POSITIVE_INFINITY, 0.5])(
        "treats a limit of %s as 1",
        (limit) => {
            const editor = new UndoStack<readonly string[]>([], limit);
            expect(editor.limit).toBe(1);
            editor.perform(addTag("a"));
            editor.perform(addTag("b"));
            expect(editor.undo()).toBe(true);
            expect(editor.undo()).toBe(false);
        },
    );

    it("rounds a fractional limit down", () => {
        expect(new UndoStack([], 2.9).limit).toBe(2);
    });
});
