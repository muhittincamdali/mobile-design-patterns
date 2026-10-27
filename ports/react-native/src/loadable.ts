/**
 * The state of a value that a screen loads asynchronously: the view state pattern.
 *
 * One discriminated union replaces separate `isLoading`, `error` and `data` fields, so a
 * screen is never loading and failed at the same time. A reload or a failure keeps the value
 * that is on screen in `previous`.
 */
export type Loadable<T> =
    | { readonly status: "idle" }
    | { readonly status: "loading"; readonly previous?: T }
    | { readonly status: "loaded"; readonly value: T }
    | {
          readonly status: "failed";
          readonly error: unknown;
          readonly previous?: T;
      };

export const idle: Loadable<never> = Object.freeze({ status: "idle" });

/** The newest value in any state: the loaded value, or the one kept from an earlier load. */
export function valueOf<T>(state: Loadable<T>): T | undefined {
    switch (state.status) {
        case "idle":
            return undefined;
        case "loaded":
            return state.value;
        case "loading":
        case "failed":
            return state.previous;
    }
}

/** Moves to `loading` and keeps the current value; returns `state` itself while loading. */
export function startLoading<T>(state: Loadable<T>): Loadable<T> {
    if (state.status === "loading") return state;
    const previous = valueOf(state);
    return previous === undefined
        ? { status: "loading" }
        : { status: "loading", previous };
}

/** Moves to `loaded`. */
export function succeed<T>(value: T): Loadable<T> {
    return { status: "loaded", value };
}

/** Moves to `failed` and keeps the current value. */
export function fail<T>(state: Loadable<T>, error: unknown): Loadable<T> {
    const previous = valueOf(state);
    return previous === undefined
        ? { status: "failed", error }
        : { status: "failed", error, previous };
}
