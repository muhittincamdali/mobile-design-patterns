// @vitest-environment jsdom
import { act, renderHook, waitFor } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { useLoadable } from "../src";

function deferred<T>() {
    let resolve!: (value: T) => void;
    let reject!: (error: unknown) => void;
    const promise = new Promise<T>((res, rej) => {
        resolve = res;
        reject = rej;
    });
    return { promise, resolve, reject };
}

describe("useLoadable", () => {
    it("loads, then keeps the list on screen while a refresh fails", async () => {
        let next = deferred<string[]>();
        const { result } = renderHook(() => useLoadable(() => next.promise));
        expect(result.current.state).toEqual({ status: "idle" });

        let load!: Promise<void>;
        act(() => {
            load = result.current.reload();
        });
        expect(result.current.state).toEqual({ status: "loading" });
        await act(async () => {
            next.resolve(["a", "b"]);
            await load;
        });
        expect(result.current.state).toEqual({
            status: "loaded",
            value: ["a", "b"],
        });

        next = deferred();
        act(() => {
            load = result.current.reload();
        });
        expect(result.current.state).toEqual({
            status: "loading",
            previous: ["a", "b"],
        });
        await act(async () => {
            next.reject(new Error("offline"));
            await load;
        });
        await waitFor(() => expect(result.current.state.status).toBe("failed"));
        expect(result.current.state).toMatchObject({ previous: ["a", "b"] });
    });

    it("drops the result of a load that a newer load overtook", async () => {
        const answers = [deferred<string>(), deferred<string>()];
        let call = 0;
        const { result } = renderHook(() =>
            useLoadable(() => answers[call++]!.promise),
        );
        let first!: Promise<void>;
        let second!: Promise<void>;
        act(() => {
            first = result.current.reload();
            second = result.current.reload();
        });
        await act(async () => {
            answers[1]!.resolve("new");
            await second;
            answers[0]!.resolve("old");
            await first;
        });
        expect(result.current.state).toEqual({
            status: "loaded",
            value: "new",
        });
    });

    it("ignores a result that arrives after unmount", async () => {
        const answer = deferred<number>();
        const { result, unmount } = renderHook(() =>
            useLoadable(() => answer.promise),
        );
        let load!: Promise<void>;
        act(() => {
            load = result.current.reload();
        });
        unmount();
        answer.resolve(1);
        await expect(load).resolves.toBeUndefined();
        expect(result.current.state).toEqual({ status: "loading" });
    });
});
